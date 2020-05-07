#import "EMAsyncEMAsyncNSLayoutConstraint+EMAsyncDebugAdditions.h"
#import "EMAsyncConstraint.h"
#import "EMAsyncLayoutConstraint.h"
@implementation NSLayoutConstraint (MASDebugAdditions)
#pragma mark - description maps
+ (NSDictionary *)layoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}
+ (NSDictionary *)layoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            @(NSLayoutAttributeFirstBaseline) : @"firstBaseline",
            @(NSLayoutAttributeLastBaseline) : @"lastBaseline",
#if TARGET_OS_IPHONE || TARGET_OS_TV
            @(NSLayoutAttributeLeftMargin)           : @"leftMargin",
            @(NSLayoutAttributeRightMargin)          : @"rightMargin",
            @(NSLayoutAttributeTopMargin)            : @"topMargin",
            @(NSLayoutAttributeBottomMargin)         : @"bottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"leadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"trailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"centerXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"centerYWithinMargins",
#endif
        };
    });
    return descriptionMap;
}
+ (NSDictionary *)layoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE || TARGET_OS_TV
        descriptionMap = @{
            @(EMAsync_LayoutPriorityDefaultHigh)      : @"high",
            @(EMAsync_LayoutPriorityDefaultLow)       : @"low",
            @(EMAsync_LayoutPriorityDefaultMedium)    : @"medium",
            @(EMAsync_LayoutPriorityRequired)         : @"required",
            @(EMAsync_LayoutPriorityFittingSizeLevel) : @"fitting size",
        };
#elif TARGET_OS_MAC
        descriptionMap = @{
            @(EMAsync_LayoutPriorityDefaultHigh)                 : @"high",
            @(EMAsync_LayoutPriorityDragThatCanResizeWindow)     : @"drag can resize window",
            @(EMAsync_LayoutPriorityDefaultMedium)               : @"medium",
            @(EMAsync_LayoutPriorityWindowSizeStayPut)           : @"window size stay put",
            @(EMAsync_LayoutPriorityDragThatCannotResizeWindow)  : @"drag cannot resize window",
            @(EMAsync_LayoutPriorityDefaultLow)                  : @"low",
            @(EMAsync_LayoutPriorityFittingSizeCompression)      : @"fitting size",
            @(EMAsync_LayoutPriorityRequired)                    : @"required",
        };
#endif
    });
    return descriptionMap;
}
#pragma mark - description override
+ (NSString *)descriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(mas_key)] && [obj mas_key]) {
        return [NSString stringWithFormat:@"%@:%@", [obj class], [obj mas_key]];
    }
    return [NSString stringWithFormat:@"%@:%p", [obj class], obj];
}
- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"<"];
    [description appendString:[self.class descriptionForObject:self]];
    [description appendFormat:@" %@", [self.class descriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.layoutAttributeDescriptionsByValue[@(self.firstAttribute)]];
    }
    [description appendFormat:@" %@", self.class.layoutRelationDescriptionsByValue[@(self.relation)]];
    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class descriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.layoutAttributeDescriptionsByValue[@(self.secondAttribute)]];
    }
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
        }
    }
    if (self.priority != EMAsync_LayoutPriorityRequired) {
        [description appendFormat:@" ^%@", self.class.layoutPriorityDescriptionsByValue[@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];
    }
    [description appendString:@">"];
    return description;
}
@end
