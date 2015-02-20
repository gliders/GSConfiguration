//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSRemoteSource.h"

@interface GSRemoteSource ()

@property (nonatomic, strong, readwrite) NSURL *endpoint;

@end

@implementation GSRemoteSource

- (instancetype)initWithEndpoint:(NSURL *)endpoint {
    self = [super init];
    if (self) {
        self.endpoint = endpoint;
    }

    return self;
}

+ (instancetype)configWithEndpoint:(NSURL *)endpoint {
    return [[self alloc] initWithEndpoint:endpoint];
}

@end