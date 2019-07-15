//
//  SGQMockObject.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  一个被拦截到的请求

#import <Foundation/Foundation.h>

@interface SGQMockObject : NSObject
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) NSTimeInterval responseTime;

+ (instancetype)objectWithRequest:(NSURLRequest *)request
                       response:(NSURLResponse *)response
                    responseData:(NSData *)responseData
                           error:(NSError *)error
                      responseTime:(NSTimeInterval)responseTime;


- (NSString *)statusCode;

- (NSString *)requstHeaderString;
- (NSString *)requestBodyString;

- (NSString *)responseBodyString;




@end
