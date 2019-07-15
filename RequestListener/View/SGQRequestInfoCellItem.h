//
//  SGQRequestInfoCellItem.h
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//  cell的viewModel

#import "SGQMockObject.h"

@interface SGQRequestInfoCellItem : NSObject

// -----------------未展开的数据
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *httpCode;
@property (nonatomic, assign) double responseTime; // s
@property (nonatomic, assign) CGRect urlFrame;
@property (nonatomic, assign) CGRect urlBottomLineFrame;

// ------------------ request header
@property (nonatomic, strong) NSString *requestHeaderString;
@property (nonatomic, assign) CGRect requestHeaderTitleFrame;
@property (nonatomic, assign) CGRect requestHeaderContentFrame;

// ------------------ request body
@property (nonatomic, strong) NSString *requestBodyString;
@property (nonatomic, assign) CGRect requestBodyTitleFrame;
@property (nonatomic, assign) CGRect requestBodyContentFrame;

// ------------------ response
@property (nonatomic, copy) NSString *responseString;
@property (nonatomic, assign) CGRect responseTitleFrame;
@property (nonatomic, assign) CGRect responseContentFrame;

/// 是否展开的
@property (nonatomic, assign) BOOL isUnfolded;

/// 不同状态下的cell Height
@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithMockObject:(SGQMockObject *)mockObject;

@end

