#import "SubstrateShim.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <stdlib.h>
#import <string.h>
#import <dlfcn.h>
#import <sys/mman.h>
#import <libkern/OSCacheControl.h>

// MSHookMessageEx: Replace an ObjC method implementation
void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result) {
    if (result != NULL) {
        Method method = class_getInstanceMethod(_class, sel);
        if (method != NULL) {
            *result = method_getImplementation(method);
        } else {
            Method classMethod = class_getClassMethod(_class, sel);
            if (classMethod != NULL) {
                *result = method_getImplementation(classMethod);
            } else {
                *result = NULL;
            }
        }
    }

    Method method = class_getInstanceMethod(_class, sel);
    if (method != NULL) {
        method_setImplementation(method, imp);
        return;
    }

    Method classMethod = class_getClassMethod(_class, sel);
    if (classMethod != NULL) {
        method_setImplementation(classMethod, imp);
        return;
    }

    class_addMethod(_class, sel, imp, "v@:");
}

// MSHookFunction: Patch a C/ARM64 function with a trampoline
void MSHookFunction(void *symbol, void *replace, void **result) {
    if (symbol == NULL || replace == NULL) return;

    size_t pageSize = sysconf(_SC_PAGESIZE);

    // Allocate executable pages for the original-function trampoline
    void *origPage = mmap(NULL, pageSize,
                          PROT_READ | PROT_WRITE | PROT_EXEC,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (origPage == MAP_FAILED) return;

    uint32_t *src = (uint32_t *)symbol;
    uint32_t *dst = (uint32_t *)origPage;

    // Save the original 4 bytes (one ARM64 instruction)
    uint32_t origInstr = src[0];

    // Build the "original" trampoline that %orig will call:
    //   origInstr              ; displaced original instruction
    //   ldr  x16, [pc, #8]    ; load &symbol+4 from data pool
    //   br   x16               ; jump back to symbol+4 (right after our patch)
    //   <8 bytes: uint64 address of (symbol + 4)>
    dst[0] = origInstr;
    dst[1] = 0x58000050;  // ldr x16, [pc, #8]
    dst[2] = 0xD61F0200;  // br x16
    *((uint64_t *)&dst[3]) = (uint64_t)((uintptr_t)symbol + 4);

    // Flush the instruction cache for the trampoline
    sys_icache_invalidate(origPage, 16);

    if (result != NULL) {
        *result = origPage;
    }

    // Now make the target page writable so we can patch symbol in-place
    uintptr_t pageBase = (uintptr_t)symbol & ~(pageSize - 1);
    mprotect((void *)pageBase, pageSize, PROT_READ | PROT_WRITE | PROT_EXEC);

    // Overwrite the first 4 bytes of symbol with:
    //   ldr  x16, [pc, #0]    ; load &replace from data pool right after
    //   <4 bytes: uint32 padding / upper 32 of address — not used, skip>
    // Wait — ARM64 ldr literal only loads 4/8 bytes from a 4-aligned offset.
    // Better: use the classic 16-byte inline patch:
    //   ldr  x16, [pc, #8]    ; 0x58000050
    //   br   x16               ; 0xD61F0200
    //   <8 bytes: uint64 replace address>

    // But that's 16 bytes (4 instructions) which overwrites 4 original instructions.
    // MSHookFunction typically only needs to displace 1 instruction on ARM64
    // because every instruction is 4 bytes and PC-relative branches are rare.
    // However, to keep it simple and reliable, we use the 16-byte patch format
    // that replaces 4 instructions at the target:

    // Re-save the first 4 original instructions for the trampoline
    // (we already saved one; now save all 4 that we'll overwrite)
    dst[0] = src[0];
    dst[1] = src[1];
    dst[2] = src[2];
    dst[3] = src[3];
    // The jump-back after the saved instructions
    dst[4] = 0x58000050;  // ldr x16, [pc, #8]
    dst[5] = 0xD61F0200;  // br x16
    *((uint64_t *)&dst[6]) = (uint64_t)((uintptr_t)symbol + 16); // jump to symbol+16

    // Flush trampoline again (it's now 32 bytes)
    sys_icache_invalidate(origPage, 32);

    // Patch the target:
    src[0] = 0x58000050;  // ldr x16, [pc, #8]
    src[1] = 0xD61F0200;  // br x16
    *((uint64_t *)&src[2]) = (uint64_t)replace;

    // Restore target page permissions
    mprotect((void *)pageBase, pageSize, PROT_READ | PROT_EXEC);

    // Flush the patched site
    sys_icache_invalidate(symbol, 16);
}
