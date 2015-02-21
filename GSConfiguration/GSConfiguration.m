//
// Created by Ryan Brignoni on 7/17/14.
//

#import "GSConfiguration.h"
#import "ThirdParty/MAObjCRuntime/RTProperty.h"
#import "ThirdParty/MAObjcRuntime/MARTNSObject.h"
#import "GSConfigurationManager.h"
#import "GSConfigurationLogging.h"

#define GENERATE_NSNUMBER_SETTER(typeName, upperTypeName) \
- (void)setConfig##upperTypeName:(typeName)value { \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    NSNumber *number = [NSNumber numberWith##upperTypeName:value]; \
    [GSConfigurationManager setConfigValue:number forKey:property.name withClass:nil]; \
}

#define GENERATE_COMPLEX_NSNUMBER_GETTER(typeName, upperTypeName, nsNumberName) \
- (typeName)getConfig##upperTypeName { \
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil]; \
    typeName value = [[GSConfigurationManager configValueForKey:property.name withClass:nil] nsNumberName##Value]; \
    return value; \
}

#define GENERATE_NSNUMBER_GETTER(typeName, upperTypeName) GENERATE_COMPLEX_NSNUMBER_GETTER(typeName, upperTypeName, typeName)

#define GENERATE_NSNUMBER_ACCESSORS(typeName, upperTypeName)\
GENERATE_NSNUMBER_SETTER(typeName, upperTypeName)\
GENERATE_NSNUMBER_GETTER(typeName, upperTypeName)

#define GENERATE_COMPLEX_NSNUMBER_ACCESSORS(typeName, upperTypeName, nsNumberName)\
GENERATE_NSNUMBER_SETTER(typeName, upperTypeName)\
GENERATE_COMPLEX_NSNUMBER_GETTER(typeName, upperTypeName, nsNumberName)

@implementation GSConfiguration

+ (instancetype)config {
    return [[self alloc] init];
}

- (void)setConfigObject:(id)value {
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil];
    
    BOOL setWithCopy = [property.attributes[RTPropertyCopyAttribute] boolValue];

    if (property.isWeakReference) {
        value = [NSValue valueWithNonretainedObject:value];
    } else if (setWithCopy) {
        value = [value copy];
    } else if (!value) {
        value = [NSNull null];
    }

    NSString *clazz = [GSConfiguration extractClassFromEncoding:property.typeEncoding];
    [GSConfigurationManager setConfigValue:value forKey:property.name withClass:clazz];
}

- (id)getConfigObject {
    RTProperty *property = [[self class] dynamicPropertyForSelector:_cmd isSetter:nil];
    NSString *clazz = [GSConfiguration extractClassFromEncoding:property.typeEncoding];
    id value = [GSConfigurationManager configValueForKey:property.name withClass:clazz];
    
    if (property.isWeakReference) {
        value = [value nonretainedObjectValue];
    } else if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    
    return value;
}

+ (NSString *)extractClassFromEncoding:(NSString *)encoding {
    if ([encoding characterAtIndex:0] == '@') {
        return [encoding substringWithRange:NSMakeRange(2, encoding.length - 3)];
    } else {
        return nil;
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL isSetter = NO;
    RTProperty *property = [self dynamicPropertyForSelector:sel isSetter:&isSetter];
    
    if (property) {
        [self addMethodForSelector:sel property:property isSetter:isSetter];
        
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (void)addMethodForSelector:(SEL)sel property:(RTProperty *)property isSetter:(BOOL)isSetter {
    const char *impEncoding;
    SEL subSel = nil;
    unichar type = [property.typeEncoding characterAtIndex:0];

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
            case 'B': {
                subSel = @selector(setConfigBool:);
            }
            default: {
                GSLogWarn(@"unsupported configuration type %c", type);
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
            case 'B': {
                subSel = @selector(getConfigBool);
            }
            default: {
                GSLogWarn(@"unsupported configuration type %c", type);
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

GENERATE_COMPLEX_NSNUMBER_ACCESSORS(unsigned char, UnsignedChar, unsignedChar)
GENERATE_COMPLEX_NSNUMBER_ACCESSORS(unsigned short, UnsignedShort, unsignedShort)
GENERATE_COMPLEX_NSNUMBER_ACCESSORS(unsigned int, UnsignedInt, unsignedInt)
GENERATE_COMPLEX_NSNUMBER_ACCESSORS(unsigned long, UnsignedLong, unsignedLong)

#define STD_BOOL bool
#undef bool
GENERATE_COMPLEX_NSNUMBER_ACCESSORS(BOOL, Bool, bool)
#define bool STD_BOOL

@end