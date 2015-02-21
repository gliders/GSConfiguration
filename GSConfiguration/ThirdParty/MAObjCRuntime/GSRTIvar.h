
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface GSRTIvar : NSObject
{
}

+ (id)ivarWithObjCIvar: (Ivar)ivar;
+ (id)ivarWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;
+ (id)ivarWithName: (NSString *)name encode: (const char *)encodeStr;

- (id)initWithObjCIvar: (Ivar)ivar;
- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;

- (NSString *)name;
- (NSString *)typeEncoding;
- (ptrdiff_t)offset;

@end
