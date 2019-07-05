//
//  SGQNSURLConnectionHook.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQNSURLConnectionHook.h"
#import "SGQURLProtocol.h"

@implementation SGQNSURLConnectionHook

- (void)load {
    [NSURLProtocol registerClass:[SGQURLProtocol class]];
}

- (void)unload {
    [NSURLProtocol unregisterClass:[SGQURLProtocol class]];
}

@end
