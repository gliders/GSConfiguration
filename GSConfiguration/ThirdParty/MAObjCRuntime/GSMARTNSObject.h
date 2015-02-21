
#import <Foundation/Foundation.h>


@class GSRTProtocol;
@class GSRTIvar;
@class GSRTProperty;
@class GSRTMethod;
@class GSRTUnregisteredClass;

@interface NSObject (GS_MARuntime)

// includes the receiver
+ (NSArray *)gsrt_subclasses;

+ (GSRTUnregisteredClass *)gsrt_createUnregisteredSubclassNamed: (NSString *)name;
+ (Class)gsrt_createSubclassNamed: (NSString *)name;
+ (void)gsrt_destroyClass;

+ (BOOL)gsrt_isMetaClass;
+ (Class)gsrt_setSuperclass: (Class)newSuperclass;
+ (size_t)gsrt_instanceSize;

+ (NSArray *)gsrt_protocols;

+ (NSArray *)gsrt_methods;
+ (GSRTMethod *)gsrt_methodForSelector: (SEL)sel;

+ (void)gsrt_addMethod: (GSRTMethod *)method;

+ (NSArray *)gsrt_ivars;
+ (GSRTIvar *)gsrt_ivarForName: (NSString *)name;

+ (NSArray *)gsrt_properties;
+ (GSRTProperty *)gsrt_propertyForName: (NSString *)name;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)gsrt_addProperty: (GSRTProperty *)property;
#endif

// Apple likes to fiddle with -class to hide their dynamic subclasses
// e.g. KVO subclasses, so [obj class] can lie to you
// gsrt_class is a direct call to object_getClass (which in turn
// directly hits up the isa) so it will always tell the truth
- (Class)gsrt_class;
- (Class)gsrt_setClass: (Class)newClass;

@end
