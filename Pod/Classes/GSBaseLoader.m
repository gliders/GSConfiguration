//
// Created by Ryan Brignoni on 7/20/14.
//

#import "GSBaseLoader.h"

@interface GSBaseLoader ()

@property (nonatomic, getter=isLoaded, readwrite) BOOL loaded;

@end

@implementation GSBaseLoader

- (void)loadConfiguration {
    self.loaded = YES;
}

@end