//
// SGQUtility.h
// NOEETY
//
//  Created by SGQ on 2017/10/18.
//  Copyright © 2017年 Hanrovey-NOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGQUtility : NSObject

+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;

+ (NSData *)inflatedDataFromCompressedData:(NSData *)compressedData;

+ (NSDictionary<NSString *, id> *)dictionaryFromQuery:(NSString *)query;

@end

