//
// Created by Ryan Brignoni on 2/20/15.
// Copyright (c) 2015 Ryan Brignoni. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GSURLStringTransformer.h"

@interface GSURLStringTransformerTest : XCTestCase

@end

@implementation GSURLStringTransformerTest

+ (void)setUp {
    [NSValueTransformer setValueTransformer:[[GSURLStringTransformer alloc] init]
                                    forName:GSURLStringTransformerName];
}

- (void)testForwardURLTransform {
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:GSURLStringTransformerName];

    NSString *urlString = @"http://glide.rs";
    NSURL *url = [transformer transformedValue:urlString];
    XCTAssertNotNil(url, @"url was not transformed");
    XCTAssertTrue([url.absoluteString isEqualToString:urlString], @"url was not transformed accurately");
}

- (void)testReverseURLTransform {
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:GSURLStringTransformerName];

    NSString *urlString = @"http://glide.rs";
    NSURL *url = [NSURL URLWithString:urlString];

    NSString *reversedString = [transformer reverseTransformedValue:url];
    XCTAssertNotNil(reversedString, @"url was not reversed");
    XCTAssertTrue([reversedString isEqualToString:urlString], @"url was not reversed accurately");
}

@end