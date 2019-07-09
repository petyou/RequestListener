//
//  SGQMockResponse.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  记录请求响应的数据

#import <Foundation/Foundation.h>

@interface SGQMockResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, assign, readonly) NSTimeInterval responseTime;
@property (nonatomic, strong, readonly) NSString *textEncodingName;

- (instancetype)initWitResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                   responseTime:(NSTimeInterval)responseTime
                          error:(NSError *)error;

@end

