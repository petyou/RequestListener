//
//  SGQRequestInfoCellItem.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQRequestInfoCellItem.h"
#import "SGQRequestInfoCell.h"

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
        _url = mockObject.request.url.absoluteString;
        _method = mockObject.request.method;
        _httpCode = mockObject.response.statusCode;
        _responseTime = mockObject.response.responseTime;
        
        CGFloat urlLeft = 5;
        CGSize urlSize = [_url boundingRectWithSize:CGSizeMake(screenWidth / 2.0 - urlLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell urlFont]} context:nil].size;
        urlSize.width = screenWidth / 2.0 - urlLeft * 2;
        _urlFrame = CGRectMake(urlLeft, urlLeft, urlSize.width, ceil(urlSize.height));
        _urlBottomLineFrame = CGRectMake(0, CGRectGetMaxY(_urlFrame) + urlLeft - onePiexlHeight, screenWidth, onePiexlHeight);
        _foldHeight = _unFoldHeight = ceil(CGRectGetMaxY(_urlBottomLineFrame));
        
        // --------------- request header
        if (mockObject.request.headers.count > 0) {
            _requestHeaderString = mockObject.request.headers.description;
            
            _requestHeaderTitleFrame = CGRectMake(contentLeft, _foldHeight, screenWidth - contentLeft * 2, 30);
            
            CGSize requestContentSize = [self.requestHeaderString boundingRectWithSize:CGSizeMake(screenWidth - contentLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell TitleFont]} context:nil].size;
            requestContentSize.width = screenWidth - contentLeft * 2;
            _requestHeaderContentFrame = CGRectMake(contentLeft, CGRectGetMaxY(_requestHeaderTitleFrame), requestContentSize.width, ceil(requestContentSize.height));
        }
        
        // --------------- request body
        if (mockObject.request.body) {
            if (mockObject.request.body.length > 20 * 1024 * 1024) {
                _requestBodyString = @"to big to show here";
            } else {
                NSError *serializationError = nil;
                id result = [NSJSONSerialization JSONObjectWithData:mockObject.request.body options:0 error:&serializationError];
                if (serializationError) {
                    _requestBodyString = [SGQRequestInfoCellItem dictionaryWithQueryString:[[NSString alloc] initWithData:mockObject.request.body encoding:NSASCIIStringEncoding]].description;
                } else {
                    _requestBodyString = [result description];
                }
                
                if (_responseString.length == 0) {
                    _responseString = @"request body can't be parsed";
                }
            }
            
            _requestBodyTitleFrame = CGRectMake(contentLeft, _requestHeaderString.length > 0 ? CGRectGetMaxY(_requestHeaderContentFrame): _foldHeight, screenWidth - contentLeft * 2, 30);
            
            CGSize bodySize = [_requestBodyString boundingRectWithSize:CGSizeMake(screenWidth - contentLeft * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [SGQRequestInfoCell TitleFont]} context:nil].size;
            bodySize.width = screenWidth - contentLeft * 2;
            _requestBodyContentFrame = CGRectMake(contentLeft, CGRectGetMaxY(_requestBodyTitleFrame), bodySize.width, ceil(bodySize.height));
        }
        
        // --------------- response
        if ([mockObject.response.data isKindOfClass:[NSData class]]) {
            if (mockObject.request.body.length > 20 * 1024 * 1024) {
                _responseString = @"to big to show here";
            } else {
                NSError *serializationError = nil;
                id result = [NSJSONSerialization JSONObjectWithData:mockObject.response.data options:0 error:&serializationError];
                if (serializationError) {
                    _responseString = [[NSString alloc] initWithData:mockObject.response.data encoding:[SGQRequestInfoCellItem stringEncodingWithRequest:mockObject.response.textEncodingName]];
                } else {
                    _responseString = [result description];
                }
            }
            
            if (_responseString.length == 0) {
                _responseString = @"response can't be parsed";
            }
        } else {
            _responseString = @"response is not NSData.class";
        }
        
        
        self.responseTitleFrame = CGRectMake(contentLeft, self.requestHeaderString.length > 0 ? CGRectGetMaxY(self.requestHeaderContentFrame) : self.foldHeight, screenWidth - 2 * contentLeft, 30);
        if (mockObject.request.body.length > 0) {
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

#pragma mark - Tool

+ (NSStringEncoding)stringEncodingWithRequest:(NSString *)textEncodingName {
    // From AFNetworking 2.6.3
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    if (textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    return stringEncoding;
}

/// 将 @"key1=value1&key2=value2" -> @{@"key1": @"value1", @"key2":@"value2"}
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)query {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *arr = [query componentsSeparatedByString:@"&"];
    for (__strong NSString *subString in arr) {
        NSRange range = [subString rangeOfString:@"="];
        if (range.location != NSNotFound) {
            NSString* key = [subString substringToIndex:range.location];
            NSString* value = [subString substringWithRange:NSMakeRange(range.location+range.length, subString.length-(range.location+range.length))];
            [dic setObject:value forKey:key];
        }
    }
    return dic;
}

@end

