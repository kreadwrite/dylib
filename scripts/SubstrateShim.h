#ifndef SUBSTRATE_SHIM_H
#define SUBSTRATE_SHIM_H
#import <objc/runtime.h>
#import <objc/message.h>

void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);
void MSHookFunction(void *symbol, void *replace, void **result);

#endif
