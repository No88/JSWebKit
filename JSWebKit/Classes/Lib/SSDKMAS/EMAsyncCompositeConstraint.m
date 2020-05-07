#import "EMAsyncCompositeConstraint.h"
#import "MASConstraint+Private.h"
@interface EMAsyncCompositeConstraint () <MASConstraintDelegate>
@property (nonatomic, strong) id mas_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;
@end
@implementation EMAsyncCompositeConstraint
- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;
    _childConstraints = [children mutableCopy];
    for (EMAsyncConstraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }
    return self;
}
#pragma mark - MASConstraintDelegate
- (void)constraint:(EMAsyncConstraint *)constraint shouldBeReplacedWithConstraint:(EMAsyncConstraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}
- (EMAsyncConstraint *)constraint:(EMAsyncConstraint __unused *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<MASConstraintDelegate> strongDelegate = self.delegate;
    EMAsyncConstraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}
#pragma mark - NSLayoutConstraint multiplier proxies 
- (EMAsyncConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (EMAsyncConstraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}
- (EMAsyncConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (EMAsyncConstraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}
#pragma mark - EMAsync_LayoutPriority proxy
- (EMAsyncConstraint * (^)(EMAsync_LayoutPriority))priority {
    return ^id(EMAsync_LayoutPriority priority) {
        for (EMAsyncConstraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}
#pragma mark - NSLayoutRelation proxy
- (EMAsyncConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (EMAsyncConstraint *constraint in self.childConstraints.copy) {
            constraint.equalToWithRelation(attr, relation);
        }
        return self;
    };
}
#pragma mark - attribute chaining
- (EMAsyncConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}
#pragma mark - Animator proxy
#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
- (EMAsyncConstraint *)animator {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        [constraint animator];
    }
    return self;
}
#endif
#pragma mark - debug helpers
- (EMAsyncConstraint * (^)(id))key {
    return ^id(id key) {
        self.mas_key = key;
        int i = 0;
        for (EMAsyncConstraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}
#pragma mark - NSLayoutConstraint constant setters
- (void)setInsets:(MASEdgeInsets)insets {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}
- (void)setInset:(CGFloat)inset {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.inset = inset;
    }
}
- (void)setOffset:(CGFloat)offset {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}
- (void)setSizeOffset:(CGSize)sizeOffset {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}
- (void)setCenterOffset:(CGPoint)centerOffset {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}
#pragma mark - EMAsyncConstraint
- (void)activate {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        [constraint activate];
    }
}
- (void)deactivate {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        [constraint deactivate];
    }
}
- (void)install {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
}
- (void)uninstall {
    for (EMAsyncConstraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}
@end
