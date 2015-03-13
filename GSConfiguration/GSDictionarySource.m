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
    if (plistPath) {
        NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        return [self sourceWithDictionary:plistDictionary];

    }

    GSLogWarn(@"PList named %@ not found", name);
    return [self sourceWithDictionary:@{}];
}

+ (instancetype)sourceWithJSONFileNamed:(NSString *)name {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];

    if (jsonPath) {
        NSError *error;
        id jsonConfig = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

        if (!error) {
            if ([jsonConfig isKindOfClass:[NSDictionary class]]) {
                return [self sourceWithDictionary:jsonConfig];
            } else {
                GSLogError(@"Top level of json config source must be an object.");
            }
        }

        GSLogError(@"Unable to parse JSON - %@", error);
    } else {
        GSLogWarn(@"JSON file named %@ not found", name);
    }

    return [self sourceWithDictionary:@{}];
}

@end