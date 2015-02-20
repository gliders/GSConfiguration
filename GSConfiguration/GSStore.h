//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSStore <NSObject>

@required
- (void)initializeStoreWithDefaults:(NSDictionary *)defaults;
- (BOOL)containsKey:(NSString *)key;
- (void)setConfigWithDictionary:(NSDictionary *)values;
- (void)setConfigObject:(id)value forKey:(NSString *)key;
- (id)configObjectForKey:(NSString *)key;
- (void)flush;

@end