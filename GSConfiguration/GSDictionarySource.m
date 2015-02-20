//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSDictionarySource.h"

@interface GSDictionarySource ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation GSDictionarySource

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _data = [NSDictionary dictionaryWithDictionary:dictionary];
    }

    return self;
}

- (void)prepareWithCompletion:(GSConfigurationReady)ready {
    ready(self.data);
}

+ (instancetype)sourceWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

@end