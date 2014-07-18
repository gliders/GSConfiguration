//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@class GSConfiguration;
@protocol GSConfigurationStore;

@interface GSConfigurationManager : NSObject

+ (void)setConfigStore:(id<GSConfigurationStore>)config;
+ (id)configValueForKey:(NSString *)key;
+ (void)setConfigValue:(id)value forKey:(NSString *)key;

@end