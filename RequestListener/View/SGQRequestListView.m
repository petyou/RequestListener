//
//  SGQRequestListView.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQRequestListView.h"
#import "SGQRequestInfoCell.h"
#import "UIView+ShowWithBackView.h"

static NSString *kNetInfoCellID = @"SGQRequestInfoCellID";

@interface SGQRequestListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGFloat bottonButtonHeight;
@property (nonatomic, strong) NSMutableArray<SGQRequestInfoCellItem*> *cellItems;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottonBar;
@property (nonatomic, strong) UIButton *bottomLeftButton;
@property (nonatomic, strong) UIButton *bottomRightButton;
@end

@implementation SGQRequestListView

#pragma mark - Init

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        _bottonButtonHeight = 44;
        if (@available(iOS 11.0, *)) {
            if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0) {
                _bottonButtonHeight = 60;
            }
        }
        _cellItems = [NSMutableArray array];
        
        [self addSubview:self.tableView];
        [self addSubview:self.bottonBar];
    }
    return self;
}

#pragma mark - Public

- (void)receivedAnInfoCellItem:(SGQRequestInfoCellItem *)item {
    [self.cellItems addObject:item];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.cellItems.count - 1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)showFromBottom {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0, CGRectGetHeight(window.bounds) - height, width, height);
    self.transform = CGAffineTransformMakeTranslation(0, height);
    
    __weak typeof(self) weakSelf = self;
    [window sgq_showDisplayView:self
                     coverAlpha:0.6
                coverTapedBlock:^{
                    [weakSelf hideToBottom];
                }
                  showAnimation:^{
                      weakSelf.transform = CGAffineTransformIdentity;
                  }
          showAnimationInterval:0.27
                  finishedBlock:nil];
}

#pragma mark - Private

- (void)clear {
    [self.cellItems removeAllObjects];
    [self.tableView reloadData];
}

- (void)hideToBottom {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    [window sgq_hideDisplayView:self
                  hideAnimation:^{
                      weakSelf.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(weakSelf.bounds));
                  }
          hideAnimationInterval:0.27
                  finishedBlock:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGQRequestInfoCellItem *item = self.cellItems[indexPath.row];
    return item.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGQRequestInfoCell *cell = (SGQRequestInfoCell*)[tableView dequeueReusableCellWithIdentifier:kNetInfoCellID];
    SGQRequestInfoCellItem *item = self.cellItems[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGQRequestInfoCellItem *item = self.cellItems[indexPath.row];
    item.isUnfolded = !item.isUnfolded;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - Getter

- (UIButton *)bottomLeftButton  {
    if (!_bottomLeftButton) {
        _bottomLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomLeftButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
        _bottomLeftButton.frame = CGRectMake(0, 0, self.frame.size.width / 2.0, _bottonButtonHeight);
        [_bottomLeftButton setTitle:@"clear" forState:UIControlStateNormal];
        [_bottomLeftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];;
        _bottomLeftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomLeftButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        if (@available(iOS 11.0, *)) {
            if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0) {
                [_bottomLeftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
            }
        }
    }
    return _bottomLeftButton;
}

- (UIButton *)bottomRightButton {
    if (!_bottomRightButton) {
        _bottomRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomRightButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
        _bottomRightButton.frame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, _bottonButtonHeight);
        [_bottomRightButton setTitle:@"hide" forState:UIControlStateNormal];
        [_bottomRightButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];;
        _bottomRightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomRightButton addTarget:self action:@selector(hideToBottom) forControlEvents:UIControlEventTouchUpInside];
        if (@available(iOS 11.0, *)) {
            if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0) {
                [_bottomRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
            }
        }
    }
    return _bottomRightButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _bottonButtonHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = UIView.new;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SGQRequestInfoCell class] forCellReuseIdentifier:kNetInfoCellID];
    }
    return _tableView;
}

- (UIView *)bottonBar {
    if (!_bottonBar) {
        _bottonBar = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height - _bottonButtonHeight, self.frame.size.width, _bottonButtonHeight)];
        [_bottonBar addSubview:self.bottomLeftButton];
        [_bottonBar addSubview:self.bottomRightButton];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(self.frame.size.width / 2.0, 0, 1 / UIScreen.mainScreen.scale, _bottonButtonHeight);
        line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        [_bottonBar.layer addSublayer:line];
        
        _bottonBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottonBar.layer.shadowOffset = CGSizeMake(0, -4);
        _bottonBar.layer.shadowOpacity = 0.04;
    }
    return _bottonBar;
}

@end
