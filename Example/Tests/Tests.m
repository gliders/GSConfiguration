//
//  GSConfigurationTests.m
//  GSConfigurationTests
//
//  Created by Ryan Brignoni on 07/17/2014.
//  Copyright (c) 2014 Ryan Brignoni. All rights reserved.
//

#import "GSConfiguration.h"

@interface TestConfig : GSConfiguration

@property (nonatomic) NSURL *value;

@end

@implementation TestConfig

@dynamic value;

@end

SpecBegin(InitialSpecs)

describe(@"these will pass", ^{
    
    it(@"can set and retrieve integers", ^{
        TestConfig *config = TestConfig.new;
        NSURL *x = [NSURL URLWithString:@"http://example.com"];
        config.value = x;
        expect(config.value).equal(x);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^AsyncBlock {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            done();
        });
    });
});

SpecEnd
