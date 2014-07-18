//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@class GSConfiguration;

@interface GSConfigurationManager : NSObject

+ (void)addConfig:(GSConfiguration *)config;
+ (id)configValueForKey:(NSString *)key;
+ (void)setConfigValue:(id)value forKey:(NSString *)key;

@end