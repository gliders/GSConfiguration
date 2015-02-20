//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSStore <NSObject>

@required
- (void)setStoreDefaults:(NSDictionary *)defaults;
- (void)setConfigWithDictionary:(NSDictionary *)values;
- (void)setConfigObject:(id)value forKey:(NSString *)key;
- (id)configObjectForKey:(NSString *)key;
- (void)flush;

@end