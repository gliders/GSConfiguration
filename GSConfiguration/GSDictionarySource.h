//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSSource.h"

@interface GSDictionarySource : GSSource

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)sourceWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)sourceWithPListNamed:(NSString *)name;

@end