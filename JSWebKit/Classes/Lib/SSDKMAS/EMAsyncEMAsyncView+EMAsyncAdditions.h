#import "MASUtilities.h"
#import "EMAsyncConstraintMaker.h"
#import "EMAsyncViewAttribute.h"
@interface MAS_VIEW (MASAdditions)
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_left;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_top;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_right;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_bottom;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_leading;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_trailing;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_width;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_height;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_centerX;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_centerY;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_baseline;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *(^mas_attribute)(NSLayoutAttribute attr);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_firstBaseline;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_lastBaseline;
#if TARGET_OS_IPHONE || TARGET_OS_TV
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_leftMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_rightMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_topMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_bottomMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_leadingMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_trailingMargin;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_centerXWithinMargins;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_centerYWithinMargins;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuide NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_safeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);
#endif
@property (nonatomic, strong) id mas_key;
- (instancetype)mas_closestCommonSuperview:(MAS_VIEW *)view;
- (NSArray *)mas_makeConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)mas_updateConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)mas_remakeConstraints:(void(NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
@end
