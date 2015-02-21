//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSStore;
@class GSConfiguration;
@class GSSource;

@interface GSConfigurationManager : NSObject

+ (void)setConfigValue:(id)value forKey:(NSString *)key withClass:(NSString *)clazz;
+ (id)configValueForKey:(NSString *)name withClass:(NSString *)clazz;
+ (void)setStore:(id <GSStore>)store;
+ (void)addSource:(GSSource *)source;
+ (void)cleanUp;
+ (void)registerTransformerName:(NSString *)transformerName forClass:(Class)type;
+ (instancetype)defaultManager;

@end