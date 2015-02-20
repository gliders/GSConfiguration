//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSUserDefaultsStore.h"

@interface GSUserDefaultsStore ()

@property (nonatomic, readwrite, getter=isInitialized) BOOL initialized;
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
    if (!self.isInitialized) {
        [self.userDefaults registerDefaults:defaults];

        self.initialized = YES;
    }
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
    for (NSString *key in values.allKeys) {
        [self setConfigObject:values[key] forKey:key];
    }
}

+ (instancetype)store {
    return [[self alloc] init];
}

@end