//
// Created by Ryan Brignoni on 7/17/14.
//

#import <Foundation/Foundation.h>

/**
 * This base class allows configuration subclasses to act as a type-safe facade for config property values. Properties
 * that act as keys into the configuration system must be made @dynamic in the facade's implementation. Note that
 * struct types are not directly supported yet. You can work around this by encoding/decoding them with NSValue.
 */

@interface GSConfiguration : NSObject

#pragma mark Example Properties

// @property (readonly) NSURL *canonicalServiceURL;
// @property (getter=isCoolFeatureEnabled) BOOL coolFeatureEnabled;
// @property (copy) NSString *defaultEmailSubject;
// @property (readonly) CFTimeInterval networkTimeout;

@end