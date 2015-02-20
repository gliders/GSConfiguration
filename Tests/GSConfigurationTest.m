//
//  GSConfigurationTests.m
//  GSConfigurationTests
//
//  Created by Ryan Brignoni on 07/17/2014.
//  Copyright (c) 2014 Ryan Brignoni. All rights reserved.
//

#import <XCTest/XCTestCase.h>
#import "GSConfiguration.h"
#import "GSConfiguration+Shared.h"

@interface TestConfig : GSConfiguration

@property (getter=isConnected, setter=setConnected:) BOOL connect;

@end

@implementation TestConfig

@dynamic connect;

@end

@interface GSConfigurationTest : XCTestCase
@end

@implementation GSConfigurationTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testConfigurationFacade {
    TestConfig *config = [TestConfig config];
}

@end
