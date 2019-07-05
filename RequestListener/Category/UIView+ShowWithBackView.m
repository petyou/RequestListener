//
//  UIView+ShowWithBackView.m
//  Liaodao
//
//  Created by SGQ on 2019/7/1.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "UIView+ShowWithBackView.h"

@implementation UIView (ShowWithBackView)

#pragma mark - Show

- (void)sgq_showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
    if (![UIApplication sharedApplication].isIgnoringInteractionEvents) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    [self sgq_showDisplayView:displayView coverAlpha:0 coverColor:[UIColor blackColor] coverTapedBlock:tapedBlock];
    
    [UIView animateWithDuration:showAnimationInterval animations:^{
        self.sgq_coverView.alpha = coverAlpha;
        showAnimation ? showAnimation():nil;
    } completion:^(BOOL finished) {
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

#pragma mark - Hide

- (void)sgq_hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
    if (self.sgq_currentFirstResponder) {
        [self.sgq_currentFirstResponder becomeFirstResponder];
        self.sgq_currentFirstResponder = nil;
    }
    
    [UIView animateWithDuration:hideAnimationInterval animations:^{
        self.sgq_coverView.alpha = 0;
        hideAnimation ? hideAnimation():nil;
    } completion:^(BOOL finished) {
        [self sgq_removeDisplayView:displayView];
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

- (void)sgq_removeDisplayView:(UIView *)displayView {
    if (self.sgq_currentFirstResponder) {
        [self.sgq_currentFirstResponder becomeFirstResponder];
        self.sgq_currentFirstResponder = nil;
    }
    UIView *coverView = [self sgq_coverView];
    [coverView removeFromSuperview];
    [displayView removeFromSuperview];
    [self setSgq_coverView:nil];
}

#pragma mark - Private

- (void)sgq_showDisplayView:(UIView *)displayView
               coverAlpha:(CGFloat)coverAlpha
               coverColor:(UIColor*)coverColor
          coverTapedBlock:(void(^)(void))tapedBlock
{
    UIView *previousView = [self sgq_currentDisplayView];
    if (previousView) {
        [previousView removeFromSuperview];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.sgq_currentFirstResponder = [self sgq_findFirstResponderInView:window];
    [window endEditing:YES];
    
    self.sgq_tapedBlock = tapedBlock;
    
    if (![self sgq_coverView]) {
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = coverColor;
        coverView.alpha = coverAlpha;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sgq_coverViewTaped)];
        [coverView addGestureRecognizer:tapGesture];
        [self setSgq_coverView:coverView];
        [self addSubview:coverView];
    }
    
    [self addSubview:displayView];
    [self setSgq_currentDisplayView:displayView];
}

- (void)sgq_coverViewTaped {
    self.sgq_tapedBlock ? self.sgq_tapedBlock():nil;
}

- (UIView*)sgq_findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self sgq_findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

#pragma mark - Getter & Setter
-  (UIView *)sgq_coverView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSgq_coverView:(UIView *)coverView {
    objc_setAssociatedObject(self, @selector(sgq_coverView), coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))sgq_tapedBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSgq_tapedBlock:(void (^)(void))tapedBlock {
    objc_setAssociatedObject(self, @selector(sgq_tapedBlock), tapedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)sgq_currentFirstResponder {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSgq_currentFirstResponder:(UIView *)currentFirstResponder {
    objc_setAssociatedObject(self, @selector(sgq_currentFirstResponder), currentFirstResponder, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)sgq_currentDisplayView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSgq_currentDisplayView:(UIView *)currentDisplayView {
    objc_setAssociatedObject(self, @selector(sgq_currentDisplayView), currentDisplayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

