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
    NSData *archivedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
    [self.userDefaults setObject:archivedValue forKey:key];
}

- (id)configObjectForKey:(NSString *)key {
    id archivedValue = [self.userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedValue];
}

- (void)flush {
    [self.userDefaults synchronize];
}

- (void)setConfigWithDictionary:(NSDictionary *)values {
    [self.userDefaults setValuesForKeysWithDictionary:values];
}

@end