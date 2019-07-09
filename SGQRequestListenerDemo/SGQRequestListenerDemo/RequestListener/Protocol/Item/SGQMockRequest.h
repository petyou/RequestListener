//
//  SGQMockRequest.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  记录请求的一些数据

#import <Foundation/Foundation.h>

@interface SGQMockRequest : NSObject

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSData *body;

- (instancetype)initWithRequest:(NSURLRequest *)request;

@end

