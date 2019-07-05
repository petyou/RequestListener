//
//  SGQRequestListener.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  核心管理者

#import <Foundation/Foundation.h>

@class SGQMockObject;

@interface SGQRequestListener : NSObject

+ (SGQRequestListener *)sharedInstance;

/**
  开启后将接管app内所有URL Loading System的请求，比如NSURLConnection 和 NSURLSession 发出去的请求, 使用这两者的第三方框架就也能监听到, 比如 AFNetWorking，而视图方面, 通过UIWebView、WKWebView 发出去的请求也能被监听到.
 但是注意，WKWebView的请求虽然可以拦截到，但是POST请求的请求体会丢失，导致请求本身会失败（https://blog.csdn.net/tencent_bugly/article/details/54668721/）。所以如果在使用 WKWebView 时，需要关闭
 
 */
- (void)startMock;

/**
  关闭后则对app内所有的请求没有任何影响
 */
- (void)stopMock;


/**
 有些公司在GET请求失败后，会返回一个404页面，可能会多次无意义的加载，此类请求或者你不想要监听的请求可以放到黑名单中。

 @param blackListURLStrings 所有不想监听的请求链接
 */
- (void)addBlackListURLStrings:(NSArray *)blackListURLStrings;




/**
 内部使用
 当前request是否是处于黑名单，如果是，则放过这个请求

 @param request 判断 request.URL.absoluteString
 @return YES: 是处于黑名单中
 */
- (BOOL)isRequestURLInBlackList:(NSURLRequest *)request;

/**
 内部使用
 将拦截到对象交给view显示出来
 
 @param loadingObjct 包装好的对象
 */
- (void)addAnObject:(SGQMockObject *)loadingObjct;

@end

