#import "EMAsyncEMAsyncViewController+EMAsyncAdditions.h"
#ifdef MAS_VIEW_CONTROLLER
@implementation MAS_VIEW_CONTROLLER (MASAdditions)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (EMAsyncViewAttribute *)mas_topLayoutGuide {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (EMAsyncViewAttribute *)mas_topLayoutGuideTop {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncViewAttribute *)mas_topLayoutGuideBottom {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (EMAsyncViewAttribute *)mas_bottomLayoutGuide {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncViewAttribute *)mas_bottomLayoutGuideTop {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncViewAttribute *)mas_bottomLayoutGuideBottom {
    return [[EMAsyncViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
#pragma clang diagnostic pop
@end
#endif
