#import "EMAsyncConstraint.h"
#import "MASUtilities.h"
typedef NS_OPTIONS(NSInteger, MASAttribute) {
    MASAttributeLeft = 1 << NSLayoutAttributeLeft,
    MASAttributeRight = 1 << NSLayoutAttributeRight,
    MASAttributeTop = 1 << NSLayoutAttributeTop,
    MASAttributeBottom = 1 << NSLayoutAttributeBottom,
    MASAttributeLeading = 1 << NSLayoutAttributeLeading,
    MASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    MASAttributeWidth = 1 << NSLayoutAttributeWidth,
    MASAttributeHeight = 1 << NSLayoutAttributeHeight,
    MASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    MASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    MASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    MASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    MASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
#if TARGET_OS_IPHONE || TARGET_OS_TV
    MASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    MASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    MASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    MASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    MASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    MASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    MASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    MASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,
#endif
};
@interface EMAsyncConstraintMaker : NSObject
@property (nonatomic, strong, readonly) EMAsyncConstraint *left;
@property (nonatomic, strong, readonly) EMAsyncConstraint *top;
@property (nonatomic, strong, readonly) EMAsyncConstraint *right;
@property (nonatomic, strong, readonly) EMAsyncConstraint *bottom;
@property (nonatomic, strong, readonly) EMAsyncConstraint *leading;
@property (nonatomic, strong, readonly) EMAsyncConstraint *trailing;
@property (nonatomic, strong, readonly) EMAsyncConstraint *width;
@property (nonatomic, strong, readonly) EMAsyncConstraint *height;
@property (nonatomic, strong, readonly) EMAsyncConstraint *centerX;
@property (nonatomic, strong, readonly) EMAsyncConstraint *centerY;
@property (nonatomic, strong, readonly) EMAsyncConstraint *baseline;
@property (nonatomic, strong, readonly) EMAsyncConstraint *firstBaseline;
@property (nonatomic, strong, readonly) EMAsyncConstraint *lastBaseline;
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic, strong, readonly) EMAsyncConstraint *leftMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *rightMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *topMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *bottomMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *leadingMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *trailingMargin;
@property (nonatomic, strong, readonly) EMAsyncConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) EMAsyncConstraint *centerYWithinMargins;
#endif
@property (nonatomic, strong, readonly) EMAsyncConstraint *(^attributes)(MASAttribute attrs);
@property (nonatomic, strong, readonly) EMAsyncConstraint *edges;
@property (nonatomic, strong, readonly) EMAsyncConstraint *size;
@property (nonatomic, strong, readonly) EMAsyncConstraint *center;
@property (nonatomic, assign) BOOL updateExisting;
@property (nonatomic, assign) BOOL removeExisting;
- (id)initWithView:(MAS_VIEW *)view;
- (NSArray *)install;
- (EMAsyncConstraint * (^)(dispatch_block_t))group;
@end
