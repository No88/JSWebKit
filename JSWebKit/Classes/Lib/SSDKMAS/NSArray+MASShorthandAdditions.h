#import "EMAsyncEMAsyncNSArray+EMAsyncAdditions.h"
#ifdef MAS_SHORTHAND
@interface NSArray (MASShorthandAdditions)
- (NSArray *)makeConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(EMAsyncConstraintMaker *make))block;
@end
@implementation NSArray (MASShorthandAdditions)
- (NSArray *)makeConstraints:(void(^)(EMAsyncConstraintMaker *))block {
    return [self mas_makeConstraints:block];
}
- (NSArray *)updateConstraints:(void(^)(EMAsyncConstraintMaker *))block {
    return [self mas_updateConstraints:block];
}
- (NSArray *)remakeConstraints:(void(^)(EMAsyncConstraintMaker *))block {
    return [self mas_remakeConstraints:block];
}
@end
#endif
