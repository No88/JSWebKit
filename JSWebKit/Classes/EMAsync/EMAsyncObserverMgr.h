#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface EMAsyncObserverMgr : NSObject
typedef void(^ObserverHandler)(NSDictionary<NSKeyValueChangeKey,id> *change);
+ (instancetype)mgr;
- (void)addObj:(NSObject *)obj keyPath:(NSString *)keyPath block:(ObserverHandler)handler;
- (void)rmObj:(NSObject *)obj keyPath:(NSString *)keyPath;
- (void)rmObj:(NSObject *)obj;
- (void)rmAllObj;
#pragma mark - 不让外部调用的方法
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
