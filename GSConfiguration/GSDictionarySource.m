//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSDictionarySource.h"
#import "GSConfigurationLogging.h"

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

- (void)fetchConfiguration:(GSConfigurationReady)completion {
    completion(self.data);
}

+ (instancetype)sourceWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

+ (instancetype)sourceWithPListNamed:(NSString *)name {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    if (!plistPath) {
        GSLogWarn(@"PList named %@ not found", name);
    }
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [self sourceWithDictionary:plistDictionary];
}

@end