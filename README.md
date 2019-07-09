### 使用
```
pod 'RequestListener', :configurations => ['Debug']

// 注意，需要在设置根window后才能调用
[[SGQRequestListener sharedInstance] startMock];
```

### Target
监听 app 内所有的网络请求，并将请求的参数和返回值显示在手机端。相当于自己抓自己的包，这样不在电脑前也能够精确的观察接口动态，或者在接手一个新的项目时，可以清楚的看到某个界面的接口请求情况，帮助理清楚界面逻辑。Demo里面监测的是 `UIWebView`，实际在项目里面监测api接口效果更佳。

![IMG_2071.PNG](https://upload-images.jianshu.io/upload_images/4103407-0d9de83cab7ecd3e.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 原理
原理是使用 `NSURLProtocol` 拦截所有 `URL Loading System` 中发出 `request` 请求。 拦截到之后，以我们的方式发出这个请求，这样这个请求的返回数据就能被我们统一捕获。同时，我们将返回的数据回调给原始发出者，以保证app正常运行。在捕获返回数据和请求本身的参数后就能完整的将一次api调用显示出来了。

### NSURLProtocol介绍
`NSURLProtocol` 是属于 `Foundation` 框架里的 [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) 的一部分。它是一个抽象类, 需要继承它后, 重写一系列父类的方法, 且在向系统注册后, 就可以拦截到所有来自 `URL Loading System` 中发出 `request` 请求, 包括使用 `NSURLConnection` 和 `NSURLSession ` 发出去的请求, 使用这两者的第三方框架就也能监听到, 比如 `AFNetWorking`。而视图方面, 通过`UIWebView`、`WKWebView` 发出去的请求也能被监听到（`WKWebView` 的拦截会有些问题）。

[图片上传失败...(image-1d7817-1562661575038)]  

拦截到后我们可以修改原来 `requeset`，我们可以什么都不做，那么这个请求的行为就会跟之前的一模一样。 有趣的是我们也可以对它进行修改，比如给它添加参数，让这个请求行为发生变化。或者对返回的 `response` 进行修改，亦或干脆重定向到新的资源，你想要A，我返回给你你B。总之, 是否返回数据, 返回什么数据, 已经由我们决定了。  

这里我们让这个请求以我们写的方式发送出去，以便拿到服务端返回的数据。

### 拦截请求的方式
* 对于 `UIWebView` 和 `NSURLConnection` 只需要构建 `NSURLProtocol ` 的子类，在子类中重载必要的方法, 并向系统注册`[NSURLProtocol registerClass:[SGQURLProtocol class]];` 即可拦截.
 
 		#import <Foundation/Foundation.h>

		@interface SGQURLProtocol : NSURLProtocol

		@end
		
* 对于 `NSURLSession`，需要通过配置 `NSURLSessionConfiguration` 对象的 `protocolClasses` 属性

		NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    	sessionConfiguration.protocolClasses =  @[[SGQURLProtocol class]]; 
  这是原理，但是我们不能侵入别人写好的代码，在里面加上这句代码。于是我们使用 `method swizzing`
  		
		- (void)load {
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
	


* 对于 `WKWebView`,除了上述操作外, 由于其基于 `wekkit` 内核, 使用到了 `WKBrowsingContextController` 和 `registerSchemeForCustomProtocol`。 我们需要通过反射的方式拿到了私有的 `class` & `selector`。通过 `kvc` 取到`browsingContextController`，通过把注册把 `http` 和 `https` 请求交给 `NSURLProtocol` 处理.

		+ (void)registerForWKWebView {
    		Class class = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    		SEL selector = NSSelectorFromString(@"registerSchemeForCustomProtocol:");;
    		if ([(id)class respondsToSelector:selector]) {
       		 [(id)class performSelector:selector withObject:@"http"];
       		 [(id)class performSelector:selector withObject:@"https"];
   		 	}
		}
 这里需要声明的是，对于 `WKWebView`里面的请求，这样注册后，虽然可以拦截到，但是由于系统原因，会导致POST请求的请求体会丢失，导致请求本身会失败[WKWebView NSURLProtocol问题](https://blog.csdn.net/tencent_bugly/article/details/54668721/)，所以我们主要还是监听 app 内本身的请求。


### NSURLProtocol子类中需要重写的方法


```
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

/// cache啥的这里不管
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
                                   SGQMockObject *loadingObject = [SGQMockObject new];
                                   loadingObject.request = [[SGQMockRequest alloc] initWithRequest:request];
                                   loadingObject.response = [[SGQMockResponse alloc] initWitResponse:(NSHTTPURLResponse *)response data:data responseTime:request.responseTime error:error];
                                   [[SGQRequestListener sharedInstance] addAnObject:loadingObject];
                               });
                           }];
#pragma clang diagnostic pop
    
    
}

- (void)stopLoading { }

@end
```

可以看到，在这里我们成功地拿到了一次请求的参数部分和返回值部分，解析后显示出来就行了。在公司项目中使用，可以在后台界面设置开关打开，打开后就能监测接口返回数据了。

```
SGQMockObject *loadingObject = [SGQMockObject new];
loadingObject.request = [[SGQMockRequest alloc] initWithRequest:request];
loadingObject.response = [[SGQMockResponse alloc] initWitResponse:(NSHTTPURLResponse *)response data:data responseTime:request.responseTime error:error];
[[SGQRequestListener sharedInstance] addAnObject:loadingObject];
```
