//
//  SGQRequestListener.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQRequestListener.h"
#import "SGQNSURLConnectionHook.h"
#import "SGQNSURLSessionHook.h"
#import "SGQViewController.h"
#import "SGQMockObject.h"
#import "SGQHttpClientHook.h"

@interface SGQRequestListener()
@property (nonatomic, strong) NSMutableArray<NSString *> *blackListURLStrings;
@property (nonatomic, strong) NSMutableArray<SGQHttpClientHook*> *hooks;

@property (nonatomic, assign, getter = isStarted) BOOL started;
@property (nonatomic, strong) SGQViewController *netWorkViewController;

@end

@implementation SGQRequestListener

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _started = NO;
        _blackListURLStrings = [NSMutableArray array];
        _hooks = [NSMutableArray array];
        _netWorkViewController = [[SGQViewController alloc] init];
        
        [self registerHook:[[SGQNSURLConnectionHook alloc] init]];
        if (NSClassFromString(@"NSURLSession") != nil) {
            [self registerHook:[[SGQNSURLSessionHook alloc] init]];
        }
    }
    return self;
}

+ (SGQRequestListener *)sharedInstance {
    static SGQRequestListener *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public

- (void)startMock {
    if (!self.isStarted){
        [self loadHooks];
        self.started = YES;
        
        [_netWorkViewController show];
    }
}

- (void)stopMock {
    [self unloadHooks];
    self.started = NO;
    
    [_netWorkViewController removeAllObjects];
    [_netWorkViewController hide];
}

- (void)addBlackListURLStrings:(NSArray *)blackListURLStrings {
    [self.blackListURLStrings addObjectsFromArray:blackListURLStrings];
}

- (BOOL)isRequestURLInBlackList:(NSURLRequest *)request {
    for (NSString *url in self.blackListURLStrings) {
        if ([request.URL.absoluteString containsString:url]) {
            return YES;
        }
    }
    return NO;
}

- (void)addAnObject:(SGQMockObject *)loadingObjct {
    [_netWorkViewController appendNewMockObject:loadingObjct];
}


#pragma mark - Private

- (void)registerHook:(SGQHttpClientHook *)hook {
    if (![self hookWasRegistered:hook]) {
        @synchronized(_hooks) {
            [_hooks addObject:hook];
        }
    }
}

- (BOOL)hookWasRegistered:(SGQHttpClientHook *)aHook {
    @synchronized(_hooks) {
        for (SGQHttpClientHook *hook in _hooks) {
            if ([hook isMemberOfClass: [aHook class]]) {
                return YES;
            }
        }
        return NO;
    }
}

- (void)loadHooks {
    @synchronized(_hooks) {
        for (SGQHttpClientHook *hook in _hooks) {
            [hook load];
        }
    }
}

- (void)unloadHooks {
    @synchronized(_hooks) {
        for (SGQHttpClientHook *hook in _hooks) {
            [hook unload];
        }
    }
}

@end
