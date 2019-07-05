//
// SGQToast.m
// NOEETY
//
//  Created by SGQ on 2017/10/18.
//  Copyright © 2017年 Hanrovey-NOEE. All rights reserved.
//

#import "SGQToast.h"
#define kToastViewTag 19911218
#define kToastShowingTime 1.2

@implementation SGQToast

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

@end

