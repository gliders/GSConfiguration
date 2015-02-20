//
// Created by Ryan Brignoni on 2/17/15.
//

#import "GSURLStringTransformer.h"

@implementation GSURLStringTransformer

+ (Class)transformedValueClass {
    return [NSURL class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:value];
        return url;
    }

    return nil;
}

- (id)reverseTransformedValue:(id)value {
    if ([value isKindOfClass:[NSURL class]]) {
        return [value absoluteString];
    }

    return nil;
}

@end