#import "MASUtilities.h"
@interface EMAsyncConstraint : NSObject
- (EMAsyncConstraint * (^)(MASEdgeInsets insets))insets;
- (EMAsyncConstraint * (^)(CGFloat inset))inset;
- (EMAsyncConstraint * (^)(CGSize offset))sizeOffset;
- (EMAsyncConstraint * (^)(CGPoint offset))centerOffset;
- (EMAsyncConstraint * (^)(CGFloat offset))offset;
- (EMAsyncConstraint * (^)(NSValue *value))valueOffset;
- (EMAsyncConstraint * (^)(CGFloat multiplier))multipliedBy;
- (EMAsyncConstraint * (^)(CGFloat divider))dividedBy;
- (EMAsyncConstraint * (^)(EMAsync_LayoutPriority priority))priority;
- (EMAsyncConstraint * (^)(void))priorityLow;
- (EMAsyncConstraint * (^)(void))priorityMedium;
- (EMAsyncConstraint * (^)(void))priorityHigh;
- (EMAsyncConstraint * (^)(id attr))equalTo;
- (EMAsyncConstraint * (^)(id attr))greaterThanOrEqualTo;
- (EMAsyncConstraint * (^)(id attr))lessThanOrEqualTo;
- (EMAsyncConstraint *)with;
- (EMAsyncConstraint *)and;
- (EMAsyncConstraint *)left;
- (EMAsyncConstraint *)top;
- (EMAsyncConstraint *)right;
- (EMAsyncConstraint *)bottom;
- (EMAsyncConstraint *)leading;
- (EMAsyncConstraint *)trailing;
- (EMAsyncConstraint *)width;
- (EMAsyncConstraint *)height;
- (EMAsyncConstraint *)centerX;
- (EMAsyncConstraint *)centerY;
- (EMAsyncConstraint *)baseline;
- (EMAsyncConstraint *)firstBaseline;
- (EMAsyncConstraint *)lastBaseline;
#if TARGET_OS_IPHONE || TARGET_OS_TV
- (EMAsyncConstraint *)leftMargin;
- (EMAsyncConstraint *)rightMargin;
- (EMAsyncConstraint *)topMargin;
- (EMAsyncConstraint *)bottomMargin;
- (EMAsyncConstraint *)leadingMargin;
- (EMAsyncConstraint *)trailingMargin;
- (EMAsyncConstraint *)centerXWithinMargins;
- (EMAsyncConstraint *)centerYWithinMargins;
#endif
- (EMAsyncConstraint * (^)(id key))key;
- (void)setInsets:(MASEdgeInsets)insets;
- (void)setInset:(CGFloat)inset;
- (void)setSizeOffset:(CGSize)sizeOffset;
- (void)setCenterOffset:(CGPoint)centerOffset;
- (void)setOffset:(CGFloat)offset;
#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
@property (nonatomic, copy, readonly) EMAsyncConstraint *animator;
#endif
- (void)activate;
- (void)deactivate;
- (void)install;
- (void)uninstall;
@end
#define mas_equalTo(...)                 equalTo(MASBoxValue((__VA_ARGS__)))
#define mas_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(MASBoxValue((__VA_ARGS__)))
#define mas_lessThanOrEqualTo(...)       lessThanOrEqualTo(MASBoxValue((__VA_ARGS__)))
#define mas_offset(...)                  valueOffset(MASBoxValue((__VA_ARGS__)))
#ifdef MAS_SHORTHAND_GLOBALS
#define equalTo(...)                     mas_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        mas_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           mas_lessThanOrEqualTo(__VA_ARGS__)
#define offset(...)                      mas_offset(__VA_ARGS__)
#endif
@interface EMAsyncConstraint (AutoboxingSupport)
- (EMAsyncConstraint * (^)(id attr))mas_equalTo;
- (EMAsyncConstraint * (^)(id attr))mas_greaterThanOrEqualTo;
- (EMAsyncConstraint * (^)(id attr))mas_lessThanOrEqualTo;
- (EMAsyncConstraint * (^)(id offset))mas_offset;
@end
