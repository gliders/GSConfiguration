//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

@interface GSConfiguration : NSObject

@property (nonatomic, copy) NSNumber *priority;

- (BOOL)containsKey:(NSString *)key;

@end