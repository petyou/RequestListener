//
// SGQUtility.m
// NOEETY
//
//  Created by SGQ on 2017/10/18.
//  Copyright © 2017年 Hanrovey-NOEE. All rights reserved.
//

#import "SGQUtility.h"
#import <zlib.h>


#define kToastViewTag 19911218
#define kToastShowingTime 1.2

@implementation SGQUtility

+ (void)showMessage:(NSString *)message {
    [self showMessage:message duration:kToastShowingTime];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration {
    if (!message.length) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat windowWidth = CGRectGetWidth(window.bounds);
    CGFloat windowHeight = CGRectGetHeight(window.bounds);
    
    UIView *toastView = [window viewWithTag:kToastViewTag];
    if (!toastView) {
        //创建totast底图
        toastView = [[UIView alloc] initWithFrame:CGRectZero];
        toastView.backgroundColor = [UIColor colorWithRed:25/250.0 green:25/250.0 blue:25/250.0 alpha:1.0];
        toastView.tag = kToastViewTag;
        toastView.alpha = 0.85;
        
        //创建显示文字的label
        UILabel * toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        toastLabel.font = [UIFont systemFontOfSize:18];
        toastLabel.numberOfLines = 0;
        toastLabel.textColor = [UIColor whiteColor];
        toastLabel.backgroundColor = [UIColor clearColor];
        toastLabel.tag = 101;
        
        [toastView addSubview:toastLabel];
        [window addSubview:toastView];
        
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:toastView selector:@selector(removeFromSuperview) object:nil];
    }
    
    toastView.userInteractionEnabled = NO;
    UILabel * toastLabel = [toastView viewWithTag:101];
    toastLabel.text = message;
    
    CGFloat maxWidth = windowWidth * 0.7;
    CGFloat maxHeight = 200;
    CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:toastLabel.font} context:nil];
    
    //留边
    UIEdgeInsets insets = UIEdgeInsetsMake(11, 25, 11, 25);
    CGFloat width = rect.size.width + insets.left  + insets.right;
    CGFloat height = rect.size.height + insets.top + insets.bottom;
    
    //在顶部tabbar往上20的位置显示
    toastView.frame = CGRectMake((windowWidth - width) / 2.0, (windowHeight - height) / 2.0, width, height);
    toastView.layer.cornerRadius = height / 2.0;
    toastView.layer.masksToBounds = YES;
    
    toastLabel.bounds = CGRectMake(0,0, rect.size.width, rect.size.height);
    toastLabel.center = CGPointMake(width / 2.0, height / 2.0);
    
    NSTimeInterval timeDelay = kToastShowingTime;
    if (duration > 0) {
        timeDelay =duration;
    }
    [toastView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:timeDelay];
}

// Thanks to the following links for help with this method
// https://www.cocoanetics.com/2012/02/decompressing-files-into-memory/
// https://github.com/nicklockwood/GZIP
+ (NSData *)inflatedDataFromCompressedData:(NSData *)compressedData
{
    NSData *inflatedData = nil;
    NSUInteger compressedDataLength = [compressedData length];
    if (compressedDataLength > 0) {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uInt)compressedDataLength;
        stream.next_in = (void *)[compressedData bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *mutableData = [NSMutableData dataWithLength:compressedDataLength * 1.5];
        if (inflateInit2(&stream, 15 + 32) == Z_OK) {
            int status = Z_OK;
            while (status == Z_OK) {
                if (stream.total_out >= [mutableData length]) {
                    mutableData.length += compressedDataLength / 2;
                }
                stream.next_out = (uint8_t *)[mutableData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([mutableData length] - stream.total_out);
                status = inflate(&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK) {
                if (status == Z_STREAM_END) {
                    mutableData.length = stream.total_out;
                    inflatedData = [mutableData copy];
                }
            }
        }
    }
    return inflatedData;
}

+ (NSDictionary<NSString *, id> *)dictionaryFromQuery:(NSString *)query
{
    NSMutableDictionary<NSString *, id> *queryDictionary = [NSMutableDictionary dictionary];
    
    // [a=1, b=2, c=3]
    NSArray<NSString *> *queryComponents = [query componentsSeparatedByString:@"&"];
    for (NSString *keyValueString in queryComponents) {
        // [a, 1]
        NSArray<NSString *> *components = [keyValueString componentsSeparatedByString:@"="];
        if ([components count] == 2) {
            NSString *key = [[components firstObject] stringByRemovingPercentEncoding];
            id value = [[components lastObject] stringByRemovingPercentEncoding];
            
            // Handle multiple entries under the same key as an array
            id existingEntry = queryDictionary[key];
            if (existingEntry) {
                if ([existingEntry isKindOfClass:[NSArray class]]) {
                    value = [existingEntry arrayByAddingObject:value];
                } else {
                    value = @[existingEntry, value];
                }
            }
            
            [queryDictionary setObject:value forKey:key];
        }
    }
    
    return queryDictionary;
}

@end

