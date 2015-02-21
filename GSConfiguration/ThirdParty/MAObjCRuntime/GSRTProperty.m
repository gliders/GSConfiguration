
#import "GSRTProperty.h"


@interface _GSRTObjCProperty : GSRTProperty
{
    objc_property_t _property;
    NSMutableDictionary *_attrs;
    NSString *_name;
}
@end

@implementation _GSRTObjCProperty

- (id)initWithObjCProperty: (objc_property_t)property
{
    if((self = [self init]))
    {
        _property = property;
        NSArray *attrPairs = [[NSString stringWithUTF8String: property_getAttributes(property)] componentsSeparatedByString: @","];
        _attrs = [[NSMutableDictionary alloc] initWithCapacity:[attrPairs count]];
        for(NSString *attrPair in attrPairs)
            [_attrs setObject:[attrPair substringFromIndex:1] forKey:[attrPair substringToIndex:1]];
    }
    return self;
}

- (id)initWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    if((self = [self init]))
    {
        _name = [name copy];
        _attrs = [attributes copy];
    }
    return self;
}

- (void)dealloc
{
    [_attrs release];
    [_name release];
    [super dealloc];
}

- (NSString *)name
{
    if (_property)
        return [NSString stringWithUTF8String: property_getName(_property)];
    else
        return _name;
}

- (NSDictionary *)attributes
{
    return [[_attrs copy] autorelease];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (BOOL)addToClass:(Class)classToAddTo
{
    NSDictionary *attrs = [self attributes];
    objc_property_attribute_t *cattrs = (objc_property_attribute_t*)calloc([attrs count], sizeof(objc_property_attribute_t));
    unsigned attrIdx = 0;
    for (NSString *attrCode in attrs) {
        cattrs[attrIdx].name = [attrCode UTF8String];
        cattrs[attrIdx].value = [[attrs objectForKey:attrCode] UTF8String];
        attrIdx++;
    }
    BOOL result = class_addProperty(classToAddTo,
                                    [[self name] UTF8String],
                                    cattrs,
                                    [attrs count]);
    free(cattrs);
    return result;
}
#endif

- (NSString *)attributeEncodings
{
    NSMutableArray *filteredAttributes = [NSMutableArray arrayWithCapacity:[_attrs count] - 2];
    for (NSString *attrKey in _attrs)
    {
        if (![attrKey isEqualToString:GSRTPropertyTypeEncodingAttribute] && ![attrKey isEqualToString:GSRTPropertyBackingIVarNameAttribute])
            [filteredAttributes addObject:[_attrs objectForKey:attrKey]];
    }
    return [filteredAttributes componentsJoinedByString: @","];
}

- (BOOL)hasAttribute: (NSString *)code
{
    return [_attrs objectForKey:code] != nil;
}

- (BOOL)isReadOnly
{
    return [self hasAttribute: GSRTPropertyReadOnlyAttribute];
}

- (GSRTPropertySetterSemantics)setterSemantics
{
    if([self hasAttribute: GSRTPropertyCopyAttribute]) return GSRTPropertySetterSemanticsCopy;
    if([self hasAttribute: GSRTPropertyRetainAttribute]) return GSRTPropertySetterSemanticsRetain;
    return GSRTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    return [self hasAttribute: GSRTPropertyNonAtomicAttribute];
}

- (BOOL)isDynamic
{
    return [self hasAttribute: GSRTPropertyDynamicAttribute];
}

- (BOOL)isWeakReference
{
    return [self hasAttribute: GSRTPropertyWeakReferenceAttribute];
}

- (BOOL)isEligibleForGarbageCollection
{
    return [self hasAttribute: GSRTPropertyEligibleForGarbageCollectionAttribute];
}

- (NSString *)contentOfAttribute: (NSString *)code
{
    return [_attrs objectForKey:code];
}

- (SEL)customGetter
{
    return NSSelectorFromString([self contentOfAttribute: GSRTPropertyCustomGetterAttribute]);
}

- (SEL)customSetter
{
    return NSSelectorFromString([self contentOfAttribute: GSRTPropertyCustomSetterAttribute]);
}

- (NSString *)typeEncoding
{
    return [self contentOfAttribute: GSRTPropertyTypeEncodingAttribute];
}

- (NSString *)oldTypeEncoding
{
    return [self contentOfAttribute: GSRTPropertyOldTypeEncodingAttribute];
}

- (NSString *)ivarName
{
    return [self contentOfAttribute: GSRTPropertyBackingIVarNameAttribute];
}

@end

@implementation GSRTProperty

+ (id)propertyWithObjCProperty: (objc_property_t)property
{
    return [[[self alloc] initWithObjCProperty: property] autorelease];
}

+ (id)propertyWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    return [[[self alloc] initWithName: name attributes: attributes] autorelease];
}

- (id)initWithObjCProperty: (objc_property_t)property
{
    [self release];
    return [[_GSRTObjCProperty alloc] initWithObjCProperty: property];
}

- (id)initWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    [self release];
    return [[_GSRTObjCProperty alloc] initWithName: name attributes: attributes];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %@ %@ %@>", [self class], self, [self name], [self attributeEncodings], [self typeEncoding], [self ivarName]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [GSRTProperty class]] &&
           [[self name] isEqual: [other name]] &&
           ([self attributeEncodings] ? [[self attributeEncodings] isEqual: [other attributeEncodings]] : ![other attributeEncodings]) &&
           [[self typeEncoding] isEqual: [other typeEncoding]] &&
           ([self ivarName] ? [[self ivarName] isEqual: [other ivarName]] : ![other ivarName]);
}

- (NSUInteger)hash
{
    return [[self name] hash] ^ [[self typeEncoding] hash];
}

- (NSString *)name
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSDictionary *)attributes
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (BOOL)addToClass:(Class)classToAddTo
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (NSString *)attributeEncodings
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (BOOL)isReadOnly
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}
- (GSRTPropertySetterSemantics)setterSemantics
{
    [self doesNotRecognizeSelector: _cmd];
    return GSRTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isDynamic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isWeakReference
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isEligibleForGarbageCollection
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (SEL)customGetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (SEL)customSetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)oldTypeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)ivarName
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

@end

NSString * const GSRTPropertyTypeEncodingAttribute                  = @"T";
NSString * const GSRTPropertyBackingIVarNameAttribute               = @"V";
NSString * const GSRTPropertyCopyAttribute                          = @"C";
NSString * const GSRTPropertyCustomGetterAttribute                  = @"G";
NSString * const GSRTPropertyCustomSetterAttribute                  = @"S";
NSString * const GSRTPropertyDynamicAttribute                       = @"D";
NSString * const GSRTPropertyEligibleForGarbageCollectionAttribute  = @"P";
NSString * const GSRTPropertyNonAtomicAttribute                     = @"N";
NSString * const GSRTPropertyOldTypeEncodingAttribute               = @"t";
NSString * const GSRTPropertyReadOnlyAttribute                      = @"R";
NSString * const GSRTPropertyRetainAttribute                        = @"&";
NSString * const GSRTPropertyWeakReferenceAttribute                 = @"W";