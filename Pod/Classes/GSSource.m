//
// Created by Ryan Brignoni on 7/20/14.
//

#import "GSSource.h"

@interface GSSource ()

@property (nonatomic, getter=isLoaded, readwrite) BOOL loaded;

@end

@implementation GSSource

- (void)loadConfiguration {
    self.loaded = YES;
}

@end