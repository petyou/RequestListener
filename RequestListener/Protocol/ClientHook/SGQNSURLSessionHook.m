//
//  SGQNSURLSessionHook.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQNSURLSessionHook.h"
#import "SGQURLProtocol.h"
#import <objc/runtime.h>

@implementation SGQNSURLSessionHook

- (void)load {
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)unload {
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    return @[[SGQURLProtocol class]];
}
@end
