//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSConfigurationStore <NSObject>

- (void)initializeStore;
- (BOOL)containsKey:(NSString *)key;

@end