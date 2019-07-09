//
//  SGQMockResponse.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQMockResponse.h"

@interface SGQMockResponse ()
@property (nonatomic, strong) NSURL *url;
@end

@implementation SGQMockResponse

- (instancetype)initWitResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                   responseTime:(NSTimeInterval)responseTime
                          error:(NSError *)error
{
    if (self = [super init]){
        _url = response.URL;
        if (error) {
            _statusCode = error.code;
            _data = [error.localizedDescription dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        } else {
            _statusCode = response.statusCode;
            _data = data;
            _responseTime = responseTime;
            _textEncodingName = response.textEncodingName;
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MockResponse%@:\n url: %@\nStatus Code: %ld\n",
            [super description],
            self.url.absoluteString,
            (long)self.statusCode];
}


@end
