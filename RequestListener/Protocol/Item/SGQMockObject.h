//
//  SGQMockObject.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  一个被拦截到的请求

#import "SGQMockRequest.h"
#import "SGQMockResponse.h"

@interface SGQMockObject : NSObject

@property (nonatomic, strong) SGQMockRequest *request;
@property (nonatomic, strong) SGQMockResponse *response;

@end

