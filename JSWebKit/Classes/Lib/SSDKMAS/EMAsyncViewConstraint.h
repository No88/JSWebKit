#import "EMAsyncViewAttribute.h"
#import "EMAsyncConstraint.h"
#import "EMAsyncLayoutConstraint.h"
#import "MASUtilities.h"
@interface EMAsyncViewConstraint : EMAsyncConstraint <NSCopying>
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *firstViewAttribute;
@property (nonatomic, strong, readonly) EMAsyncViewAttribute *secondViewAttribute;
- (id)initWithFirstViewAttribute:(EMAsyncViewAttribute *)firstViewAttribute;
+ (NSArray *)installedConstraintsForView:(MAS_VIEW *)view;
@end
