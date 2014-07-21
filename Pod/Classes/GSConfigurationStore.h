//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSConfigurationStore <NSObject>

@required
- (void)initializeStore;
- (BOOL)containsKey:(NSString *)key;
- (void)setConfigObject:(id)value forKey:(NSString *)key;
- (id)configObjectForKey:(NSString *)key;

@end