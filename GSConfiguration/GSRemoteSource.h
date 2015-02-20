//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSSource.h"

typedef NSDictionary *(^GSJSONResponseParser)(id jsonData);

@interface GSRemoteSource : GSSource

@property (nonatomic, strong, readonly) NSURL *endpoint;
@property (nonatomic) CFTimeInterval refreshIntervalInSeconds;
@property (nonatomic) CFTimeInterval timeoutInterval;
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

- (instancetype)initWithEndpoint:(NSURL *)endpoint parserBlock:(GSJSONResponseParser)parserBlock;

+ (instancetype)sourceWithEndpoint:(NSURL *)endpoint parserBlock:(GSJSONResponseParser)parserBlock;

@end