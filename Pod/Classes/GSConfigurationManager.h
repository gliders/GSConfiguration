//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSConfigurationStore;
@class GSConfiguration;
@class GSBaseLoader;

@interface GSConfigurationManager : NSObject

#pragma mark Configuration Loader Methods

+(void)addLoader:(GSBaseLoader *)loader;

#pragma mark Configuration Storage Methods

+ (void)setConfigStore:(id<GSConfigurationStore>)config;
+ (id)configValueForKey:(NSString *)key;
+ (void)setConfigValue:(id)value forKey:(NSString *)key;

@end