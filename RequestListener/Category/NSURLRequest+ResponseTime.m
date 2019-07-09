//
//  NSURLRequest+ResponseTime.m
//  Liaodao
//
//  Created by SGQ on 2019/6/19.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "NSURLRequest+ResponseTime.h"
#import <Objc/Runtime.h>

@implementation NSURLRequest (ResponseTime)

- (NSDate *)startDate {
    return objc_getAssociatedObject(self, @selector(startDate));
}

- (NSDate *)endDate {
    return objc_getAssociatedObject(self, @selector(endDate));
}

- (void)setStartDate:(NSDate *)startDate {
    objc_setAssociatedObject(self, @selector(startDate), startDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEndDate:(NSDate *)endDate {
    objc_setAssociatedObject(self, @selector(endDate), endDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)responseTime {
    if (self.startDate && self.endDate) {
        return [self.endDate timeIntervalSinceDate:self.startDate];
    }
    
    return -1;
}

@end
