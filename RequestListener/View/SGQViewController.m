//
//  SGQViewController.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQViewController.h"
#import "SGQRequestListView.h"

@interface SGQViewController()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray<SGQMockObject*> *loadedObjects;

@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) SGQRequestListView *tb;
@end

@implementation SGQViewController

#pragma mark - Init

- (void)dealloc {
    NSLog(@"%@_dealloc", NSStringFromClass(self.class));
}

- (instancetype)init {
    if (self = [super init]) {
        _loadedObjects = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public

- (void)appendNewMockObject:(SGQMockObject *)mockObject {
    @synchronized (_loadedObjects) {
        [_loadedObjects appendObject:mockObject];
    }
    SGQRequestInfoCellItem *item = [[SGQRequestInfoCellItem alloc] initWithMockObject:mockObject];
    
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        [self.tb receivedAnInfoCellItem:item];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb receivedAnInfoCellItem:item];
        });
    }
}

- (void)removeAllObjects {
    @synchronized (_loadedObjects) {
        [_loadedObjects removeAllObjects];
    }
}

- (void)show {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    NSAssert(window != nil, @"在设置根控制器后开启");
    
    CGFloat dotWidth = 50;
    CGFloat safeBottomMargin = 0;
    if (@available(iOS 11.0, *)) {
        safeBottomMargin = window.safeAreaInsets.bottom;
    }
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(window.bounds) - dotWidth - 10, CGRectGetHeight(window.bounds) - dotWidth - 47 - 10 - safeBottomMargin, dotWidth, dotWidth)];
    dotView.layer.cornerRadius = dotWidth / 2.0;
    dotView.layer.shadowColor = UIColor.blackColor.CGColor;
    dotView.layer.shadowOffset = CGSizeMake(0, 3);
    dotView.layer.shadowRadius = 8;
    dotView.layer.shadowOpacity = 0.15;
    dotView.backgroundColor = [UIColor colorWithRed:70/255.0 green:132/255.0 blue:255/255.0 alpha:1.0];
    [window addSubview:dotView];
    
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTrigged)];
    [dotView addGestureRecognizer:tapGeture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureUpdate:)];
    [dotView addGestureRecognizer:panGesture];
    
    self.dotView = dotView;
    
    CGFloat tbH = ceil(CGRectGetHeight(window.bounds) * 0.7);
    SGQRequestListView *tb = [[SGQRequestListView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(window.bounds) - tbH, CGRectGetWidth(window.bounds), tbH)];
    self.tb = tb;
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.dotView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dotView removeFromSuperview];
        self.dotView = nil;
    }];
    
    [self.tb removeFromSuperview];
    self.tb = nil;
}

#pragma mark - Private

- (void)panGestureUpdate:(UIPanGestureRecognizer *)pan {
    UIView *dotView = pan.view;
    CGPoint t = [pan translationInView:dotView];
    dotView.center = CGPointMake(dotView.center.x + t.x, dotView.center.y + t.y);
    [pan setTranslation:CGPointZero inView:dotView];
}

- (void)tapGestureTrigged {
    [self.tb showFromBottom];
}

@end
