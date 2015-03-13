//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSUserDefaultsStore.h"

@interface GSUserDefaultsStore ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation GSUserDefaultsStore

- (instancetype)init {
    self = [super init];

    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}

- (void)setStoreDefaults:(NSDictionary *)defaults {
    [self.userDefaults registerDefaults:defaults];
}

- (void)setConfigObject:(id)value forKey:(NSString *)key {
    if ([value conformsToProtocol:@protocol(NSCoding)]) {
        value = [NSKeyedArchiver archivedDataWithRootObject:value];
    }

    [self.userDefaults setObject:value forKey:key];
}

- (id)configObjectForKey:(NSString *)key {
    id archivedValue = [self.userDefaults objectForKey:key];

    if ([archivedValue isKindOfClass:[NSData class]]) {
        archivedValue = [NSKeyedUnarchiver unarchiveObjectWithData:archivedValue];
    }

    return archivedValue;
}

- (void)flush {
    [self.userDefaults synchronize];
}

- (void)setConfigWithDictionary:(NSDictionary *)values {
    [self setStoreDefaults:values];
}

+ (instancetype)store {
    return [[self alloc] init];
}

@end