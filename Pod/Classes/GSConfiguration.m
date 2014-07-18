//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfiguration.h"

#define GENERATE_NSNUMBER_GETTER(typeName, upperTypeName) \
- (typeName)getRemote##upperTypeName { \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    typeName value = [[self.propValueStore objectForKey:property.name] typeName##Value]; \
    NSLog(@"getter SEL = %@ value %f", NSStringFromSelector(_cmd), value); \
    return value; \
}

#define GENERATE_NSNUMBER_SETTER(typeName, upperTypeName) \
- (void)setRemote##upperTypeName:(typeName)value { \
    NSLog(@"setter SEL = %@ value %f", NSStringFromSelector(_cmd), value); \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    NSNumber *number = [NSNumber numberWith##upperTypeName:value]; \
    [self.propValueStore setObject:number forKey:property.name]; \
}

#define GENERATE_NSNUMBER_ACCESSORS(typeName, upperTypeName)\
GENERATE_NSNUMBER_GETTER(typeName, upperTypeName)\
GENERATE_NSNUMBER_SETTER(typeName, upperTypeName)

@interface GSConfiguration ()

@property (nonatomic, strong) NSMutableDictionary *propValueStore;

@end

@implementation GSConfiguration

- (id)init {
    self = [super init];
    if (self) {
        self.propValueStore = [NSMutableDictionary dictionary];

    }

    return self;
}

- (BOOL)containsKey:(NSString *)key {
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL isSetter = NO;
    RTProperty *property = [self dynamicPropertyForSelector:sel isSetter:&isSetter];

    if (property) {
        NSLog(@"attempting to add method %@, sel = %@", property.name, NSStringFromSelector(sel));
        [self addMethodForSelector:sel property:property isSetter:isSetter];

        if (property.customGetter) {
            [self instanceMethodForSelector:property.customGetter];
        }

        if (property.customSetter) {
            [self instanceMethodForSelector:property.customSetter];
        }

        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (void)addMethodForSelector:(SEL)sel property:(RTProperty *)property isSetter:(BOOL)isSetter {
    const char *impEncoding;
    SEL subSel = nil;
    unichar type = [property.typeEncoding characterAtIndex:0];
    NSLog(@"add method for type: %c", type);

    if (isSetter) {
        switch (type) {
            case '@': {
                subSel = @selector(setRemoteObject:);
                break;
            }
            case 'c': {
                subSel = @selector(setRemoteChar:);
                break;
            }
            case 's': {
                subSel = @selector(setRemoteShort:);
                break;
            }
            case 'i': {
                subSel = @selector(setRemoteInt:);
                break;
            }
            case 'l': {
                subSel = @selector(setRemoteLong:);
                break;
            }
            case 'f': {
                subSel = @selector(setRemoteFloat:);
                break;
            }
            case 'd': {
                subSel = @selector(setRemoteDouble:);
                break;
            }
            default: break;
        }
        impEncoding = [[NSString stringWithFormat:@"v@:%c", type] cStringUsingEncoding:NSASCIIStringEncoding];
    } else {
        switch (type) {
            case '@': {
                subSel = @selector(getRemoteObject);
                break;
            }
            case 'c': {
                subSel = @selector(getRemoteChar);
                break;
            }
            case 's': {
                subSel = @selector(getRemoteShort);
                break;
            }
            case 'i': {
                subSel = @selector(getRemoteInt);
                break;
            }
            case 'l': {
                subSel = @selector(getRemoteLong);
                break;
            }
            case 'f': {
                subSel = @selector(getRemoteFloat);
                break;
            }
            case 'd': {
                subSel = @selector(getRemoteDouble);
                break;
            }
            default: break;
        }
        impEncoding = [[NSString stringWithFormat:@"%c@:", type] cStringUsingEncoding:NSASCIIStringEncoding];
    }

    if (subSel) {
        class_addMethod([self class], sel, [self instanceMethodForSelector:subSel], impEncoding);
    }
}

+ (RTProperty *)dynamicPropertyForSelector:(SEL)sel isSetter:(BOOL *)isSetter {
    NSString *propName = NSStringFromSelector(sel);
    if ([[propName substringToIndex:3] isEqualToString:@"set"]) {
        if (isSetter) {
            *isSetter = YES;
        }
        propName = [propName substringFromIndex:3];
        propName = [propName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                     withString:[[propName substringToIndex:1] lowercaseString]];
        propName = [propName stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    RTProperty *property = [self rt_propertyForName:propName];
    if (property) {
        return property;
    } else {
        for (RTProperty *prop in [self rt_properties]) {
            if (prop.isDynamic && strcmp(sel_getName(prop.customGetter), sel_getName(sel)) == 0) {
                if (isSetter) {
                    *isSetter = NO;
                }
                return prop;
            } else if (prop.isDynamic && strcmp(sel_getName(prop.customSetter), sel_getName(sel)) == 0) {
                if (isSetter) {
                    *isSetter = YES;
                }
                return prop;
            }
        }
    }

    return nil;
}

GENERATE_NSNUMBER_ACCESSORS(char, Char)
GENERATE_NSNUMBER_ACCESSORS(short, Short)
GENERATE_NSNUMBER_ACCESSORS(int, Int)
GENERATE_NSNUMBER_ACCESSORS(long, Long)
GENERATE_NSNUMBER_ACCESSORS(float, Float)
GENERATE_NSNUMBER_ACCESSORS(double, Double)

// TODO: BOOL accessors

@end