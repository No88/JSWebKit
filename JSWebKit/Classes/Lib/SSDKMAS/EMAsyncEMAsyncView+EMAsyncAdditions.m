#import "EMAsyncEMAsyncView+EMAsyncAdditions.h"
#import <objc/runtime.h>
@implementation MAS_VIEW (MASAdditions)
- (NSArray *)mas_makeConstraints:(void(^)(EMAsyncConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    EMAsyncConstraintMaker *constraintMaker = [[EMAsyncConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}
- (NSArray *)mas_updateConstraints:(void(^)(EMAsyncConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    EMAsyncConstraintMaker *constraintMaker = [[EMAsyncConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}
- (NSArray *)mas_remakeConstraints:(void(^)(EMAsyncConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    EMAsyncConstraintMaker *constraintMaker = [[EMAsyncConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}
#pragma mark - NSLayoutAttribute properties
- (EMAsyncViewAttribute *)mas_left {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}
- (EMAsyncViewAttribute *)mas_top {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncViewAttribute *)mas_right {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}
- (EMAsyncViewAttribute *)mas_bottom {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}
- (EMAsyncViewAttribute *)mas_leading {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}
- (EMAsyncViewAttribute *)mas_trailing {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}
- (EMAsyncViewAttribute *)mas_width {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}
- (EMAsyncViewAttribute *)mas_height {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}
- (EMAsyncViewAttribute *)mas_centerX {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}
- (EMAsyncViewAttribute *)mas_centerY {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}
- (EMAsyncViewAttribute *)mas_baseline {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}
- (EMAsyncViewAttribute *(^)(NSLayoutAttribute))mas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}
- (EMAsyncViewAttribute *)mas_firstBaseline {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (EMAsyncViewAttribute *)mas_lastBaseline {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}
#if TARGET_OS_IPHONE || TARGET_OS_TV
- (EMAsyncViewAttribute *)mas_leftMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}
- (EMAsyncViewAttribute *)mas_rightMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}
- (EMAsyncViewAttribute *)mas_topMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}
- (EMAsyncViewAttribute *)mas_bottomMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}
- (EMAsyncViewAttribute *)mas_leadingMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}
- (EMAsyncViewAttribute *)mas_trailingMargin {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}
- (EMAsyncViewAttribute *)mas_centerXWithinMargins {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}
- (EMAsyncViewAttribute *)mas_centerYWithinMargins {
    return [[EMAsyncViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuide {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeNotAnAttribute];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideLeading {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeading];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideTrailing {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTrailing];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideLeft {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideRight {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideTop {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideBottom {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideWidth {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeWidth];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideHeight {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeHeight];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideCenterX {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterX];
}
- (EMAsyncViewAttribute *)mas_safeAreaLayoutGuideCenterY {
    return [[EMAsyncViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterY];
}
#endif
#pragma mark - associated properties
- (id)mas_key {
    return objc_getAssociatedObject(self, @selector(mas_key));
}
- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(mas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - heirachy
- (instancetype)mas_closestCommonSuperview:(MAS_VIEW *)view {
    MAS_VIEW *closestCommonSuperview = nil;
    MAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        MAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}
@end
