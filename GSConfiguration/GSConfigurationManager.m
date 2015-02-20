//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"
#import "GSSource.h"

@interface GSConfigurationManager ()

@property (nonatomic, strong) NSMutableOrderedSet *sources;
@property (nonatomic, strong) NSMutableDictionary *dataForSources;
@property (nonatomic, strong) NSMutableDictionary *transformersForType;
@property (nonatomic, strong) id<GSStore> store;
@property (nonatomic) dispatch_queue_t sourceQueue;


@end

@implementation GSConfigurationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _sources = [NSMutableOrderedSet orderedSet];
        _sourceQueue = dispatch_queue_create("rs.glide.sourceQueue", DISPATCH_QUEUE_CONCURRENT);
        _dataForSources = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)addSource:(GSSource *)source {
    [self.sources addObject:source];

    __weak typeof(self) wself = self;

    dispatch_async(self.sourceQueue, ^{
        [source fetchConfiguration:^(NSDictionary *data) {
            [wself setData:data forSource:source];
        }];
    });
}

- (void)setData:(NSDictionary *)data forSource:(GSSource *)source {
    NSUInteger priority = [self.sources indexOfObject:source];

    self.dataForSources[@(priority)] = data;
    [self updateDataInStore];
}

- (void)updateDataInStore {
    NSArray *keys = [self.dataForSources allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(unsignedIntegerValue)];

    for (NSNumber *key in keys) {
        [self.store setConfigWithDictionary:self.dataForSources[key]];
    }
}

- (void)setStore:(id <GSStore>)store {
    _store = store;
    [self updateDataInStore];
}

- (void)cleanUp {
    [self.store flush];
}

- (void)setConfigValue:(id)value forKey:(NSString *)key {
    [self.store setConfigObject:value forKey:key];
}

- (id)configValueForKey:(NSString *)key {
    return [self.store configObjectForKey:key];
}

- (void)registerTransformerName:(NSString *)transformerName forClass:(Class)type {
    self.transformersForType[NSStringFromClass(type)] = transformerName;
};

+ (void)addSource:(GSSource *)source {
    [[self sharedInstance] addSource:source];
}

+ (void)setStore:(id <GSStore>)store {
    [self sharedInstance].store = store;
}

+ (void)cleanUp {
    [[self sharedInstance] cleanUp];
}

+ (void)registerTransformerName:(NSString *)transformerName forClass:(Class)type {
    [[self sharedInstance] registerTransformerName:transformerName forClass:type];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t predicate;
    static GSConfigurationManager *instance;

    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

@end