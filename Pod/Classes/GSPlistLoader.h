//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>
#import "GSBaseLoader.h"

@interface GSPlistLoader : GSBaseLoader

@property (nonatomic, copy, readonly) NSString *plistName;
@property (nonatomic, readonly) BOOL syncWithUserDefaults; // Defaults to YES.

- (instancetype)initWithPlistName:(NSString *)plistName;
- (instancetype)initWithPlistName:(NSString *)plistName syncWithUserDefaults:(BOOL)sync;
+ (instancetype)configWithPlistName:(NSString *)plistName;

@end