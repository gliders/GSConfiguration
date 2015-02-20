//
// Created by Ryan Brignoni on 7/20/14.
//

#import <Foundation/Foundation.h>

@interface GSSource : NSObject

@property (nonatomic, getter=isLoaded, readonly) BOOL loaded;

// Overridden by subclasses
- (void)loadConfiguration;

@end