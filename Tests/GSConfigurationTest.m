//
//  GSConfigurationTests.m
//  GSConfigurationTests
//
//  Created by Ryan Brignoni on 07/17/2014.
//  Copyright (c) 2014 Ryan Brignoni. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GSConfiguration.h"
#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"
#import "GSDictionarySource.h"

@interface TestConfig : GSConfiguration

@property (nonatomic) BOOL newFeatureActivated;
@property (nonatomic) NSUInteger timeout;
@property (nonatomic) NSURL *baseUrl;
@property (nonatomic) NSString *apiKey;

@end

@implementation TestConfig

@dynamic newFeatureActivated;
@dynamic timeout;
@dynamic baseUrl;
@dynamic apiKey;

@end

@interface GSConfigurationTest : XCTestCase
@end

@implementation GSConfigurationTest

+ (void)setUp {
    [GSConfigurationManager setStore:[GSUserDefaultsStore store]];
}

- (void)testPListAsConfigSource {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *plistPath = [bundle pathForResource:@"SampleConfig" ofType:@"plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [GSConfigurationManager setStore:[GSUserDefaultsStore store]];
    [GSConfigurationManager addSource:[GSDictionarySource sourceWithDictionary:plistData]];

    TestConfig *config = [TestConfig config];
    XCTAssertTrue(config.newFeatureActivated);
    XCTAssertEqual(config.timeout, 4000);
    XCTAssertTrue([config.baseUrl isKindOfClass:[NSURL class]]);
    XCTAssertTrue([config.baseUrl.absoluteString isEqualToString:@"http://glide.rs"]);
    XCTAssertTrue([config.apiKey isEqualToString:@"1234abcde"]);
}

@end
