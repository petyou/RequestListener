//
//  NSURLRequest+ResponseTime.h
//  Liaodao
//
//  Created by SGQ on 2019/6/19.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (ResponseTime)

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

- (NSTimeInterval)responseTime;

@end
