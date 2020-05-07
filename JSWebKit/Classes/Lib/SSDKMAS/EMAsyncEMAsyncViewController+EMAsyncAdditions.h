#import "MASUtilities.h"
#import "EMAsyncConstraintMaker.h"
#import "EMAsyncViewAttribute.h"
#ifdef MAS_VIEW_CONTROLLER
@interface MAS_VIEW_CONTROLLER (MASAdditions)
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_topLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_bottomLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_topLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_topLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_bottomLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *mas_bottomLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);
@end
#endif
