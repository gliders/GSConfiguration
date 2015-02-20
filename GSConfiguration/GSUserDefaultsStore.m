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

- (void)initializeStoreWithDefaults:(NSDictionary *)defaults {
    if (!self.isInitialized) {
        [self.userDefaults registerDefaults:defaults];

        self.initialized = YES;
    }
}

- (BOOL)containsKey:(NSString *)key {
    return NO;
}

- (void)setConfigObject:(id)value forKey:(NSString *)key {

}

- (id)configObjectForKey:(NSString *)key {
    return nil;
}

- (void)flush {
    [self.userDefaults synchronize];
}

- (void)setConfigWithDictionary:(NSDictionary *)values {
    [self.userDefaults setValuesForKeysWithDictionary:values];
}

@end