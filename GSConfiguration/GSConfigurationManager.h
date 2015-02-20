//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@protocol GSStore;
@class GSConfiguration;
@class GSSource;

@interface GSConfigurationManager : NSObject

+ (void)setStore:(id <GSStore>)store;
+ (void)addSource:(GSSource *)source;
+ (void)cleanUp;

+ (instancetype)sharedInstance;


@end