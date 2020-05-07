#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_OS_TV
    #import <UIKit/UIKit.h>
    #define MAS_VIEW UIView
    #define MAS_VIEW_CONTROLLER UIViewController
    #define MASEdgeInsets UIEdgeInsets
    typedef UILayoutPriority EMAsync_LayoutPriority;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityRequired = UILayoutPriorityRequired;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultMedium = 500;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultLow = UILayoutPriorityDefaultLow;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;
#elif TARGET_OS_MAC
    #import <AppKit/AppKit.h>
    #define MAS_VIEW NSView
    #define MASEdgeInsets NSEdgeInsets
    typedef NSLayoutPriority EMAsync_LayoutPriority;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityRequired = NSLayoutPriorityRequired;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDragThatCanResizeWindow = NSLayoutPriorityDragThatCanResizeWindow;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultMedium = 501;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityWindowSizeStayPut = NSLayoutPriorityWindowSizeStayPut;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDragThatCannotResizeWindow = NSLayoutPriorityDragThatCannotResizeWindow;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
    static const EMAsync_LayoutPriority EMAsync_LayoutPriorityFittingSizeCompression = NSLayoutPriorityFittingSizeCompression;
#endif
#define MASAttachKeys(...)                                                        \
    {                                                                             \
        NSDictionary *keyPairs = NSDictionaryOfVariableBindings(__VA_ARGS__);     \
        for (id key in keyPairs.allKeys) {                                        \
            id obj = keyPairs[key];                                               \
            NSAssert([obj respondsToSelector:@selector(setMas_key:)],             \
                     @"Cannot attach mas_key to %@", obj);                        \
            [obj setMas_key:key];                                                 \
        }                                                                         \
    }
#define MAS_NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define MAS_NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (MAS_NSUINT_BIT - howmuch)))
static inline id _MASBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(MASEdgeInsets)) == 0) {
        MASEdgeInsets actual = (MASEdgeInsets)va_arg(v, MASEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}
#define MASBoxValue(value) _MASBoxValue(@encode(__typeof__((value))), (value))
