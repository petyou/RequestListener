//
//  SGQURLProtocol.m
//  Liaodao
//
//  Created by SGQ on 2019/6/17.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQURLProtocol.h"
#import "SGQRequestListener.h"
#import "SGQMockObject.h"
#import "NSURLRequest+ResponseTime.h"

static NSString * const kHandedRequestKey = @"kHandedRequestKey";

@implementation SGQURLProtocol

/*
 是否对这个请求进行拦截
 返回YES，则这个request还会进入后续方法调用
 返回NO，则不会对这个request有任何影响了。
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([[SGQRequestListener sharedInstance] isRequestURLInBlackList:request]) {
        return NO;
    }
    
    // 这个标记在 startLoading 方法中打上，是为了防止死循环。因为我们在 startLoading方法发出去的请求也会被拦截到进到这里
    if ([NSURLProtocol propertyForKey:kHandedRequestKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

/// cache这里不管
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

/// 一般可以在这里copy出一个可变的request，进行属性的修改，然后返回。后续则会这个返回的request发出请求
+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request {
    return request;
}


/*
 最终那个被拦截的request或者会进到这里，我们在这里发出请求，获取返回数据。
 同时也将数据回调给原始的client
 */
- (void)startLoading {
    
    NSMutableURLRequest *request = [self.request mutableCopy];
    request.startDate = [NSDate date];
    [NSURLProtocol setProperty:@(YES) forKey:kHandedRequestKey inRequest:request];
    
    id<NSURLProtocolClient> client = [self client];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               request.endDate = [NSDate date];
                               if (error) {
                                   [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
                               } else {
                                   [client URLProtocol:self didReceiveResponse:response
                                    cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                                   [client URLProtocol:self didLoadData:data];
                                   [client URLProtocolDidFinishLoading:self];
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   SGQMockObject *loadingObject = [SGQMockObject objectWithRequest:request response:response responseData:data error:error responseTime:request.responseTime];
                                   [[SGQRequestListener sharedInstance] addAnObject:loadingObject];
                               });
                           }];
#pragma clang diagnostic pop
    
    
}

- (void)stopLoading { }

@end



//+ (void)startHook {
//    // for NSURLConnection
//    [NSURLProtocol registerClass:[SGQURLProtocol class]];
//
//    // for NSURLSession
//    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
//    SEL selector = NSSelectorFromString(@"protocolClasses");
//    Method originalMethod = class_getInstanceMethod(cls, selector);
//    Method stubMethod = class_getInstanceMethod(self, selector);
//    if (!originalMethod || !stubMethod) {
//        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
//    }
//    method_exchangeImplementations(originalMethod, stubMethod);
//
//    // for WKWebView
//    Class class = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
//    SEL wkSelector = NSSelectorFromString(@"registerSchemeForCustomProtocol:");;
//    if ([(id)class respondsToSelector:selector]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [(id)class performSelector:wkSelector withObject:@"http"];
//        [(id)class performSelector:wkSelector withObject:@"https"];
//#pragma clang diagnostic pop
//    }
//}
//
//- (NSArray *)protocolClasses {
//    return @[[SGQURLProtocol class]];
//}
