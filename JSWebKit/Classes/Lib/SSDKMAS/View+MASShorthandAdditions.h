#import "EMAsyncEMAsyncView+EMAsyncAdditions.h"
#ifdef MAS_SHORTHAND
@interface MAS_VIEW (MASShorthandAdditions)
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *left;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *top;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *right;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *bottom;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *leading;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *trailing;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *width;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *height;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *centerX;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *centerY;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *baseline;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *(^attribute)(NSLayoutAttribute attr);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *lastBaseline;
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *topMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *centerYWithinMargins;
#endif
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *safeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);
#endif
- (NSArray *)makeConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
@end
#define MAS_ATTR_FORWARD(attr)  \
- (EMAsyncViewAttribute *)attr {    \
    return [self mas_##attr];   \
}
#define MAS_ATTR_FORWARD_AVAILABLE(attr, available)  \
- (EMAsyncViewAttribute *)attr available {    \
    return [self mas_##attr];   \
}
@implementation MAS_VIEW (MASShorthandAdditions)
MAS_ATTR_FORWARD(top);
MAS_ATTR_FORWARD(left);
MAS_ATTR_FORWARD(bottom);
MAS_ATTR_FORWARD(right);
MAS_ATTR_FORWARD(leading);
MAS_ATTR_FORWARD(trailing);
MAS_ATTR_FORWARD(width);
MAS_ATTR_FORWARD(height);
MAS_ATTR_FORWARD(centerX);
MAS_ATTR_FORWARD(centerY);
MAS_ATTR_FORWARD(baseline);
MAS_ATTR_FORWARD(firstBaseline);
MAS_ATTR_FORWARD(lastBaseline);
#if TARGET_OS_IPHONE || TARGET_OS_TV
MAS_ATTR_FORWARD(leftMargin);
MAS_ATTR_FORWARD(rightMargin);
MAS_ATTR_FORWARD(topMargin);
MAS_ATTR_FORWARD(bottomMargin);
MAS_ATTR_FORWARD(leadingMargin);
MAS_ATTR_FORWARD(trailingMargin);
MAS_ATTR_FORWARD(centerXWithinMargins);
MAS_ATTR_FORWARD(centerYWithinMargins);
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideLeading, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideTrailing, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideLeft, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideRight, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideTop, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideBottom, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideWidth, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideHeight, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideCenterX, NS_AVAILABLE_IOS(11.0));
MAS_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideCenterY, NS_AVAILABLE_IOS(11.0));
#endif
- (EMAsyncViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self mas_attribute];
}
- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *))block {
    return [self mas_makeConstraints:block];
}
- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *))block {
    return [self mas_updateConstraints:block];
}
- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *))block {
    return [self mas_remakeConstraints:block];
}
@end
#endif
