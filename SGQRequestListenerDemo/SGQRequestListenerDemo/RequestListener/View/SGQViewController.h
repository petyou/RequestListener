//
//  SGQViewController.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  视图管理，构建、隐藏和刷新视图等

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SGQMockObject.h"

@interface SGQViewController : NSObject

- (void)appendNewMockObject:(SGQMockObject *)mockObject;

- (void)show;

- (void)hide;

- (void)removeAllObjects;

@end
