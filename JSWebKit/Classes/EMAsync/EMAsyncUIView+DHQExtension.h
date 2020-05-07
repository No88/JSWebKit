#import <UIKit/UIKit.h>
#define keypath(objc , keypath) @(((void)objc.keypath , #keypath))
@interface UIView (DHQExtension)
@property (assign , nonatomic) CGFloat width;
@property (assign , nonatomic) CGFloat height;
@property (assign , nonatomic) CGFloat x;
@property (assign , nonatomic) CGFloat y;
@property (assign , nonatomic) CGSize size;
@property (assign , nonatomic) CGFloat centerX;
@property (assign , nonatomic) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;
- (UIViewController *)getViewController;
@end
