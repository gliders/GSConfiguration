
#import "GSMARTNSObject.h"

#import <objc/runtime.h>

#import "GSRTProtocol.h"
#import "GSRTIvar.h"
#import "GSRTProperty.h"
#import "GSRTMethod.h"
#import "GSRTUnregisteredClass.h"


@implementation NSObject (GS_MARuntime)

+ (NSArray *)gsrt_subclasses
{
    Class *buffer = NULL;
    
    int count, size;
    do
    {
        count = objc_getClassList(NULL, 0);
        buffer = realloc(buffer, count * sizeof(*buffer));
        size = objc_getClassList(buffer, count);
    } while(size != count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < count; i++)
    {
        Class candidate = buffer[i];
        Class superclass = candidate;
        while(superclass)
        {
            if(superclass == self)
            {
                [array addObject: candidate];
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }
    free(buffer);
    return array;
}

+ (GSRTUnregisteredClass *)gsrt_createUnregisteredSubclassNamed: (NSString *)name
{
    return [GSRTUnregisteredClass unregisteredClassWithName:name withSuperclass:self];
}

+ (Class)gsrt_createSubclassNamed: (NSString *)name
{
    return [[self gsrt_createUnregisteredSubclassNamed:name] registerClass];
}

+ (void)gsrt_destroyClass
{
    objc_disposeClassPair(self);
}

+ (BOOL)gsrt_isMetaClass
{
    return class_isMetaClass(self);
}

#ifdef __clang__
#pragma clang diagnostic push
#endif
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (Class)gsrt_setSuperclass: (Class)newSuperclass
{
    return class_setSuperclass(self, newSuperclass);
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif

+ (size_t)gsrt_instanceSize
{
    return class_getInstanceSize(self);
}

+ (NSArray *)gsrt_protocols
{
    unsigned int count;
    Protocol **protocols = class_copyProtocolList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [GSRTProtocol protocolWithObjCProtocol:protocols[i]]];
    
    free(protocols);
    return array;
}

+ (NSArray *)gsrt_methods
{
    unsigned int count;
    Method *methods = class_copyMethodList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [GSRTMethod methodWithObjCMethod:methods[i]]];
    
    free(methods);
    return array;
}

+ (GSRTMethod *)gsrt_methodForSelector: (SEL)sel
{
    Method m = class_getInstanceMethod(self, sel);
    if(!m) return nil;
    
    return [GSRTMethod methodWithObjCMethod:m];
}

+ (void)gsrt_addMethod: (GSRTMethod *)method
{
    class_addMethod(self, [method selector], [method implementation], [[method signature] UTF8String]);
}

+ (NSArray *)gsrt_ivars
{
    unsigned int count;
    Ivar *list = class_copyIvarList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [GSRTIvar ivarWithObjCIvar:list[i]]];
    
    free(list);
    return array;
}

+ (GSRTIvar *)gsrt_ivarForName: (NSString *)name
{
    Ivar ivar = class_getInstanceVariable(self, [name UTF8String]);
    if(!ivar) return nil;
    return [GSRTIvar ivarWithObjCIvar:ivar];
}

+ (NSArray *)gsrt_properties
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [GSRTProperty propertyWithObjCProperty:list[i]]];
    
    free(list);
    return array;
}

+ (GSRTProperty *)gsrt_propertyForName: (NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    if(!property) return nil;
    return [GSRTProperty propertyWithObjCProperty:property];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)gsrt_addProperty: (GSRTProperty *)property
{
    return [property addToClass:self];
}
#endif

- (Class)gsrt_class
{
    return object_getClass(self);
}

- (Class)gsrt_setClass: (Class)newClass
{
    return object_setClass(self, newClass);
}

@end

