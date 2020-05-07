#import "EMAsyncObserverMgr.h"
@interface WDSubscriber : NSObject
@property (strong, nonatomic) NSMutableDictionary<NSString *, ObserverHandler> *handlers;
@end
@implementation WDSubscriber
@end
@interface EMAsyncObserverMgr()
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, WDSubscriber *> *subscribers;
@end
@implementation EMAsyncObserverMgr
- (void)addObj:(NSObject *)obj keyPath:(NSString *)keyPath block:(ObserverHandler)handler {
    [obj addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    NSNumber *key = @(obj.hash);
    WDSubscriber *sub = [self fetchSubscriber:key];
    [sub.handlers setValue:handler forKey:keyPath];
    [self.subscribers setObject:sub forKey:@(obj.hash)];
}
- (void)rmObj:(NSObject *)obj keyPath:(NSString *)keyPath {
    NSNumber *key = @(obj.hash);
    if (![self.subscribers.allKeys containsObject:key]) return;
    WDSubscriber *sub = self.subscribers[key];
    if (![sub.handlers.allKeys containsObject:keyPath]) return;
    [sub.handlers removeObjectForKey:keyPath];
    [obj removeObserver:self forKeyPath:keyPath];
}
- (void)rmObj:(NSObject *)obj {
    NSNumber *key = @(obj.hash);
    if (![self.subscribers.allKeys containsObject:key]) return;
    WDSubscriber *sub = self.subscribers[key];
    for (NSString *keyPath in sub.handlers) {
        [obj removeObserver:self forKeyPath:keyPath];
        [sub.handlers removeObjectForKey:keyPath];
    }
}
- (void)rmAllObj {
    for (NSNumber *hashKey in self.subscribers.allKeys) {
        [self rmObj:self.subscribers[hashKey]];
    }
}
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSObject *obj = (NSObject *)object;
    NSNumber *key = @(obj.hash);
    if (![self.subscribers.allKeys containsObject:key]) return;
    WDSubscriber *sub = self.subscribers[key];
    if (![sub.handlers.allKeys containsObject:keyPath]) return;
    ObserverHandler handler = sub.handlers[keyPath];
    handler(change);
}
#pragma mark - 
- (WDSubscriber *)fetchSubscriber:(NSNumber *)key {
    WDSubscriber *sub;
    if ([self.subscribers.allKeys containsObject:key]) {
        sub = self.subscribers[key];
    } else {
        sub = [WDSubscriber new];
        sub.handlers = [NSMutableDictionary new];
    }
    return sub;
}
+ (instancetype)mgr {
    static EMAsyncObserverMgr *_ton = nil;
    static dispatch_once_t wd_ObserverMgr;
    dispatch_once(&wd_ObserverMgr, ^{
        _ton = [[self alloc] init];
    });
    return _ton;
}
- (NSMutableDictionary *)subscribers {
    if (!_subscribers) {
        _subscribers = [NSMutableDictionary dictionary];
    }
    return _subscribers;
}
@end
