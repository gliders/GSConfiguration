//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfigurationManager.h"
#import "GSUserDefaultsStore.h"
#import "GSSource.h"
#import "GSURLStringTransformer.h"

@interface GSConfigurationManager ()

@property (nonatomic, strong) NSMutableOrderedSet *sources;
@property (nonatomic, strong) NSMutableDictionary *dataForSources;
@property (nonatomic, strong) NSMutableDictionary *transformerFor;
@property (nonatomic, strong) id<GSStore> store;
@property (nonatomic) dispatch_queue_t sourceQueue;

@end

@implementation GSConfigurationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _sources = [NSMutableOrderedSet orderedSet];
        _sourceQueue = dispatch_queue_create("rs.glide.sourceQueue", DISPATCH_QUEUE_SERIAL);
        _dataForSources = [NSMutableDictionary dictionary];
        _transformerFor = [NSMutableDictionary dictionary];

        [NSValueTransformer setValueTransformer:[[GSURLStringTransformer alloc] init]
                                        forName:GSURLStringTransformerName];

        [self registerTransformerName:GSURLStringTransformerName forClass:[NSURL class]];
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

- (void)setConfigValue:(id)value forKey:(NSString *)key withClass:(NSString *)clazz {
    if (clazz) {
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:self.transformerFor[clazz]];
        if (transformer) {
            value = [transformer reverseTransformedValue:transformer];
        }
    }

    [self.store setConfigObject:value forKey:key];
}

- (id)configValueForKey:(NSString *)key withClass:(NSString *)clazz {
    id value = [self.store configObjectForKey:key];

    if (clazz) {
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:self.transformerFor[clazz]];
        if (transformer) {
            value = [transformer transformedValue:value];
        }
    }

    return value;
}

- (void)registerTransformerName:(NSString *)transformerName forClass:(Class)clazz {
    self.transformerFor[NSStringFromClass(clazz)] = transformerName;
};

+ (void)setConfigValue:(id)value forKey:(NSString *)key withClass:(NSString *)clazz {
    [[self defaultManager] setConfigValue:value forKey:key withClass:clazz];
}

+ (id)configValueForKey:(NSString *)name withClass:(NSString *)clazz {
    return [[self defaultManager] configValueForKey:name withClass:clazz];
}

+ (void)addSource:(GSSource *)source {
    [[self defaultManager] addSource:source];
}

+ (void)setStore:(id <GSStore>)store {
    [GSConfigurationManager defaultManager].store = store;
}

+ (void)cleanUp {
    [[self defaultManager] cleanUp];
}

+ (void)registerTransformerName:(NSString *)transformerName forClass:(Class)type {
    [[self defaultManager] registerTransformerName:transformerName forClass:type];
}

+ (GSConfigurationManager *)defaultManager {
    static dispatch_once_t predicate;
    static GSConfigurationManager *instance;

    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

@end