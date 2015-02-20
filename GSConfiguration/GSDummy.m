//
// Created by Ryan Brignoni on 2/12/15.
// Copyright (c) 2015 Ryan Brignoni. All rights reserved.
//

#import "GSDummy.h"
#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"
#import "GSDictionarySource.h"
#import "GSRemoteSource.h"

@implementation GSDummy

- (instancetype)init {
    self = [super init];
    if (self) {
        [GSConfigurationManager addSource:[GSDictionarySource sourceWithData:@{}]];
        [GSConfigurationManager addSource:[GSRemoteSource sourceWithEndpoint:[NSURL URLWithString:@"http://google.com"]
                                                                 parserBlock:^NSDictionary *(id jsonData) {
            return nil;
        }]];



    }

    return self;
}


@end