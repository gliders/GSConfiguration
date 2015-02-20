//
//  GSConfigurationTests.m
//  GSConfigurationTests
//
//  Created by Ryan Brignoni on 07/17/2014.
//  Copyright (c) 2014 Ryan Brignoni. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GSConfiguration.h"
#import "GSConfiguration+Shared.h"
#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"

@interface SomeObject : NSObject <NSCoding>
@property (nonatomic, strong) NSString *test;
@end

@implementation SomeObject
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.test forKey:@"test"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];

    if (self) {
        self.test = [coder decodeObjectForKey:@"test"];
    }

    return self;
}

@end

@interface TestConfig : GSConfiguration

@property (getter=isConnected, setter=setConnected:) BOOL connect;
@property (nonatomic) SomeObject *obj;

@end

@implementation TestConfig

@dynamic connect;
@dynamic obj;

@end

@interface GSConfigurationTest : XCTestCase
@end

@implementation GSConfigurationTest

- (void)setUp {
    [super setUp];
    id<GSStore> store = [[GSUserDefaultsStore alloc] init];
    [GSConfigurationManager setStore:store];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testConfigurationFacade {
    TestConfig *config = [TestConfig config];
    config.connect = YES;
    BOOL connect = [[GSConfigurationManager configValueForKey:@"connect" withClass:nil] boolValue];
    XCTAssertTrue(connect, @"bool didn't store");

    SomeObject *object = [SomeObject new];
    object.test = @"test";
    config.obj = object;
    NSLog(@"testing obj graph");
    XCTAssertNotNil(config.obj.test, @"string wasnt stored");
    XCTAssertTrue([config.obj.test isEqualToString:((SomeObject *)[GSConfigurationManager configValueForKey:@"obj" withClass:nil]).test], @"obj graph didn't store");
}

@end
