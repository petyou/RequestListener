//
//  SGQRequestInfoCell.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRequestInfoCellItem.h"

@interface SGQRequestInfoCell : UITableViewCell

@property (nonatomic, strong) SGQRequestInfoCellItem *item;

+ (UIFont *)urlFont;
+ (UIFont *)TitleFont;

@end

