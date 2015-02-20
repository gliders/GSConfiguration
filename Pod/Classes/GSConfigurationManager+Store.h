//
// Created by Ryan Brignoni on 2/13/15.
//

#import <Foundation/Foundation.h>
#import "GSConfigurationManager.h"

@interface GSConfigurationManager (Store)

+ (void)setConfigValue:(id)value forKey:(NSString *)key;
+ (id)configValueForKey:(NSString *)name;

@end