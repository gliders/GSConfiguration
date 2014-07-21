//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"
#import "GSBaseLoader.h"

@interface GSConfigurationManager ()

@property (nonatomic, strong) NSMutableArray *configLoaders;
@property (nonatomic, strong) id<GSConfigurationStore> defaultStore;

@end

@implementation GSConfigurationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configLoaders = [NSMutableArray array];
        self.defaultStore = [[GSUserDefaultsStore alloc] init];
    }

    return self;
}

#pragma mark Configuration Loader Methods

- (void)addLoader:(GSBaseLoader *)loader {
    [self.configLoaders addObject:loader];
}

#pragma mark Configuration Storage Methods

- (void)setConfigStore:(id<GSConfigurationStore>)configStore {
    self.defaultStore = configStore;
}

- (id)configValueForKey:(NSString *)key {
    return [self.defaultStore configObjectForKey:key];
}

- (void)setConfigValue:(id)value forKey:(NSString *)key {
    [self.defaultStore setConfigObject:value forKey:key];
}

#pragma mark Class Convenience Methods

+ (void)addLoader:(GSBaseLoader *)loader {
    GSConfigurationManager *manager = [self shared];
    [manager addLoader:loader];
}

+ (void)setConfigStore:(id<GSConfigurationStore>)config {
    GSConfigurationManager *manager = [self shared];
    [manager setConfigStore:config];
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