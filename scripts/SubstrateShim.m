#import "SubstrateShim.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <stdlib.h>
#import <string.h>
#import <dlfcn.h>

// MSHookMessageEx: Replace an ObjC method implementation
// This is straightforward - just use method_setImplementation
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result) {
    // Get the old IMP before replacing
    if (result != NULL) {
        Method method = class_getInstanceMethod(_class, sel);
        if (method != NULL) {
            *result = method_getImplementation(method);
        } else {
            // Try class method
            Method classMethod = class_getClassMethod(_class, sel);
            if (classMethod != NULL) {
                *result = method_getImplementation(classMethod);
            } else {
                *result = NULL;
            }
        }
    }
    
    // Replace the implementation
    // For instance methods
    Method method = class_getInstanceMethod(_class, sel);
    if (method != NULL) {
        method_setImplementation(method, imp);
        return;
    }
    
    // For class methods
    Method classMethod = class_getClassMethod(_class, sel);
    if (classMethod != NULL) {
        method_setImplementation(classMethod, imp);
        return;
    }
    
    // If neither exists, add the method
    class_addMethod(_class, sel, imp, "v@:");
}

// MSHookFunction: Replace a C function implementation
// Uses a simple inline assembly trampoline for ARM64
// The trampoline redirects calls from symbol -> replace,
// and writes the original instructions to *result so the
// hook can call %orig

#ifdef __arm64__
// ARM64 trampoline structure
// Jump to replace: 
//   ldr x16, [pc, #8]   ; load address from data
//   br x16              ; jump to it
//   <8 bytes: address of replace function>

// Original instructions backup:
//   We need to create a "resume" trampoline that:
//   1. Executes the displaced original instructions
//   2. Jumps back to symbol+4 (after the displaced instructions)

void MSHookFunction(void *symbol, void *replace, void **result) {
    if (symbol == NULL || replace == NULL) return;
    
    // Allocate trampoline pages
    // For the hook: 16 bytes (2 instructions + 8 bytes address)
    // For the original: 16 bytes (original instruction + jump back)
    size_t pageSize = 4096;
    void *hookPage = mmap(NULL, pageSize, PROT_READ | PROT_WRITE | PROT_EXEC,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    void *origPage = mmap(NULL, pageSize, PROT_READ | PROT_WRITE | PROT_EXEC,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    
    if (hookPage == MAP_FAILED || origPage == MAP_FAILED) return;
    
    // Build the hook trampoline at symbol:
    // Overwrite the first 16 bytes of symbol with:
    //   ldr x16, [pc, #8]
    //   br x16
    //   <address of replace>
    
    uint32_t *symbolInstr = (uint32_t *)symbol;
    uint64_t replaceAddr = (uint64_t)replace;
    
    // Save original instructions
    uint32_t origInstr0 = symbolInstr[0];
    uint32_t origInstr1 = symbolInstr[1];
    
    // Build original function trampoline
    // This is what %orig calls:
    //   <original instruction 0>
    //   <original instruction 1>  
    //   ldr x16, [pc, #8]    ; load address of symbol+8 (after our hook)
    //   br x16               ; jump back
    //   <8 bytes: address of symbol + 8>
    
    uint32_t *origTramp = (uint32_t *)origPage;
    origTramp[0] = origInstr0;
    origTramp[1] = origInstr1;
    origTramp[2] = 0x58000050; // ldr x16, [pc, #8]
    origTramp[3] = 0xD61F0200; // br x16
    uint64_t *origAddrSlot = (uint64_t *)&origTramp[4];
    *origAddrSlot = (uint64_t)symbol + 8;
    
    if (result != NULL) {
        *result = origTramp;
    }
    
    // Write the hook trampoline at symbol
    symbolInstr[0] = 0x58000050; // ldr x16, [pc, #8]
    symbolInstr[1] = 0xD61F0200; // br x16
    uint64_t *addrSlot = (uint64_t *)&symbolInstr[2];
    *addrSlot = replaceAddr;
    
    // Flush caches
    sys_icache_invalidate(symbol, 16);
    sys_icache_invalidate(origTramp, 24);
}
#else
// Non-ARM64: simple stub that just does direct replacement
void MSHookFunction(void *symbol, void *replace, void **result) {
    // Not implemented for this architecture - just redirect
    if (result != NULL) {
        *result = symbol;
    }
    // This won't actually work on x86 but the binary is ARM64 only
}
#endif

