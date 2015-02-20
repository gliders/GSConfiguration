//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSSource.h"

@interface GSDictionarySource : GSSource

@property (nonatomic, copy, readonly) NSString *plistName;

- (instancetype)initWithPlistName:(NSString *)plistName;
+ (instancetype)configWithPlistName:(NSString *)plistName;

@end