//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSRemoteSource.h"
#import "GSConfigurationLogging.h"

@interface GSRemoteSource ()

@property (nonatomic, strong, readwrite) NSURL *endpoint;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) GSConfigurationReady readyBlock;
@property (nonatomic, copy) GSJSONResponseParser parserBlock;
@property (nonatomic, strong) NSTimer *pollTimer;

@end

@implementation GSRemoteSource

- (instancetype)initWithEndpoint:(NSURL *)endpoint parserBlock:(GSJSONResponseParser)parserBlock {
    self = [super init];

    if (self) {
        _endpoint = endpoint;
        _timeoutInterval = 60;
        _parserBlock = parserBlock;
        _cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = [_endpoint absoluteString];
    }

    return self;
}

- (void)setRefreshIntervalInSeconds:(CFTimeInterval)refreshIntervalInSeconds {
    _refreshIntervalInSeconds = refreshIntervalInSeconds;

    [self.pollTimer invalidate];

    if (_refreshIntervalInSeconds) {
        self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:_refreshIntervalInSeconds
                                                          target:self
                                                        selector:@selector(pollConfiguration)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)pollConfiguration {
    if (self.readyBlock) {
        [self fetchConfiguration:self.readyBlock];
    }
}

- (void)fetchConfiguration:(GSConfigurationReady)readyBlock {
    if (self.readyBlock != readyBlock) {
        self.readyBlock = readyBlock;
    }

    __weak typeof(self) wself = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.endpoint
                                             cachePolicy:self.cachePolicy
                                         timeoutInterval:self.timeoutInterval];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   [wself parseResponse:data];
                               } else {
                                   GSLogError(@"Error encountered while trying to sync GSRemoteSource endpoint %@, error: %@", wself.endpoint, error);
                               }
                           }];
}

- (void)parseResponse:(NSData *)data {
    NSError *jsonError = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&jsonError];

    if (!jsonError) {
        NSDictionary *configurationData = nil;
        
        if (self.parserBlock != nil)
        {
            configurationData = self.parserBlock(jsonData);
            if (!configurationData) {
                configurationData = @{};
                GSLogWarn(@"JSON parser did not return a dictionary.");
            }
            
        } else if ( [jsonData isKindOfClass:[NSDictionary class] ] )
        {
            configurationData = (NSDictionary *)jsonData;
        } else
        {
            GSLogWarn(@"Unhandled json data found in response");
            configurationData = @{};
        }

        self.readyBlock(configurationData);
    } else {
        GSLogError(@"Unable to parse JSON response from %@: %@", self.endpoint, jsonError);
    }
}

+ (instancetype)sourceWithEndpoint:(NSURL *)endpoint parserBlock:(GSJSONResponseParser)parserBlock {
    return [[self alloc] initWithEndpoint:endpoint parserBlock:parserBlock];
}

@end