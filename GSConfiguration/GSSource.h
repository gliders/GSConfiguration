//
// Created by Ryan Brignoni on 7/20/14.
//

#import <Foundation/Foundation.h>

@class GSSource;

typedef void(^GSConfigurationReady)(NSDictionary *data);

@interface GSSource : NSObject

@property (nonatomic, strong) NSMutableDictionary *transformers;

- (void)fetchConfiguration:(GSConfigurationReady)completion;
- (void)registerTransformer:(NSString *)name forKey:(NSString *)key;

@end