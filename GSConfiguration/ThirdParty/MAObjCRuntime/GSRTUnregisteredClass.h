
#import <Foundation/Foundation.h>


@class GSRTProtocol;
@class GSRTIvar;
@class GSRTMethod;
@class GSRTProperty;

@interface GSRTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass;
+ (id)unregisteredClassWithName: (NSString *)name;

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass;
- (id)initWithName: (NSString *)name;

- (void)addProtocol: (GSRTProtocol *)protocol;
- (void)addIvar: (GSRTIvar *)ivar;
- (void)addMethod: (GSRTMethod *)method;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (void)addProperty: (GSRTProperty *)property;
#endif

- (Class)registerClass;

@end
