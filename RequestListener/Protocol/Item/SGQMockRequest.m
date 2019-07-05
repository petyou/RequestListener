//
//  SGQMockRequest.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQMockRequest.h"

@implementation SGQMockRequest

- (instancetype)initWithRequest:(NSURLRequest *)request {
    if (self = [super init]) {
        _method = request.HTTPMethod;
        _url = request.URL;
        _headers = request.allHTTPHeaderFields;
        _body = [self bodyWithRequest:request];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MockRequest:%@\nMethod: %@\nURL: %@",
            [super description],
            self.method,
            self.url
            ];
}

- (NSUInteger)hash {
    NSUInteger i = self.method.hash ^ self.url.absoluteString.hash ^ self.headers.hash ^ self.body.hash;
    return i;
}

/// mock过来的request，它的HTTPBody很可能被转化成HTTPBodyStream。这里给它还原
- (NSData *)bodyWithRequest:(NSURLRequest *)request {
    if (request.HTTPBodyStream) {
        NSInputStream *stream = request.HTTPBodyStream;
        NSMutableData *data = [NSMutableData data];
        [stream open];
        size_t bufferSize = 4096;
        uint8_t *buffer = malloc(bufferSize);
        if (buffer == NULL) {
            [NSException raise:@"MallocFailure" format:@"Could not allocate %zu bytes to read HTTPBodyStream", bufferSize];
        }
        while ([stream hasBytesAvailable]) {
            NSInteger bytesRead = [stream read:buffer maxLength:bufferSize];
            if (bytesRead > 0) {
                NSData *readData = [NSData dataWithBytes:buffer length:bytesRead];
                [data appendData:readData];
            } else if (bytesRead < 0) {
                [NSException raise:@"StreamReadError" format:@"An error occurred while reading HTTPBodyStream (%ld)", (long)bytesRead];
            } else if (bytesRead == 0) {
                break;
            }
        }
        free(buffer);
        [stream close];
        
        return data;
    }
    
    return request.HTTPBody;
}

@end
