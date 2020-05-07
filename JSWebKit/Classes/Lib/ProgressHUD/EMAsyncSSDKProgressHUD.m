#import "EMAsyncSSDKProgressHUD.h"
#import <objc/runtime.h>
#import <CoreMotion/CoreMotion.h>
@interface EMAsyncSSDKProgressHUD ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;
@end
@implementation EMAsyncSSDKProgressHUD
+ (void)initialize
{
    [self setSuccessImage:[self loadBundleImage:@"EMAsync_ProgressHUD_success"]];
    [self setInfoImage:[self loadBundleImage:@"EMAsync_ProgressHUD_info"]];
    [self setErrorImage:[self loadBundleImage:@"EMAsync_ProgressHUD_error"]];
    [self setDefaultMaskType:EMAsync_ProgressHUDMaskTypeNone];
    [self setDefaultStyle:EMAsync_ProgressHUDStyleDark];
    [self setCornerRadius:8.0];
    [self setMinimumDismissTimeInterval:1.f];
}
+ (UIImage *)loadBundleImage:(NSString *)imageName {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imagefailName = [NSString stringWithFormat:@"%@@%zdx.png",imageName,scale];
    NSString *imagePath = [currentBundle pathForResource:imagefailName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",@"EMAsyncKit"]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
- (NSTimeInterval)displayDurationForString:(NSString*)string
{
    return 1.5;
}
- (void)updateBlurBounds{
}
- (UIColor*)backgroundColorForStyle{
    return [UIColor colorWithWhite:0 alpha:0.9];
}
#pragma mark - 屏幕方向旋转
- (void)orientationChange
{
    __weak typeof(self) weakSelf = self;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        __block UIInterfaceOrientation orientation;
        if (acceleration.x >= 0.75) {
            orientation = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientation = UIInterfaceOrientationLandscapeRight;
        }
        else if (acceleration.y <= -0.75) {
            orientation = UIInterfaceOrientationPortrait;
        }
        else if (acceleration.y >= 0.75) {
            orientation = UIInterfaceOrientationPortraitUpsideDown;
            return ;
        }
        else {
            return;
        }
        if (orientation != weakSelf.lastOrientation) {
            [weakSelf configHUDOrientation:orientation];
            weakSelf.lastOrientation = orientation;        }
    }];
}
- (void)configHUDOrientation:(UIInterfaceOrientation )orientation
{
    CGFloat angle = [self calculateTransformAngle:orientation];
    self.transform = CGAffineTransformRotate(self.transform, angle);
}
- (CGFloat)calculateTransformAngle:(UIInterfaceOrientation )orientation
{
    CGFloat angle = 0.0f;
    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
        switch (orientation) {
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeRight) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = M_PI;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeLeft) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI;
                break;
            default:
                break;
        }
    }
    return angle;
}
#pragma mark - Lazy Load
- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1./15.;
    }
    return _motionManager;
}
@end
