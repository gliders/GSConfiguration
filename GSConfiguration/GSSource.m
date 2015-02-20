//
// Created by Ryan Brignoni on 7/20/14.
//

#import "GSSource.h"
#import "GSConfigurationManager.h"

@implementation GSSource

- (void)fetchConfiguration:(GSConfigurationReady)completion {
    if (completion) {
        completion(nil);
    }
}

- (void)registerTransformer:(NSString *)name forKey:(NSString *)key {
    if (!self.transformers) {
        self.transformers = [@{key : name} mutableCopy];
    } else {
        self.transformers[key] = name;
    }
}

@end