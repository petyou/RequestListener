//
//  UIView+ShowWithBackView.h
//  Liaodao
//
//  Created by SGQ on 2019/7/1.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShowWithBackView)

/// 蒙层透明度渐变显示, 蒙层颜色黑色
- (void)sgq_showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

/// 移除 动画可选
- (void)sgq_hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

@end

