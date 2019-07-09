//
// SGQToast.h
// NOEETY
//
//  Created by SGQ on 2017/10/18.
//  Copyright © 2017年 Hanrovey-NOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGQToast : UIView
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;
@end

