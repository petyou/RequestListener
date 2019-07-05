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

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([[SGQRequestListener sharedInstance] isRequestURLInBlackList:request]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:kHandedRequestKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request {
    return request;
}

- (void)startLoading {
    
    NSMutableURLRequest *request = [self.request mutableCopy];
    request.startDate = [NSDate date];
    [NSURLProtocol setProperty:@(YES) forKey:kHandedRequestKey inRequest:request];
    
    id<NSURLProtocolClient> client = [self client];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
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
                                   SGQMockObject *loadingObject = [SGQMockObject new];
                                   loadingObject.request = [[SGQMockRequest alloc] initWithRequest:request];
                                   loadingObject.response = [[SGQMockResponse alloc] initWitResponse:(NSHTTPURLResponse *)response data:data responseTime:request.responseTime error:error];
                                   [[SGQRequestListener sharedInstance] addAnObject:loadingObject];
                               });
                           }];
    
    
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
