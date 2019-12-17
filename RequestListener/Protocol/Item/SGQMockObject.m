//
//  SGQMockObject.m
//  Liaodao
//
//  Created by SGQ on 2019/6/18.
//  Copyright © 2019 LiaodaoSports. All rights reserved.
//

#import "SGQMockObject.h"
#import "SGQUtility.h"
#import "SGQRequestListener.h"

@implementation SGQMockObject

+ (instancetype)objectWithRequest:(NSURLRequest *)request
                         response:(NSURLResponse *)response
                      responseData:(NSData *)responseData
                             error:(NSError *)error
                      responseTime:(NSTimeInterval)responseTime
{
    SGQMockObject* item = [self new];
    item.request = request;
    item.response = response;
    item.responseData = responseData;
    item.error = error;
    item.responseTime = responseTime;
    
    return item;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.request.URL.absoluteString];
}

- (NSString *)statusCode {
    if (self.response && [self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return @(((NSHTTPURLResponse *)self.response).statusCode).stringValue;
    }
    
    if (self.error) {
        return @(self.error.code).stringValue;
    }
    
    return @"no code";
}

- (NSString *)requstHeaderString {
    NSDictionary *dict = self.request.allHTTPHeaderFields;
    if (dict.count > 0) {
        return dict.description;
    } else {
        return nil;
    }
}

- (NSString *)requestBodyString {
    NSData *data = [self requestBodyWithRequest:self.request];
    NSString *contentType = [self.request valueForHTTPHeaderField:@"Content-Type"];
    NSString *contentEncoding = [self.request valueForHTTPHeaderField:@"Content-Encoding"];
    if (!data.length) {
        return nil;
    }
    
    if ([contentEncoding rangeOfString:@"deflate" options:NSCaseInsensitiveSearch].length > 0 || [contentEncoding rangeOfString:@"gzip" options:NSCaseInsensitiveSearch].length > 0) {
        data = [SGQUtility inflatedDataFromCompressedData:data];
    }
    
    if (data.length > 1 * 1024 * 1024) {
        return @"It is to big to show here";
    }
    
    // 大部分api接口都是这两种，部分上传文件接口是@"multipart/form-data",在这里也无法展示
    if ([contentType hasPrefix:@"application/x-www-form-urlencoded"]) {
        NSString *bodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *querys = [SGQUtility dictionaryFromQuery:bodyString];
        return querys.description;
    } else if ([contentType hasPrefix:@"application/json"]) {
        NSDictionary *querys = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        return querys.description;
    }
    
     return @"The request content type is NOT 'application/x-www-form-urlencoded or 'application/json', so it can't be showed pretty here";
}

/// mock过来的request，它的HTTPBody很可能被转化成HTTPBodyStream。这里给它还原
- (NSData *)requestBodyWithRequest:(NSURLRequest *)request {
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

- (NSString *)responseBodyString {
    if (self.error) {
        return self.error.localizedDescription;
    }
    
    NSData *data = self.responseData;
    if (!data.length) {
        return @"response is empty";
    }

    NSString *bodyString = nil;
    
    NSError *parseError = nil;
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (!parseError) {
        bodyString = [jsonResult description];
    }
    
    NSString *mimeType = self.response.MIMEType;
    if ([mimeType isEqualToString:@"application/x-plist"]) {
        id plistResult = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:&parseError];
        
        if (!parseError) {
            bodyString = [plistResult description];
        }
    }
   
    if (bodyString.length > 0 ) {
        if (bodyString.length > [SGQRequestListener sharedInstance].responseDataMaxShowingLength ) {
            return [NSString stringWithFormat:@"%@...\n To long show all!", [bodyString substringToIndex:[SGQRequestListener sharedInstance].responseDataMaxShowingLength]];
        } else {
            return bodyString;
        }
    }
    
    bodyString = [[NSString alloc] initWithData:data encoding:[self stringEncodingWithRequest:self.response.textEncodingName]];
    if (!bodyString || !bodyString.length) {
        return @"the response can't be parsed here";
    }
    
    if ((bodyString.length > [SGQRequestListener sharedInstance].responseDataMaxShowingLength) ) {
        return [NSString stringWithFormat:@"%@...\n To long show all!", [bodyString substringToIndex:[SGQRequestListener sharedInstance].responseDataMaxShowingLength]];
    } else {
         return bodyString;
    }
}

- (NSStringEncoding)stringEncodingWithRequest:(NSString *)textEncodingName {
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

@end
