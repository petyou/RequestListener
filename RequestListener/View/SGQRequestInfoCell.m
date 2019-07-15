//
//  SGQRequestInfoCell.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQRequestInfoCell.h"
#import "SGQUtility.h"

@interface SGQRequestInfoCell()
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) CALayer *urlBottomLine;
@property (nonatomic, strong) CALayer *urlRightLine;

@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) CALayer *methodRightLine;

@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) CALayer *codeRightLine;

@property (nonatomic, strong) UILabel *responseTimeLabel;

@property (nonatomic, strong) UILabel *requestHeaderTitleLabel;
@property (nonatomic, strong) UILabel *requestHeaderContentLabel;
@property (nonatomic, strong) CALayer *requestHeaderContentBottomLine;

@property (nonatomic, strong) UILabel *requestBodyTitleLabel;
@property (nonatomic, strong) UILabel *requestBodyContentLabel;
@property (nonatomic, strong) CALayer *requestBodyContentBottomLine;

@property (nonatomic, strong) UILabel *responseTitleLabel;
@property (nonatomic, strong) UILabel *responseContentLabel;

@end

@implementation SGQRequestInfoCell

+ (UIFont *)urlFont {
    return [UIFont systemFontOfSize:13];
}

+ (UIFont *)TitleFont {
    return [UIFont boldSystemFontOfSize:15];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
        // url
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.numberOfLines = 0;
        _urlLabel.font = [SGQRequestInfoCell urlFont];
        _urlLabel.textColor = UIColor.blackColor;
        [self addLongPressGestureForLabel:_urlLabel];
        [self.contentView addSubview:_urlLabel];
        
        _urlBottomLine = [CALayer layer];
        _urlBottomLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        [self.contentView.layer addSublayer:_urlBottomLine];
        
        _urlRightLine = [CALayer layer];
        _urlRightLine.backgroundColor = _urlBottomLine.backgroundColor;
        [self.contentView.layer addSublayer:_urlRightLine];
        
        // method
        _methodLabel = [[UILabel alloc] init];
        _methodLabel.textAlignment = NSTextAlignmentCenter;
        _methodLabel.numberOfLines = 0;
        _methodLabel.font = [SGQRequestInfoCell urlFont];
        _methodLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:_methodLabel];
        
        _methodRightLine = [CALayer layer];
        _methodRightLine.backgroundColor =_urlBottomLine.backgroundColor;
        [self.contentView.layer addSublayer:_methodRightLine];
        
        // code
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.numberOfLines = 0;
        _codeLabel.font = [SGQRequestInfoCell urlFont];
        _codeLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:_codeLabel];
        
        _codeRightLine = [CALayer layer];
        _codeRightLine.backgroundColor = _urlBottomLine.backgroundColor;
        [self.contentView.layer addSublayer:_codeRightLine];
        
        // responseTime
        _responseTimeLabel = [[UILabel alloc] init];
        _responseTimeLabel.textAlignment = NSTextAlignmentCenter;
        _responseTimeLabel.numberOfLines = 0;
        _responseTimeLabel.font = [SGQRequestInfoCell urlFont];
        _responseTimeLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:_responseTimeLabel];
        
        // ------------------ requestHeader
        _requestHeaderTitleLabel = [[UILabel alloc] init];
        _requestHeaderTitleLabel.text = @"Request Header";
        _requestHeaderTitleLabel.backgroundColor = UIColor.whiteColor;
        _requestHeaderTitleLabel.textAlignment = NSTextAlignmentCenter;
        _requestHeaderTitleLabel.numberOfLines = 0;
        _requestHeaderTitleLabel.font = [SGQRequestInfoCell TitleFont];
        _requestHeaderTitleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_requestHeaderTitleLabel]; // responseTime
        
        _requestHeaderContentLabel = [[UILabel alloc] init];
        _requestHeaderContentLabel.backgroundColor = _requestHeaderTitleLabel.backgroundColor;
        _requestHeaderContentLabel.textAlignment = NSTextAlignmentLeft;
        _requestHeaderContentLabel.numberOfLines = 0;
        _requestHeaderContentLabel.font = [SGQRequestInfoCell urlFont];
        _requestHeaderContentLabel.textColor = UIColor.blackColor;
        [self addLongPressGestureForLabel:_requestHeaderContentLabel];
        [self.contentView addSubview:_requestHeaderContentLabel];
        
        _requestHeaderContentBottomLine = [CALayer layer];
        _requestHeaderContentBottomLine.backgroundColor = UIColor.lightGrayColor.CGColor;
        [self.contentView.layer addSublayer:_requestHeaderContentBottomLine];
        
        // ------------------ requestBody
        _requestBodyTitleLabel = [[UILabel alloc] init];
        _requestBodyTitleLabel.text = @"Request Body";
        _requestBodyTitleLabel.backgroundColor = UIColor.whiteColor;
        _requestBodyTitleLabel.textAlignment = NSTextAlignmentCenter;
        _requestBodyTitleLabel.numberOfLines = 0;
        _requestBodyTitleLabel.font = [SGQRequestInfoCell TitleFont];
        _requestBodyTitleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_requestBodyTitleLabel]; // responseTime
        
        _requestBodyContentLabel = [[UILabel alloc] init];
        _requestBodyContentLabel.backgroundColor = _requestHeaderTitleLabel.backgroundColor;
        _requestBodyContentLabel.textAlignment = NSTextAlignmentLeft;
        _requestBodyContentLabel.numberOfLines = 0;
        _requestBodyContentLabel.font = [SGQRequestInfoCell urlFont];
        _requestBodyContentLabel.textColor = UIColor.blackColor;
        [self addLongPressGestureForLabel:_requestBodyContentLabel];
        [self.contentView addSubview:_requestBodyContentLabel];
        
        _requestBodyContentBottomLine = [CALayer layer];
        _requestBodyContentBottomLine.backgroundColor = _requestHeaderContentBottomLine.backgroundColor;
        [self.contentView.layer addSublayer:_requestBodyContentBottomLine];
        
        // ------------------ response
        _responseTitleLabel = [[UILabel alloc] init];
        _responseTitleLabel.text = @"Response";
        _responseTitleLabel.backgroundColor = UIColor.whiteColor;
        _responseTitleLabel.textAlignment = NSTextAlignmentCenter;
        _responseTitleLabel.numberOfLines = 0;
        _responseTitleLabel.font = [SGQRequestInfoCell TitleFont];
        _responseTitleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_responseTitleLabel]; // responseTime
        
        _responseContentLabel = [[UILabel alloc] init];
        _responseContentLabel.backgroundColor = UIColor.whiteColor;
        _responseContentLabel.textAlignment = NSTextAlignmentLeft;
        _responseContentLabel.numberOfLines = 0;
        _responseContentLabel.font = [SGQRequestInfoCell urlFont];
        _responseContentLabel.textColor = UIColor.blackColor;
        [self addLongPressGestureForLabel:_responseContentLabel];
        [self.contentView addSubview:_responseContentLabel];
    }
    
    return self;
}

- (void)setItem:(SGQRequestInfoCellItem *)item {
    _item = item;
    
    _urlLabel.text = item.url;
    _methodLabel.text = item.method;
    _codeLabel.text = item.httpCode;
    _codeLabel.textColor = [item.httpCode isEqualToString:@"200"] ? [UIColor blackColor] : [UIColor redColor];
    _responseTimeLabel.text = [NSString stringWithFormat:@"%.0fms", item.responseTime * 1000];
    
    _requestHeaderContentLabel.text = item.requestHeaderString;
    _requestBodyContentLabel.text = item.requestBodyString;
    _responseContentLabel.text = item.responseString;
    
    _requestHeaderTitleLabel.hidden =
    _requestHeaderContentLabel.hidden =
    _requestHeaderContentBottomLine.hidden = YES;
    
    _requestBodyTitleLabel.hidden =
    _requestBodyContentLabel.hidden =
    _requestBodyContentBottomLine.hidden = YES;
    
    _responseTitleLabel.hidden =
    _responseContentLabel.hidden = YES;
    
    if (item.isUnfolded) {
        _requestHeaderTitleLabel.hidden =
        _requestHeaderContentLabel.hidden =
        _requestHeaderContentBottomLine.hidden = !(item.requestHeaderString.length > 0);
        
        _requestBodyTitleLabel.hidden =
        _requestBodyContentLabel.hidden =
        _requestBodyContentBottomLine.hidden = !(item.requestBodyString.length > 0);
        
        _responseTitleLabel.hidden = _responseContentLabel.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentWidth = self.contentView.frame.size.width;
    CGFloat onePixelHeight = 1 / UIScreen.mainScreen.scale;
    
    
    [_urlLabel sizeToFit];
    _urlLabel.frame = self.item.urlFrame;
    
    _urlBottomLine.frame = self.item.urlBottomLineFrame;
    _urlRightLine.frame = CGRectMake(CGRectGetMaxX(_urlLabel.frame) + 5, 0, onePixelHeight, CGRectGetHeight(_urlLabel.frame) + 10);
    
    [_methodLabel sizeToFit];
    _methodLabel.frame = CGRectMake(CGRectGetMaxX(_urlRightLine.frame), CGRectGetMinY(_urlLabel.frame), contentWidth / 7.0, CGRectGetHeight(_urlLabel.frame));
    _methodRightLine.frame = CGRectMake(CGRectGetMaxX(_methodLabel.frame) + 5, CGRectGetMinY(_urlRightLine.frame), onePixelHeight, CGRectGetHeight(_urlRightLine.frame));
    
    [_codeLabel sizeToFit];
    _codeLabel.frame = CGRectMake(CGRectGetMaxX(_methodRightLine.frame), CGRectGetMinY(_urlLabel.frame), contentWidth / 7.0, CGRectGetHeight(_urlLabel.frame));
    _codeRightLine.frame = CGRectMake(CGRectGetMaxX(_codeLabel.frame) + 5, CGRectGetMinY(_urlRightLine.frame), onePixelHeight, CGRectGetHeight(_urlRightLine.frame));
    
    [_responseTimeLabel sizeToFit];
    _responseTimeLabel.frame = CGRectMake(CGRectGetMaxX(_codeRightLine.frame), CGRectGetMinY(_urlLabel.frame), contentWidth - CGRectGetMaxX(_codeRightLine.frame), CGRectGetHeight(_urlLabel.frame));
    
    // ------------------ requestHeader
    if (!_requestHeaderContentLabel.hidden) {
        _requestHeaderTitleLabel.frame = self.item.requestHeaderTitleFrame;
        _requestHeaderContentLabel.frame = self.item.requestHeaderContentFrame;
        _requestHeaderContentBottomLine.frame = CGRectMake(CGRectGetMinX(_requestHeaderContentLabel.frame), CGRectGetMaxY(_requestHeaderContentLabel.frame) - onePixelHeight, CGRectGetWidth(_requestHeaderContentLabel.frame), onePixelHeight);
    }
    
    // ------------------ requestBody
    if (!_requestBodyContentLabel.hidden) {
        _requestBodyContentLabel.frame = self.item.requestBodyContentFrame;
        _requestBodyTitleLabel.frame = self.item.requestBodyTitleFrame;
        _requestBodyContentBottomLine.frame = CGRectMake(CGRectGetMinX(_requestBodyContentLabel.frame), CGRectGetMaxY(_requestBodyContentLabel.frame) - onePixelHeight, CGRectGetWidth(_requestBodyContentLabel.frame), onePixelHeight);
    }
    
    // ------------------ response
    if (!_responseContentLabel.hidden) {
        _responseTitleLabel.frame = self.item.responseTitleFrame;
        _responseContentLabel.frame = self.item.responseContentFrame;
    }
}

#pragma mark -
- (void)addLongPressGestureForLabel:(UILabel *)label {
    label.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyString:)];
    longPress.minimumPressDuration = 1;
    [label addGestureRecognizer:longPress];
}

#pragma mark - copy
- (void)copyString:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel*)tap.view;
    if (label.text) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = label.text;
        [SGQUtility showMessage:@"已复制" duration:0.8];
    }
}

@end
