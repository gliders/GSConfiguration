//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSDictionarySource.h"

@interface GSDictionarySource ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation GSDictionarySource

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = [NSDictionary dictionaryWithDictionary:data];
    }

    return self;
}

- (void)prepareWithCompletion:(GSConfigurationReady)ready {
    ready(self.data);
}

+ (instancetype)sourceWithData:(NSDictionary *)data {
    return [[self alloc] initWithData:data];
}

@end