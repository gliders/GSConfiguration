//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfiguration.h"
#import "RTProperty.h"
#import "MARTNSObject.h"
#import "GSConfigurationManager.h"
#import "GSConfigurationManager+Store.h"

#define GENERATE_NSNUMBER_GETTER(typeName, upperTypeName) \
- (typeName)getConfig##upperTypeName { \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    typeName value = [[GSConfigurationManager configValueForKey:property.name] typeName##Value]; \
    NSLog(@"getter SEL = %@ value %f", NSStringFromSelector(_cmd), value); \
    return value; \
}

#define GENERATE_NSNUMBER_SETTER(typeName, upperTypeName) \
- (void)setConfig##upperTypeName:(typeName)value { \
    NSLog(@"setter SEL = %@ value %f", NSStringFromSelector(_cmd), value); \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    NSNumber *number = [NSNumber numberWith##upperTypeName:value]; \
    [GSConfigurationManager setConfigValue:number forKey:property.name]; \
}

#define GENERATE_UNSIGNED_NSNUMBER_GETTER(typeName, upperTypeName, nsNumberName) \
- (typeName)getConfig##upperTypeName { \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    typeName value = [[GSConfigurationManager configValueForKey:property.name] nsNumberName##Value]; \
    NSLog(@"getter SEL = %@ value %f", NSStringFromSelector(_cmd), value); \
    return value; \
}

#define GENERATE_NSNUMBER_ACCESSORS(typeName, upperTypeName)\
GENERATE_NSNUMBER_GETTER(typeName, upperTypeName)\
GENERATE_NSNUMBER_SETTER(typeName, upperTypeName)

#define GENERATE_UNSIGNED_NSNUMBER_ACCESSORS(typeName, upperTypeName, nsNumberName)\
GENERATE_UNSIGNED_NSNUMBER_GETTER(typeName, upperTypeName, nsNumberName)\
GENERATE_NSNUMBER_SETTER(typeName, upperTypeName)

@implementation GSConfiguration

- (void)setConfigObject:(id)value {
    NSLog(@"setter SEL = %@ value %@", NSStringFromSelector(_cmd), value);
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil];

    BOOL setWithCopy = [property.attributes[RTPropertyCopyAttribute] boolValue];
    if (property.isWeakReference) {
        value = [NSValue valueWithNonretainedObject:value];
    } else if (setWithCopy) {
        value = [value copy];
    } else if (!value) {
        value = [NSNull null];
    }

    [GSConfigurationManager setConfigValue:value forKey:property.name];
}

- (id)getConfigObject {
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil];
    id value = [GSConfigurationManager configValueForKey:property.name];

    if (property.isWeakReference) {
        value = [value nonretainedObjectValue];
    } else if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }

    NSLog(@"getter SEL = %@ value %@", NSStringFromSelector(_cmd), value);
    return value;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL isSetter = NO;
    RTProperty *property = [self dynamicPropertyForSelector:sel isSetter:&isSetter];

    if (property) {
        NSLog(@"attempting to add method %@, sel = %@", property.name, NSStringFromSelector(sel));
        [self addMethodForSelector:sel property:property isSetter:isSetter];

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
                subSel = @selector(setConfigObject:);
                break;
            }
            case 'c': {
                subSel = @selector(setConfigChar:);
                break;
            }
            case 'C': {
                subSel = @selector(setConfigUnsignedChar:);
                break;
            }
            case 's': {
                subSel = @selector(setConfigShort:);
                break;
            }
            case 'S': {
                subSel = @selector(setConfigUnsignedShort:);
                break;
            }
            case 'i': {
                subSel = @selector(setConfigInt:);
                break;
            }
            case 'I': {
                subSel = @selector(setConfigUnsignedInt:);
                break;
            }
            case 'l': {
                subSel = @selector(setConfigLong:);
                break;
            }
            case 'L': {
                subSel = @selector(setConfigUnsignedLong:);
                break;
            }
            case 'f': {
                subSel = @selector(setConfigFloat:);
                break;
            }
            case 'd': {
                subSel = @selector(setConfigDouble:);
                break;
            }
            default: {
                NSLog(@"unknown type %c", type);
                break;
            }
        }
        impEncoding = [[NSString stringWithFormat:@"v@:%c", type] cStringUsingEncoding:NSASCIIStringEncoding];
    } else {
        switch (type) {
            case '@': {
                subSel = @selector(getConfigObject);
                break;
            }
            case 'c': {
                subSel = @selector(getConfigChar);
                break;
            }
            case 'C': {
                subSel = @selector(getConfigUnsignedChar);
                break;
            }
            case 's': {
                subSel = @selector(getConfigShort);
                break;
            }
            case 'S': {
                subSel = @selector(getConfigUnsignedShort);
                break;
            }
            case 'i': {
                subSel = @selector(getConfigInt);
                break;
            }
            case 'I': {
                subSel = @selector(getConfigUnsignedInt);
                break;
            }
            case 'l': {
                subSel = @selector(getConfigLong);
                break;
            }
            case 'L': {
                subSel = @selector(getConfigUnsignedLong);
                break;
            }
            case 'f': {
                subSel = @selector(getConfigFloat);
                break;
            }
            case 'd': {
                subSel = @selector(getConfigDouble);
                break;
            }
            default: {
                NSLog(@"unknown type %c", type);
                break;
            }
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

GENERATE_UNSIGNED_NSNUMBER_ACCESSORS(unsigned char, UnsignedChar, unsignedChar)
GENERATE_UNSIGNED_NSNUMBER_ACCESSORS(unsigned short, UnsignedShort, unsignedShort)
GENERATE_UNSIGNED_NSNUMBER_ACCESSORS(unsigned int, UnsignedInt, unsignedInt)
GENERATE_UNSIGNED_NSNUMBER_ACCESSORS(unsigned long, UnsignedLong, unsignedLong)

@end