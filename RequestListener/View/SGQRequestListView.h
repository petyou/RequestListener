//
//  SGQRequestListView.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRequestInfoCellItem.h"

@interface SGQRequestListView : UIView

- (void)receivedAnInfoCellItem:(SGQRequestInfoCellItem *)item;

- (void)showFromBottom;

@end

