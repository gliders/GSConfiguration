//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSSource.h"

@interface GSDictionarySource : GSSource

- (instancetype)initWithData:(NSDictionary *)data;

+ (instancetype)sourceWithData:(NSDictionary *)data;

@end