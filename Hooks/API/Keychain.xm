
#include <substrate.h>
#include <Security/Security.h>
#import "../Utils/SQLiteStorage.h"
#import "../Utils/PlistObjectConverter.h"
#import "../Utils/CallStackInspector.h"
#import "../SharedDefine.pch"
// Hook SecItemAdd()
static OSStatus (*original_SecItemAdd)(CFDictionaryRef attributes, CFTypeRef *result);

static OSStatus replaced_SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result){

    OSStatus origResult = original_SecItemAdd(attributes, result);

    // Need the call stack inspector or we get into a weird infinite loop of SecItemAdd() calls
    // because SecIdentityCopyCertificate() seems to call SecItemAdd(), or something...
    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemAdd"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertSecItemAttributesDict:attributes] withKey:@"attributes"];
        [tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"result"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
    }

    return origResult;
}


// Hook SecItemCopyMatching()
static OSStatus (*original_SecItemCopyMatching)(CFDictionaryRef query, CFTypeRef *result);

static OSStatus replaced_SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result){
    OSStatus origResult = original_SecItemCopyMatching(query, result);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemCopyMatching"];
    [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
    [tracer addArgFromPlistObject:objectTypeNotSupported withKey:@"result"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return origResult;
}


// Hook SecItemDelete()
static OSStatus (*original_SecItemDelete)(CFDictionaryRef query);

static OSStatus replaced_SecItemDelete(CFDictionaryRef query){
    OSStatus origResult = original_SecItemDelete(query);
    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemDelete"];
    [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
    [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
    [traceStorage saveTracedCall: tracer];
    [tracer release];
    return origResult;
}


// Hook SecItemUpdate()
static OSStatus (*original_SecItemUpdate)(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);

static OSStatus replaced_SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate){
    OSStatus origResult = original_SecItemUpdate(query, attributesToUpdate);

    if ([CallStackInspector wasDirectlyCalledByApp]) {
        CallTracer *tracer = [[CallTracer alloc] initWithClass:@"C" andMethod:@"SecItemUpdate"];
        [tracer addArgFromPlistObject:(NSDictionary*)query withKey:@"query"];
        [tracer addArgFromPlistObject:[PlistObjectConverter convertSecItemAttributesDict:attributesToUpdate] withKey:@"attributesToUpdate"];
        [tracer addReturnValueFromPlistObject: [NSNumber numberWithInt:origResult]];
        [traceStorage saveTracedCall: tracer];
        [tracer release];
}
    return origResult;
}



extern void init_Keychain_hook(){
    MSHookFunction((void *)SecItemAdd, (void *)replaced_SecItemAdd, (void **) &original_SecItemAdd);
    MSHookFunction((void *)SecItemCopyMatching, (void *)replaced_SecItemCopyMatching, (void **) &original_SecItemCopyMatching);
    MSHookFunction((void *)SecItemDelete, (void *)replaced_SecItemDelete, (void **) &original_SecItemDelete);
    MSHookFunction((void *)SecItemUpdate, (void *)replaced_SecItemUpdate, (void **) &original_SecItemUpdate);
}

