#import "MASUtilities.h"
#import "EMAsyncConstraintMaker.h"
#import "EMAsyncViewAttribute.h"
typedef NS_ENUM(NSUInteger, MASAxisType) {
    MASAxisTypeHorizontal,
    MASAxisTypeVertical
};
@interface NSArray (MASAdditions)
- (NSArray *)mas_makeConstraints:(void (NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)mas_updateConstraints:(void (NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)mas_remakeConstraints:(void (NS_NOESCAPE ^)(EMAsyncConstraintMaker *make))block;
- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;
- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;
@end
