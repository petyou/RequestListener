//
//  SGQMockObject.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQMockObject.h"

@implementation SGQMockObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n%@", self.request, self.response];
}

@end
