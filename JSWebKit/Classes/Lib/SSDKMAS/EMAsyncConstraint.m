#import "EMAsyncConstraint.h"
#import "MASConstraint+Private.h"
#define MASMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]
@implementation EMAsyncConstraint
#pragma mark - Init
- (id)init {
	NSAssert(![self isMemberOfClass:[EMAsyncConstraint class]], @"EMAsyncConstraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}
#pragma mark - NSLayoutRelation proxies
- (EMAsyncConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}
- (EMAsyncConstraint * (^)(id))mas_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}
- (EMAsyncConstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}
- (EMAsyncConstraint * (^)(id))mas_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}
- (EMAsyncConstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}
- (EMAsyncConstraint * (^)(id))mas_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}
#pragma mark - EMAsync_LayoutPriority proxies
- (EMAsyncConstraint * (^)(void))priorityLow {
    return ^id{
        self.priority(EMAsync_LayoutPriorityDefaultLow);
        return self;
    };
}
- (EMAsyncConstraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(EMAsync_LayoutPriorityDefaultMedium);
        return self;
    };
}
- (EMAsyncConstraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(EMAsync_LayoutPriorityDefaultHigh);
        return self;
    };
}
#pragma mark - NSLayoutConstraint constant proxies
- (EMAsyncConstraint * (^)(MASEdgeInsets))insets {
    return ^id(MASEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}
- (EMAsyncConstraint * (^)(CGFloat))inset {
    return ^id(CGFloat inset){
        self.inset = inset;
        return self;
    };
}
- (EMAsyncConstraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}
- (EMAsyncConstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}
- (EMAsyncConstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}
- (EMAsyncConstraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}
- (EMAsyncConstraint * (^)(id offset))mas_offset {
    return nil;
}
#pragma mark - NSLayoutConstraint constant setter
- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(MASEdgeInsets)) == 0) {
        MASEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}
#pragma mark - Semantic properties
- (EMAsyncConstraint *)with {
    return self;
}
- (EMAsyncConstraint *)and {
    return self;
}
#pragma mark - Chaining
- (EMAsyncConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    MASMethodNotImplemented();
}
- (EMAsyncConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}
- (EMAsyncConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}
- (EMAsyncConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}
- (EMAsyncConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}
- (EMAsyncConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}
- (EMAsyncConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}
- (EMAsyncConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}
- (EMAsyncConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}
- (EMAsyncConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}
- (EMAsyncConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}
- (EMAsyncConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}
- (EMAsyncConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (EMAsyncConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}
#if TARGET_OS_IPHONE || TARGET_OS_TV
- (EMAsyncConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}
- (EMAsyncConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}
- (EMAsyncConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}
- (EMAsyncConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}
- (EMAsyncConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}
- (EMAsyncConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}
- (EMAsyncConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}
- (EMAsyncConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}
#endif
#pragma mark - Abstract
- (EMAsyncConstraint * (^)(CGFloat multiplier))multipliedBy { MASMethodNotImplemented(); }
- (EMAsyncConstraint * (^)(CGFloat divider))dividedBy { MASMethodNotImplemented(); }
- (EMAsyncConstraint * (^)(EMAsync_LayoutPriority priority))priority { MASMethodNotImplemented(); }
- (EMAsyncConstraint * (^)(id, NSLayoutRelation))equalToWithRelation { MASMethodNotImplemented(); }
- (EMAsyncConstraint * (^)(id key))key { MASMethodNotImplemented(); }
- (void)setInsets:(MASEdgeInsets __unused)insets { MASMethodNotImplemented(); }
- (void)setInset:(CGFloat __unused)inset { MASMethodNotImplemented(); }
- (void)setSizeOffset:(CGSize __unused)sizeOffset { MASMethodNotImplemented(); }
- (void)setCenterOffset:(CGPoint __unused)centerOffset { MASMethodNotImplemented(); }
- (void)setOffset:(CGFloat __unused)offset { MASMethodNotImplemented(); }
#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
- (EMAsyncConstraint *)animator { MASMethodNotImplemented(); }
#endif
- (void)activate { MASMethodNotImplemented(); }
- (void)deactivate { MASMethodNotImplemented(); }
- (void)install { MASMethodNotImplemented(); }
- (void)uninstall { MASMethodNotImplemented(); }
@end
