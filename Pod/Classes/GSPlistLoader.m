//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSPlistLoader.h"

@interface GSPlistLoader ()

@property (nonatomic, copy, readwrite) NSString *plistName;
@property (nonatomic, readwrite) BOOL syncWithUserDefaults;

@end

@implementation GSPlistLoader

- (instancetype)initWithPlistName:(NSString *)plistName {
    return [self initWithPlistName:plistName syncWithUserDefaults:YES];
}

- (instancetype)initWithPlistName:(NSString *)plistName syncWithUserDefaults:(BOOL)sync {
    self = [super init];

    if (self) {
        self.plistName = plistName;
        self.syncWithUserDefaults = sync;
    }

    return self;
}

+ (instancetype)configWithPlistName:(NSString *)plistName {
    return [[self alloc] initWithPlistName:plistName];
}

@end