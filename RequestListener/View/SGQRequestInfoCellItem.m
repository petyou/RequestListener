//
//  SGQRequestInfoCellItem.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRequestInfoCellItem.h"
#import "SGQRequestInfoCell.h"
#import "SGQRequestListener.h"

@interface SGQRequestInfoCellItem()

@property (nonatomic, assign) CGFloat foldHeight;
@property (nonatomic, assign) CGFloat unFoldHeight;

@end

@implementation SGQRequestInfoCellItem

- (instancetype)initWithMockObject:(SGQMockObject *)mockObject {
    if (self = [super init]) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat contentLeft = 20;
        CGFloat onePiexlHeight = 1 / UIScreen.mainScreen.scale;
        
        // --------------- 未展开的数据
        _url = mockObject.request.URL.absoluteString;
        _method = mockObject.request.HTTPMethod;
        _httpCode = [mockObject statusCode];;
        _responseTime = mockObject.responseTime;
        
        CGFloat urlLeft = 5;
        CGSize urlSize = [_url boundingRectWithSize:CGSizeMake(screenWidth / 2.0 - urlLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell urlFont]} context:nil].size;
        urlSize.width = screenWidth / 2.0 - urlLeft * 2;
        _urlFrame = CGRectMake(urlLeft, urlLeft, urlSize.width, ceil(urlSize.height));
        _urlBottomLineFrame = CGRectMake(0, CGRectGetMaxY(_urlFrame) + urlLeft - onePiexlHeight, screenWidth, onePiexlHeight);
        _foldHeight = _unFoldHeight = ceil(CGRectGetMaxY(_urlBottomLineFrame));
        
        // --------------- request header
        _requestHeaderString = [mockObject requstHeaderString];
        if (_requestHeaderString.length > 0) {
            _requestHeaderTitleFrame = CGRectMake(contentLeft, _foldHeight, screenWidth - contentLeft * 2, 30);
            
            CGSize requestContentSize = [self.requestHeaderString boundingRectWithSize:CGSizeMake(screenWidth - contentLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell TitleFont]} context:nil].size;
            requestContentSize.width = screenWidth - contentLeft * 2;
            _requestHeaderContentFrame = CGRectMake(contentLeft, CGRectGetMaxY(_requestHeaderTitleFrame), requestContentSize.width, ceil(requestContentSize.height));
        }
        
        // --------------- request body
        _requestBodyString = [mockObject requestBodyString];
        if (_requestBodyString.length > 0) {
            _requestBodyTitleFrame = CGRectMake(contentLeft, _requestHeaderString.length > 0 ? CGRectGetMaxY(_requestHeaderContentFrame): _foldHeight, screenWidth - contentLeft * 2, 30);
            
            CGSize bodySize = [_requestBodyString boundingRectWithSize:CGSizeMake(screenWidth - contentLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell TitleFont]} context:nil].size;
            bodySize.width = screenWidth - contentLeft * 2;
            _requestBodyContentFrame = CGRectMake(contentLeft, CGRectGetMaxY(_requestBodyTitleFrame), bodySize.width, ceil(bodySize.height));
        }
        
        // --------------- response
        _responseString = [mockObject responseBodyString];        
        self.responseTitleFrame = CGRectMake(contentLeft, self.requestHeaderString.length > 0 ? CGRectGetMaxY(self.requestHeaderContentFrame) : self.foldHeight, screenWidth - 2 * contentLeft, 30);
        if (_requestBodyString.length > 0) {
            CGRect frame = self.responseTitleFrame;
            frame.origin.y = CGRectGetMaxY(self.requestBodyContentFrame);
            self.responseTitleFrame = frame;
        }
        CGSize responseSize = [_responseString boundingRectWithSize:CGSizeMake(screenWidth - contentLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell urlFont]} context:nil].size;
        responseSize.width = screenWidth - contentLeft * 2;
        self.responseContentFrame = CGRectMake(contentLeft,  CGRectGetMaxY(self.responseTitleFrame), responseSize.width, ceil(responseSize.height));
        
        self.unFoldHeight = CGRectGetMaxY(self.responseContentFrame);
    }
    return self;
}

- (CGFloat)cellHeight {
    if (self.isUnfolded) {
        return _unFoldHeight;
    } else {
        return _foldHeight;
    }
}

@end

