//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSUserDefaultsStore.h"

@interface GSUserDefaultsStore ()

@property (nonatomic, readwrite, getter=isInitialized) BOOL initialized;
@property (nonatomic, strong) NSMutableDictionary *propValueStore;

@end

@implementation GSUserDefaultsStore

- (instancetype)init {
    self = [super init];

    if (self) {
        self.propValueStore = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)initializeStore {
    if (!self.isInitialized) {
        self.initialized = YES;
    }
}

- (BOOL)containsKey:(NSString *)key {
    return ([self.propValueStore objectForKey:key] != nil);
}

@end