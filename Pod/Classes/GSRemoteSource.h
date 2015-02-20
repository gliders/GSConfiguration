//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSSource.h"

@interface GSRemoteSource : GSSource

@property (nonatomic, strong, readonly) NSURL *endpoint;
@property (nonatomic) BOOL refreshPeriodically;
@property (nonatomic) BOOL ignoreNSURLCache;
@property (nonatomic) CFTimeInterval refreshIntervalInSeconds;

- (instancetype)initWithEndpoint:(NSURL *)endpoint;
+ (instancetype)configWithEndpoint:(NSURL *)endpoint;

@end