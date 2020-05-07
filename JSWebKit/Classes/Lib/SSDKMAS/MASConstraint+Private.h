#import "EMAsyncConstraint.h"
@protocol MASConstraintDelegate;
@interface EMAsyncConstraint ()
@property (nonatomic, assign) BOOL updateExisting;
@property (nonatomic, weak) id<MASConstraintDelegate> delegate;
- (void)setLayoutConstantWithValue:(NSValue *)value;
@end
@interface EMAsyncConstraint (Abstract)
- (EMAsyncConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;
- (EMAsyncConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;
@end
@protocol MASConstraintDelegate <NSObject>
- (void)constraint:(EMAsyncConstraint *)constraint shouldBeReplacedWithConstraint:(EMAsyncConstraint *)replacementConstraint;
- (EMAsyncConstraint *)constraint:(EMAsyncConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;
@end
