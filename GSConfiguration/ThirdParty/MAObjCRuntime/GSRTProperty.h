
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


typedef enum
{
    GSRTPropertySetterSemanticsAssign,
    GSRTPropertySetterSemanticsRetain,
    GSRTPropertySetterSemanticsCopy
}
GSRTPropertySetterSemantics;

@interface GSRTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;
+ (id)propertyWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (id)initWithObjCProperty: (objc_property_t)property;
- (id)initWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (NSDictionary *)attributes;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (BOOL)addToClass:(Class)classToAddTo;
#endif

- (NSString *)attributeEncodings;
- (BOOL)isReadOnly;
- (GSRTPropertySetterSemantics)setterSemantics;
- (BOOL)isNonAtomic;
- (BOOL)isDynamic;
- (BOOL)isWeakReference;
- (BOOL)isEligibleForGarbageCollection;
- (SEL)customGetter;
- (SEL)customSetter;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)oldTypeEncoding;
- (NSString *)ivarName;

@end

extern NSString * const GSRTPropertyTypeEncodingAttribute;
extern NSString * const GSRTPropertyBackingIVarNameAttribute;

extern NSString * const GSRTPropertyCopyAttribute;
extern NSString * const GSRTPropertyRetainAttribute;
extern NSString * const GSRTPropertyCustomGetterAttribute;
extern NSString * const GSRTPropertyCustomSetterAttribute;
extern NSString * const GSRTPropertyDynamicAttribute;
extern NSString * const GSRTPropertyEligibleForGarbageCollectionAttribute;
extern NSString * const GSRTPropertyNonAtomicAttribute;
extern NSString * const GSRTPropertyOldTypeEncodingAttribute;
extern NSString * const GSRTPropertyReadOnlyAttribute;
extern NSString * const GSRTPropertyWeakReferenceAttribute;