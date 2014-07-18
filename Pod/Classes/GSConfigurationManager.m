//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfigurationManager.h"
#import "GSConfiguration.h"

@interface GSConfigurationManager ()

@property (nonatomic, strong) NSMutableArray *configs;
@property (nonatomic, strong) NSMutableDictionary *defaultStore;

@end

@implementation GSConfigurationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configs = [NSMutableArray array];
        self.defaultStore = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)addConfig:(GSConfiguration *)config {
    [self.configs addObject:config];

    if (config.priority) {
        [self.configs sortUsingComparator:^NSComparisonResult(GSConfiguration *config1, GSConfiguration *config2) {
            if ([config1.priority intValue] > config2.priority.intValue) {
                return NSOrderedDescending;
            } else if ([config1.priority intValue] < config2.priority.intValue) {
                return NSOrderedAscending;
            }

            return NSOrderedSame;
        }];
    }
}

- (id)configValueForKey:(NSString *)key {
    for (GSConfiguration *config in self.configs) {
        id value = [config valueForKey:key];
        if (value) {
            return value;
        }
    }

    return [self.defaultStore objectForKey:key];
}

- (void)setConfigValue:(id)value forKey:(NSString *)key {
    for (GSConfiguration *config in self.configs) {
        if ([config containsKey:key]) {
            [config setValue:value forKey:key];
            return;
        }
    }

    [self.defaultStore setObject:value forKey:key];
}

#pragma mark Class Convenience Methods

+ (void)addConfig:(GSConfiguration *)config {
    GSConfigurationManager *manager = [self shared];
    [manager addConfig:config];
}

+ (id)configValueForKey:(NSString *)key {
    GSConfigurationManager *manager = [self shared];
    return [manager configValueForKey:key];
}

+ (void)setConfigValue:(id)value forKey:(NSString *)key {
    GSConfigurationManager *manager = [self shared];
    [manager setConfigValue:value forKey:key];
}

+ (instancetype)shared {
    static dispatch_once_t predicate;
    static GSConfigurationManager *instance;

    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

@end