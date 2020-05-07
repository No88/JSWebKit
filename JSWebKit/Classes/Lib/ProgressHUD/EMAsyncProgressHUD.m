#if !__has_feature(objc_arc)
#error EMAsyncProgressHUD is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif
#import "EMAsyncProgressHUD.h"
#import "EMAsyncIndefiniteAnimatedView.h"
#import "EMAsyncProgressAnimatedView.h"
#import "EMAsyncRadialGradientLayer.h"
NSString * const EMAsync_ProgressHUDDidReceiveTouchEventNotification = @"EMAsync_ProgressHUDDidReceiveTouchEventNotification";
NSString * const EMAsync_ProgressHUDDidTouchDownInsideNotification = @"EMAsync_ProgressHUDDidTouchDownInsideNotification";
NSString * const EMAsync_ProgressHUDWillDisappearNotification = @"EMAsync_ProgressHUDWillDisappearNotification";
NSString * const EMAsync_ProgressHUDDidDisappearNotification = @"EMAsync_ProgressHUDDidDisappearNotification";
NSString * const EMAsync_ProgressHUDWillAppearNotification = @"EMAsync_ProgressHUDWillAppearNotification";
NSString * const EMAsync_ProgressHUDDidAppearNotification = @"EMAsync_ProgressHUDDidAppearNotification";
NSString * const EMAsync_ProgressHUDStatusUserInfoKey = @"EMAsync_ProgressHUDStatusUserInfoKey";
static const CGFloat EMAsync_ProgressHUDParallaxDepthPoints = 10.0f;
static const CGFloat EMAsync_ProgressHUDUndefinedProgress = -1;
static const CGFloat EMAsync_ProgressHUDDefaultAnimationDuration = 0.15f;
static const CGFloat EMAsync_ProgressHUDVerticalSpacing = 12.0f;
static const CGFloat EMAsync_ProgressHUDHorizontalSpacing = 12.0f;
static const CGFloat EMAsync_ProgressHUDLabelSpacing = 8.0f;
@interface EMAsyncProgressHUD ()
@property (nonatomic, strong) NSTimer *graceTimer;
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, strong) UIControl *controlView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) EMAsyncRadialGradientLayer *backgroundRadialGradientLayer;
@property (nonatomic, strong) UIVisualEffectView *hudView;
@property (nonatomic, strong) UIBlurEffect *hudViewCustomBlurEffect;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *indefiniteAnimatedView;
@property (nonatomic, strong) EMAsyncProgressAnimatedView *ringView;
@property (nonatomic, strong) EMAsyncProgressAnimatedView *backgroundRingView;
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) NSUInteger activityCount;
@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;
@property (nonatomic, readonly) UIWindow *frontWindow;
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@property (nonatomic, strong) UINotificationFeedbackGenerator *hapticGenerator NS_AVAILABLE_IOS(10_0);
#endif
@end
@implementation EMAsyncProgressHUD {
    BOOL _isInitializing;
}
+ (EMAsyncProgressHUD*)sharedView {
    static dispatch_once_t once;
    static EMAsyncProgressHUD *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
#else
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
#endif
    return sharedView;
}
#pragma mark - Setters
+ (void)setStatus:(NSString*)status {
    [[self sharedView] setStatus:status];
}
+ (void)setDefaultStyle:(EMAsync_ProgressHUDStyle)style {
    [self sharedView].defaultStyle = style;
}
+ (void)setDefaultMaskType:(EMAsync_ProgressHUDMaskType)maskType {
    [self sharedView].defaultMaskType = maskType;
}
+ (void)setDefaultAnimationType:(EMAsync_ProgressHUDAnimationType)type {
    [self sharedView].defaultAnimationType = type;
}
+ (void)setContainerView:(nullable UIView*)containerView {
    [self sharedView].containerView = containerView;
}
+ (void)setMinimumSize:(CGSize)minimumSize {
    [self sharedView].minimumSize = minimumSize;
}
+ (void)setRingThickness:(CGFloat)ringThickness {
    [self sharedView].ringThickness = ringThickness;
}
+ (void)setRingRadius:(CGFloat)radius {
    [self sharedView].ringRadius = radius;
}
+ (void)setRingNoTextRadius:(CGFloat)radius {
    [self sharedView].ringNoTextRadius = radius;
}
+ (void)setCornerRadius:(CGFloat)cornerRadius {
    [self sharedView].cornerRadius = cornerRadius;
}
+ (void)setBorderColor:(nonnull UIColor*)color {
    [self sharedView].hudView.layer.borderColor = color.CGColor;
}
+ (void)setBorderWidth:(CGFloat)width {
    [self sharedView].hudView.layer.borderWidth = width;
}
+ (void)setFont:(UIFont*)font {
    [self sharedView].font = font;
}
+ (void)setForegroundColor:(UIColor*)color {
    [self sharedView].foregroundColor = color;
    [self setDefaultStyle:EMAsync_ProgressHUDStyleCustom];
}
+ (void)setForegroundImageColor:(UIColor *)color {
    [self sharedView].foregroundImageColor = color;
    [self setDefaultStyle:EMAsync_ProgressHUDStyleCustom];
}
+ (void)setBackgroundColor:(UIColor*)color {
    [self sharedView].backgroundColor = color;
    [self setDefaultStyle:EMAsync_ProgressHUDStyleCustom];
}
+ (void)setHudViewCustomBlurEffect:(UIBlurEffect*)blurEffect {
    [self sharedView].hudViewCustomBlurEffect = blurEffect;
    [self setDefaultStyle:EMAsync_ProgressHUDStyleCustom];
}
+ (void)setBackgroundLayerColor:(UIColor*)color {
    [self sharedView].backgroundLayerColor = color;
}
+ (void)setImageViewSize:(CGSize)size {
    [self sharedView].imageViewSize = size;
}
+ (void)setShouldTintImages:(BOOL)shouldTintImages {
    [self sharedView].shouldTintImages = shouldTintImages;
}
+ (void)setInfoImage:(UIImage*)image {
    [self sharedView].infoImage = image;
}
+ (void)setSuccessImage:(UIImage*)image {
    [self sharedView].successImage = image;
}
+ (void)setErrorImage:(UIImage*)image {
    [self sharedView].errorImage = image;
}
+ (void)setViewForExtension:(UIView*)view {
    [self sharedView].viewForExtension = view;
}
+ (void)setGraceTimeInterval:(NSTimeInterval)interval {
    [self sharedView].graceTimeInterval = interval;
}
+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval {
    [self sharedView].minimumDismissTimeInterval = interval;
}
+ (void)setMaximumDismissTimeInterval:(NSTimeInterval)interval {
    [self sharedView].maximumDismissTimeInterval = interval;
}
+ (void)setFadeInAnimationDuration:(NSTimeInterval)duration {
    [self sharedView].fadeInAnimationDuration = duration;
}
+ (void)setFadeOutAnimationDuration:(NSTimeInterval)duration {
    [self sharedView].fadeOutAnimationDuration = duration;
}
+ (void)setMaxSupportedWindowLevel:(UIWindowLevel)windowLevel {
    [self sharedView].maxSupportedWindowLevel = windowLevel;
}
+ (void)setHapticsEnabled:(BOOL)hapticsEnabled {
    [self sharedView].hapticsEnabled = hapticsEnabled;
}
+ (void)setMotionEffectEnabled:(BOOL)motionEffectEnabled {
    [self sharedView].motionEffectEnabled = motionEffectEnabled;
}
#pragma mark - Show Methods
+ (void)show {
    [self showWithStatus:nil];
}
+ (void)showWithMaskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self show];
    [self setDefaultMaskType:existingMaskType];
}
+ (void)showWithStatus:(NSString*)status {
    [self showProgress:EMAsync_ProgressHUDUndefinedProgress status:status];
}
+ (void)showWithStatus:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showWithStatus:status];
    [self setDefaultMaskType:existingMaskType];
}
+ (void)showProgress:(float)progress {
    [self showProgress:progress status:nil];
}
+ (void)showProgress:(float)progress maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showProgress:progress];
    [self setDefaultMaskType:existingMaskType];
}
+ (void)showProgress:(float)progress status:(NSString*)status {
    [[self sharedView] showProgress:progress status:status];
}
+ (void)showProgress:(float)progress status:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showProgress:progress status:status];
    [self setDefaultMaskType:existingMaskType];
}
#pragma mark - Show, then automatically dismiss methods
+ (void)showInfoWithStatus:(NSString*)status {
    [self showImage:[self sharedView].infoImage status:status];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedView].hapticGenerator notificationOccurred:UINotificationFeedbackTypeWarning];
        });
    }
#endif
}
+ (void)showInfoWithStatus:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showInfoWithStatus:status];
    [self setDefaultMaskType:existingMaskType];
}
+ (void)showSuccessWithStatus:(NSString*)status {
    [self showImage:[self sharedView].successImage status:status];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedView].hapticGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
        });
    }
#endif
}
+ (void)showSuccessWithStatus:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showSuccessWithStatus:status];
    [self setDefaultMaskType:existingMaskType];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedView].hapticGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
        });
    }
#endif
}
+ (void)showErrorWithStatus:(NSString*)status {
    [self showImage:[self sharedView].errorImage status:status];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedView].hapticGenerator notificationOccurred:UINotificationFeedbackTypeError];
        });
    }
#endif
}
+ (void)showErrorWithStatus:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showErrorWithStatus:status];
    [self setDefaultMaskType:existingMaskType];
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedView].hapticGenerator notificationOccurred:UINotificationFeedbackTypeError];
        });
    }
#endif
}
+ (void)showImage:(UIImage*)image status:(NSString*)status {
    NSTimeInterval displayInterval = [self displayDurationForString:status];
    [[self sharedView] showImage:image status:status duration:displayInterval];
}
+ (void)showImage:(UIImage*)image status:(NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType {
    EMAsync_ProgressHUDMaskType existingMaskType = [self sharedView].defaultMaskType;
    [self setDefaultMaskType:maskType];
    [self showImage:image status:status];
    [self setDefaultMaskType:existingMaskType];
}
#pragma mark - Dismiss Methods
+ (void)popActivity {
    if([self sharedView].activityCount > 0) {
        [self sharedView].activityCount--;
    }
    if([self sharedView].activityCount == 0) {
        [[self sharedView] dismiss];
    }
}
+ (void)dismiss {
    [self dismissWithDelay:0.0 completion:nil];
}
+ (void)dismissWithCompletion:(EMAsync_ProgressHUDDismissCompletion)completion {
    [self dismissWithDelay:0.0 completion:completion];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [self dismissWithDelay:delay completion:nil];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(EMAsync_ProgressHUDDismissCompletion)completion {
    [[self sharedView] dismissWithDelay:delay completion:completion];
}
#pragma mark - Offset
+ (void)setOffsetFromCenter:(UIOffset)offset {
    [self sharedView].offsetFromCenter = offset;
}
+ (void)resetOffsetFromCenter {
    [self setOffsetFromCenter:UIOffsetZero];
}
#pragma mark - Instance Methods
- (UIImage *)loadBundleImage:(NSString *)imageName {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imagefailName = [NSString stringWithFormat:@"%@@%zdx.png",imageName,scale];
    NSString *imagePath = [currentBundle pathForResource:imagefailName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",@"EMAsyncKit"]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        _isInitializing = YES;
        self.userInteractionEnabled = NO;
        self.activityCount = 0;
        self.backgroundView.alpha = 0.0f;
        self.imageView.alpha = 0.0f;
        self.statusLabel.alpha = 0.0f;
        self.indefiniteAnimatedView.alpha = 0.0f;
        self.ringView.alpha = self.backgroundRingView.alpha = 0.0f;
        _backgroundColor = [UIColor whiteColor];
        _foregroundColor = [UIColor blackColor];
        _backgroundLayerColor = [UIColor colorWithWhite:0 alpha:0.4];
        _defaultMaskType = EMAsync_ProgressHUDMaskTypeNone;
        _defaultStyle = EMAsync_ProgressHUDStyleLight;
        _defaultAnimationType = EMAsync_ProgressHUDAnimationTypeFlat;
        _minimumSize = CGSizeZero;
        _font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _imageViewSize = CGSizeMake(28.0f, 28.0f);
        _shouldTintImages = YES;
        _infoImage = [self loadBundleImage:@"EMAsync_ProgressHUD_info"];
        _successImage = [self loadBundleImage:@"EMAsync_ProgressHUD_success"];
        _errorImage = [self loadBundleImage:@"EMAsync_ProgressHUD_error"];
        _ringThickness = 2.0f;
        _ringRadius = 18.0f;
        _ringNoTextRadius = 24.0f;
        _cornerRadius = 14.0f;
        _graceTimeInterval = 0.0f;
        _minimumDismissTimeInterval = 5.0;
        _maximumDismissTimeInterval = CGFLOAT_MAX;
        _fadeInAnimationDuration = EMAsync_ProgressHUDDefaultAnimationDuration;
        _fadeOutAnimationDuration = EMAsync_ProgressHUDDefaultAnimationDuration;
        _maxSupportedWindowLevel = UIWindowLevelNormal;
        _hapticsEnabled = NO;
        _motionEffectEnabled = YES;
        self.accessibilityIdentifier = @"EMAsyncProgressHUD";
        self.isAccessibilityElement = YES;
        _isInitializing = NO;
    }
    return self;
}
- (void)updateHUDFrame {
    BOOL imageUsed = (self.imageView.image) && !(self.imageView.hidden);
    BOOL progressUsed = self.imageView.hidden;
    CGRect labelRect = CGRectZero;
    CGFloat labelHeight = 0.0f;
    CGFloat labelWidth = 0.0f;
    if(self.statusLabel.text) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        labelRect = [self.statusLabel.text boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.statusLabel.font}
                                                        context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    }
    CGFloat hudWidth;
    CGFloat hudHeight;
    CGFloat contentWidth = 0.0f;
    CGFloat contentHeight = 0.0f;
    if(imageUsed || progressUsed) {
        contentWidth = CGRectGetWidth(imageUsed ? self.imageView.frame : self.indefiniteAnimatedView.frame);
        contentHeight = CGRectGetHeight(imageUsed ? self.imageView.frame : self.indefiniteAnimatedView.frame);
    }
    hudWidth = EMAsync_ProgressHUDHorizontalSpacing + MAX(labelWidth, contentWidth) + EMAsync_ProgressHUDHorizontalSpacing;
    hudHeight = EMAsync_ProgressHUDVerticalSpacing + labelHeight + contentHeight + EMAsync_ProgressHUDVerticalSpacing;
    if(self.statusLabel.text && (imageUsed || progressUsed)){
        hudHeight += EMAsync_ProgressHUDLabelSpacing;
    }
    self.hudView.bounds = CGRectMake(0.0f, 0.0f, MAX(self.minimumSize.width, hudWidth), MAX(self.minimumSize.height, hudHeight));
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat centerY;
    if(self.statusLabel.text) {
        CGFloat yOffset = MAX(EMAsync_ProgressHUDVerticalSpacing, (self.minimumSize.height - contentHeight - EMAsync_ProgressHUDLabelSpacing - labelHeight) / 2.0f);
        centerY = yOffset + contentHeight / 2.0f;
    } else {
        centerY = CGRectGetMidY(self.hudView.bounds);
    }
    self.indefiniteAnimatedView.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    if(self.progress != EMAsync_ProgressHUDUndefinedProgress) {
        self.backgroundRingView.center = self.ringView.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    }
    self.imageView.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    if(imageUsed || progressUsed) {
        centerY = CGRectGetMaxY(imageUsed ? self.imageView.frame : self.indefiniteAnimatedView.frame) + EMAsync_ProgressHUDLabelSpacing + labelHeight / 2.0f;
    } else {
        centerY = CGRectGetMidY(self.hudView.bounds);
    }
    self.statusLabel.frame = labelRect;
    self.statusLabel.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    [CATransaction commit];
}
#if TARGET_OS_IOS
- (void)updateMotionEffectForOrientation:(UIInterfaceOrientation)orientation {
    UIInterpolatingMotionEffectType xMotionEffectType = UIInterfaceOrientationIsPortrait(orientation) ? UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis : UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis;
    UIInterpolatingMotionEffectType yMotionEffectType = UIInterfaceOrientationIsPortrait(orientation) ? UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis : UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis;
    [self updateMotionEffectForXMotionEffectType:xMotionEffectType yMotionEffectType:yMotionEffectType];
}
#endif
- (void)updateMotionEffectForXMotionEffectType:(UIInterpolatingMotionEffectType)xMotionEffectType yMotionEffectType:(UIInterpolatingMotionEffectType)yMotionEffectType {
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:xMotionEffectType];
    effectX.minimumRelativeValue = @(-EMAsync_ProgressHUDParallaxDepthPoints);
    effectX.maximumRelativeValue = @(EMAsync_ProgressHUDParallaxDepthPoints);
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:yMotionEffectType];
    effectY.minimumRelativeValue = @(-EMAsync_ProgressHUDParallaxDepthPoints);
    effectY.maximumRelativeValue = @(EMAsync_ProgressHUDParallaxDepthPoints);
    UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
    effectGroup.motionEffects = @[effectX, effectY];
    self.hudView.motionEffects = @[];
    [self.hudView addMotionEffect:effectGroup];
}
- (void)updateViewHierarchy {
    if(!self.controlView.superview) {
        if(self.containerView){
            [self.containerView addSubview:self.controlView];
        } else {
#if !defined(SV_APP_EXTENSIONS)
            [self.frontWindow addSubview:self.controlView];
#else
            if(self.viewForExtension) {
                [self.viewForExtension addSubview:self.controlView];
            }
#endif
        }
    } else {
        [self.controlView.superview bringSubviewToFront:self.controlView];
    }
    if(!self.superview) {
        [self.controlView addSubview:self];
    }
}
- (void)setStatus:(NSString*)status {
    self.statusLabel.text = status;
    self.statusLabel.hidden = status.length == 0;
    [self updateHUDFrame];
}
- (void)setGraceTimer:(NSTimer*)timer {
    if(_graceTimer) {
        [_graceTimer invalidate];
        _graceTimer = nil;
    }
    if(timer) {
        _graceTimer = timer;
    }
}
- (void)setFadeOutTimer:(NSTimer*)timer {
    if(_fadeOutTimer) {
        [_fadeOutTimer invalidate];
        _fadeOutTimer = nil;
    }
    if(timer) {
        _fadeOutTimer = timer;
    }
}
#pragma mark - Notifications and their handling
- (void)registerNotifications {
#if TARGET_OS_IOS
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
- (NSDictionary*)notificationUserInfo {
    return (self.statusLabel.text ? @{EMAsync_ProgressHUDStatusUserInfoKey : self.statusLabel.text} : nil);
}
- (void)positionHUD:(NSNotification*)notification {
    CGFloat keyboardHeight = 0.0f;
    double animationDuration = 0.0;
#if !defined(SV_APP_EXTENSIONS) && TARGET_OS_IOS
    self.frame = [[[UIApplication sharedApplication] delegate] window].bounds;
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
#elif !defined(SV_APP_EXTENSIONS) && !TARGET_OS_IOS
    self.frame= [UIApplication sharedApplication].keyWindow.bounds;
#else
    if (self.viewForExtension) {
        self.frame = self.viewForExtension.frame;
    } else {
        self.frame = UIScreen.mainScreen.bounds;
    }
#if TARGET_OS_IOS
    UIInterfaceOrientation orientation = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
#endif
#endif
#if TARGET_OS_IOS
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            keyboardHeight = CGRectGetWidth(keyboardFrame);
            if(UIInterfaceOrientationIsPortrait(orientation)) {
                keyboardHeight = CGRectGetHeight(keyboardFrame);
            }
        }
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
#endif
    CGRect orientationFrame = self.bounds;
#if !defined(SV_APP_EXTENSIONS) && TARGET_OS_IOS
    CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
#else
    CGRect statusBarFrame = CGRectZero;
#endif
    if (_motionEffectEnabled) {
#if TARGET_OS_IOS
        [self updateMotionEffectForOrientation:orientation];
#else
        [self updateMotionEffectForXMotionEffectType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis yMotionEffectType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
#endif
    }
    CGFloat activeHeight = CGRectGetHeight(orientationFrame);
    if(keyboardHeight > 0) {
        activeHeight += CGRectGetHeight(statusBarFrame) * 2;
    }
    activeHeight -= keyboardHeight;
    CGFloat posX = CGRectGetMidX(orientationFrame);
    CGFloat posY = floorf(activeHeight*0.45f);
    CGFloat rotateAngle = 0.0;
    CGPoint newCenter = CGPointMake(posX, posY);
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                             [self.hudView setNeedsDisplay];
                         } completion:nil];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
}
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    if (self.containerView) {
        self.hudView.center = CGPointMake(self.containerView.center.x + self.offsetFromCenter.horizontal, self.containerView.center.y + self.offsetFromCenter.vertical);
    } else {
        self.hudView.center = CGPointMake(newCenter.x + self.offsetFromCenter.horizontal, newCenter.y + self.offsetFromCenter.vertical);
    }
}
#pragma mark - Event handling
- (void)controlViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent*)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDDidReceiveTouchEventNotification
                                                        object:self
                                                      userInfo:[self notificationUserInfo]];
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchLocation = [touch locationInView:self];
    if(CGRectContainsPoint(self.hudView.frame, touchLocation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDDidTouchDownInsideNotification
                                                            object:self
                                                          userInfo:[self notificationUserInfo]];
    }
}
#pragma mark - Master show/dismiss methods
- (void)showProgress:(float)progress status:(NSString*)status {
    __weak EMAsyncProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong EMAsyncProgressHUD *strongSelf = weakSelf;
        if(strongSelf){
            if(strongSelf.fadeOutTimer) {
                strongSelf.activityCount = 0;
            }
            strongSelf.fadeOutTimer = nil;
            strongSelf.graceTimer = nil;
            [strongSelf updateViewHierarchy];
            strongSelf.imageView.hidden = YES;
            strongSelf.imageView.image = nil;
            strongSelf.statusLabel.hidden = status.length == 0;
            strongSelf.statusLabel.text = status;
            strongSelf.progress = progress;
            if(progress >= 0) {
                [strongSelf cancelIndefiniteAnimatedViewAnimation];
                if(!strongSelf.ringView.superview){
                    [strongSelf.hudView.contentView addSubview:strongSelf.ringView];
                }
                if(!strongSelf.backgroundRingView.superview){
                    [strongSelf.hudView.contentView addSubview:strongSelf.backgroundRingView];
                }
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                strongSelf.ringView.strokeEnd = progress;
                [CATransaction commit];
                if(progress == 0) {
                    strongSelf.activityCount++;
                }
            } else {
                [strongSelf cancelRingLayerAnimation];
                [strongSelf.hudView.contentView addSubview:strongSelf.indefiniteAnimatedView];
                if([strongSelf.indefiniteAnimatedView respondsToSelector:@selector(startAnimating)]) {
                    [(id)strongSelf.indefiniteAnimatedView startAnimating];
                }
                strongSelf.activityCount++;
            }
            if (self.graceTimeInterval > 0.0 && self.backgroundView.alpha == 0.0f) {
                strongSelf.graceTimer = [NSTimer timerWithTimeInterval:self.graceTimeInterval target:strongSelf selector:@selector(fadeIn:) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:strongSelf.graceTimer forMode:NSRunLoopCommonModes];
            } else {
                [strongSelf fadeIn:nil];
            }
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
            if (@available(iOS 10.0, *)) {
                [strongSelf.hapticGenerator prepare];
            }
#endif
        }
    }];
}
- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration {
    __weak EMAsyncProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong EMAsyncProgressHUD *strongSelf = weakSelf;
        if(strongSelf){
            strongSelf.fadeOutTimer = nil;
            strongSelf.graceTimer = nil;
            [strongSelf updateViewHierarchy];
            strongSelf.progress = EMAsync_ProgressHUDUndefinedProgress;
            [strongSelf cancelRingLayerAnimation];
            [strongSelf cancelIndefiniteAnimatedViewAnimation];
            if (self.shouldTintImages) {
                if (image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                    strongSelf.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
                strongSelf.imageView.tintColor = strongSelf.foregroundImageColorForStyle;
            } else {
                strongSelf.imageView.image = image;
            }
            strongSelf.imageView.hidden = NO;
            strongSelf.statusLabel.hidden = status.length == 0;
            strongSelf.statusLabel.text = status;
            if (self.graceTimeInterval > 0.0 && self.backgroundView.alpha == 0.0f) {
                strongSelf.graceTimer = [NSTimer timerWithTimeInterval:self.graceTimeInterval target:strongSelf selector:@selector(fadeIn:) userInfo:@(duration) repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:strongSelf.graceTimer forMode:NSRunLoopCommonModes];
            } else {
                [strongSelf fadeIn:@(duration)];
            }
        }
    }];
}
- (void)fadeIn:(id)data {
    [self updateHUDFrame];
    [self positionHUD:nil];
    NSString *accessibilityString = [[self.statusLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    if(self.defaultMaskType != EMAsync_ProgressHUDMaskTypeNone) {
        self.controlView.userInteractionEnabled = YES;
        self.accessibilityLabel =  accessibilityString ?: NSLocalizedString(@"Loading", nil);
        self.isAccessibilityElement = YES;
        self.controlView.accessibilityViewIsModal = YES;
    } else {
        self.controlView.userInteractionEnabled = NO;
        self.hudView.accessibilityLabel = accessibilityString ?: NSLocalizedString(@"Loading", nil);
        self.hudView.isAccessibilityElement = YES;
        self.controlView.accessibilityViewIsModal = NO;
    }
    id duration = [data isKindOfClass:[NSTimer class]] ? ((NSTimer *)data).userInfo : data;
    if(self.backgroundView.alpha != 1.0f) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDWillAppearNotification
                                                            object:self
                                                          userInfo:[self notificationUserInfo]];
        self.hudView.transform = self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.5f, 1/1.5f);
        __block void (^animationsBlock)(void) = ^{
            self.hudView.transform = CGAffineTransformIdentity;
            [self fadeInEffects];
        };
        __block void (^completionBlock)(void) = ^{
            if(self.backgroundView.alpha == 1.0f){
                [self registerNotifications];
                [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDDidAppearNotification
                                                                    object:self
                                                                  userInfo:[self notificationUserInfo]];
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.statusLabel.text);
                if(duration){
                    self.fadeOutTimer = [NSTimer timerWithTimeInterval:[(NSNumber *)duration doubleValue] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
                    [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
                }
            }
        };
        if (self.fadeInAnimationDuration > 0) {
            [UIView animateWithDuration:self.fadeInAnimationDuration
                                  delay:0
                                options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                             animations:^{
                                 animationsBlock();
                             } completion:^(BOOL finished) {
                                 completionBlock();
                             }];
        } else {
            animationsBlock();
            completionBlock();
        }
        [self setNeedsDisplay];
    } else {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.statusLabel.text);
        if(duration){
            self.fadeOutTimer = [NSTimer timerWithTimeInterval:[(NSNumber *)duration doubleValue] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
        }
    }
}
- (void)dismiss {
    [self dismissWithDelay:0.0 completion:nil];
}
- (void)dismissWithDelay:(NSTimeInterval)delay completion:(EMAsync_ProgressHUDDismissCompletion)completion {
    __weak EMAsyncProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong EMAsyncProgressHUD *strongSelf = weakSelf;
        if(strongSelf){
            [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDWillDisappearNotification
                                                                object:nil
                                                              userInfo:[strongSelf notificationUserInfo]];
            strongSelf.activityCount = 0;
            __block void (^animationsBlock)(void) = ^{
                strongSelf.hudView.transform = CGAffineTransformScale(strongSelf.hudView.transform, 1/1.3f, 1/1.3f);
                [strongSelf fadeOutEffects];
            };
            __block void (^completionBlock)(void) = ^{
                if(self.backgroundView.alpha == 0.0f){
                    [strongSelf.controlView removeFromSuperview];
                    [strongSelf.backgroundView removeFromSuperview];
                    [strongSelf.hudView removeFromSuperview];
                    [strongSelf removeFromSuperview];
                    strongSelf.progress = EMAsync_ProgressHUDUndefinedProgress;
                    [strongSelf cancelRingLayerAnimation];
                    [strongSelf cancelIndefiniteAnimatedViewAnimation];
                    [[NSNotificationCenter defaultCenter] removeObserver:strongSelf];
                    [[NSNotificationCenter defaultCenter] postNotificationName:EMAsync_ProgressHUDDidDisappearNotification
                                                                        object:strongSelf
                                                                      userInfo:[strongSelf notificationUserInfo]];
#if !defined(SV_APP_EXTENSIONS) && TARGET_OS_IOS
                    UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                    [rootController setNeedsStatusBarAppearanceUpdate];
#endif
                    if (completion) {
                        completion();
                    }
                }
            };
            dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
            dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
                strongSelf.graceTimer = nil;
                if (strongSelf.fadeOutAnimationDuration > 0) {
                    [UIView animateWithDuration:strongSelf.fadeOutAnimationDuration
                                          delay:0
                                        options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState)
                                     animations:^{
                                         animationsBlock();
                                     } completion:^(BOOL finished) {
                                         completionBlock();
                                     }];
                } else {
                    animationsBlock();
                    completionBlock();
                }
            });
            [strongSelf setNeedsDisplay];
        }
    }];
}
#pragma mark - Ring progress animation
- (UIView*)indefiniteAnimatedView {
    if(self.defaultAnimationType == EMAsync_ProgressHUDAnimationTypeFlat){
        if(_indefiniteAnimatedView && ![_indefiniteAnimatedView isKindOfClass:[EMAsyncIndefiniteAnimatedView class]]){
            [_indefiniteAnimatedView removeFromSuperview];
            _indefiniteAnimatedView = nil;
        }
        if(!_indefiniteAnimatedView){
            _indefiniteAnimatedView = [[EMAsyncIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
        }
        EMAsyncIndefiniteAnimatedView *indefiniteAnimatedView = (EMAsyncIndefiniteAnimatedView*)_indefiniteAnimatedView;
        indefiniteAnimatedView.strokeColor = self.foregroundImageColorForStyle;
        indefiniteAnimatedView.strokeThickness = self.ringThickness;
        indefiniteAnimatedView.radius = self.statusLabel.text ? self.ringRadius : self.ringNoTextRadius;
    } else {
        if(_indefiniteAnimatedView && ![_indefiniteAnimatedView isKindOfClass:[UIActivityIndicatorView class]]){
            [_indefiniteAnimatedView removeFromSuperview];
            _indefiniteAnimatedView = nil;
        }
        if(!_indefiniteAnimatedView){
            _indefiniteAnimatedView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)_indefiniteAnimatedView;
        activityIndicatorView.color = self.foregroundImageColorForStyle;
    }
    [_indefiniteAnimatedView sizeToFit];
    return _indefiniteAnimatedView;
}
- (EMAsyncProgressAnimatedView*)ringView {
    if(!_ringView) {
        _ringView = [[EMAsyncProgressAnimatedView alloc] initWithFrame:CGRectZero];
    }
    _ringView.strokeColor = self.foregroundImageColorForStyle;
    _ringView.strokeThickness = self.ringThickness;
    _ringView.radius = self.statusLabel.text ? self.ringRadius : self.ringNoTextRadius;
    return _ringView;
}
- (EMAsyncProgressAnimatedView*)backgroundRingView {
    if(!_backgroundRingView) {
        _backgroundRingView = [[EMAsyncProgressAnimatedView alloc] initWithFrame:CGRectZero];
        _backgroundRingView.strokeEnd = 1.0f;
    }
    _backgroundRingView.strokeColor = [self.foregroundImageColorForStyle colorWithAlphaComponent:0.1f];
    _backgroundRingView.strokeThickness = self.ringThickness;
    _backgroundRingView.radius = self.statusLabel.text ? self.ringRadius : self.ringNoTextRadius;
    return _backgroundRingView;
}
- (void)cancelRingLayerAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.hudView.layer removeAllAnimations];
    self.ringView.strokeEnd = 0.0f;
    [CATransaction commit];
    [self.ringView removeFromSuperview];
    [self.backgroundRingView removeFromSuperview];
}
- (void)cancelIndefiniteAnimatedViewAnimation {
    if([self.indefiniteAnimatedView respondsToSelector:@selector(stopAnimating)]) {
        [(id)self.indefiniteAnimatedView stopAnimating];
    }
    [self.indefiniteAnimatedView removeFromSuperview];
}
#pragma mark - Utilities
+ (BOOL)isVisible {
    return [self sharedView].backgroundView.alpha > 0.0f;
}
#pragma mark - Getters
+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    CGFloat minimum = MAX((CGFloat)string.length * 0.06 + 0.5, [self sharedView].minimumDismissTimeInterval);
    return MIN(minimum, [self sharedView].maximumDismissTimeInterval);
}
- (UIColor*)foregroundColorForStyle {
    if(self.defaultStyle == EMAsync_ProgressHUDStyleLight) {
        return [UIColor blackColor];
    } else if(self.defaultStyle == EMAsync_ProgressHUDStyleDark) {
        return [UIColor whiteColor];
    } else {
        return self.foregroundColor;
    }
}
- (UIColor*)foregroundImageColorForStyle {
    if (self.foregroundImageColor) {
        return self.foregroundImageColor;
    } else {
        return [self foregroundColorForStyle];
    }
}
- (UIColor*)backgroundColorForStyle {
    if(self.defaultStyle == EMAsync_ProgressHUDStyleLight) {
        return [UIColor whiteColor];
    } else if(self.defaultStyle == EMAsync_ProgressHUDStyleDark) {
        return [UIColor blackColor];
    } else {
        return self.backgroundColor;
    }
}
- (UIControl*)controlView {
    if(!_controlView) {
        _controlView = [UIControl new];
        _controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _controlView.backgroundColor = [UIColor clearColor];
        _controlView.userInteractionEnabled = YES;
        [_controlView addTarget:self action:@selector(controlViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
#if !defined(SV_APP_EXTENSIONS)
    CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
    _controlView.frame = windowBounds;
#else
    _controlView.frame = [UIScreen mainScreen].bounds;
#endif
    return _controlView;
}
-(UIView *)backgroundView {
    if(!_backgroundView){
        _backgroundView = [UIView new];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if(!_backgroundView.superview){
        [self insertSubview:_backgroundView belowSubview:self.hudView];
    }
    if(self.defaultMaskType == EMAsync_ProgressHUDMaskTypeGradient){
        if(!_backgroundRadialGradientLayer){
            _backgroundRadialGradientLayer = [EMAsyncRadialGradientLayer layer];
        }
        if(!_backgroundRadialGradientLayer.superlayer){
            [_backgroundView.layer insertSublayer:_backgroundRadialGradientLayer atIndex:0];
        }
        _backgroundView.backgroundColor = [UIColor clearColor];
    } else {
        if(_backgroundRadialGradientLayer && _backgroundRadialGradientLayer.superlayer){
            [_backgroundRadialGradientLayer removeFromSuperlayer];
        }
        if(self.defaultMaskType == EMAsync_ProgressHUDMaskTypeBlack){
            _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        } else if(self.defaultMaskType == EMAsync_ProgressHUDMaskTypeCustom){
            _backgroundView.backgroundColor = self.backgroundLayerColor;
        } else {
            _backgroundView.backgroundColor = [UIColor clearColor];
        }
    }
    if(_backgroundView){
        _backgroundView.frame = self.bounds;
    }
    if(_backgroundRadialGradientLayer){
        _backgroundRadialGradientLayer.frame = self.bounds;
        CGPoint gradientCenter = self.center;
        gradientCenter.y = (self.bounds.size.height - self.visibleKeyboardHeight)/2;
        _backgroundRadialGradientLayer.gradientCenter = gradientCenter;
        [_backgroundRadialGradientLayer setNeedsDisplay];
    }
    return _backgroundView;
}
- (UIVisualEffectView*)hudView {
    if(!_hudView) {
        _hudView = [UIVisualEffectView new];
        _hudView.layer.masksToBounds = YES;
        _hudView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    if(!_hudView.superview) {
        [self addSubview:_hudView];
    }
    _hudView.layer.cornerRadius = self.cornerRadius;
    return _hudView;
}
- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 0;
    }
    if(!_statusLabel.superview) {
      [self.hudView.contentView addSubview:_statusLabel];
    }
    _statusLabel.textColor = self.foregroundColorForStyle;
    _statusLabel.font = self.font;
    return _statusLabel;
}
- (UIImageView*)imageView {
    if(_imageView && !CGSizeEqualToSize(_imageView.bounds.size, _imageViewSize)) {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _imageViewSize.width, _imageViewSize.height)];
    }
    if(!_imageView.superview) {
        [self.hudView.contentView addSubview:_imageView];
    }
    return _imageView;
}
#pragma mark - Helper
- (CGFloat)visibleKeyboardHeight {
#if !defined(SV_APP_EXTENSIONS)
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in UIApplication.sharedApplication.windows) {
        if(![testWindow.class isEqual:UIWindow.class]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    for (__strong UIView *possibleKeyboard in keyboardWindow.subviews) {
        NSString *viewName = NSStringFromClass(possibleKeyboard.class);
        if([viewName hasPrefix:@"UI"]){
            if([viewName hasSuffix:@"PeripheralHostView"] || [viewName hasSuffix:@"Keyboard"]){
                return CGRectGetHeight(possibleKeyboard.bounds);
            } else if ([viewName hasSuffix:@"InputSetContainerView"]){
                for (__strong UIView *possibleKeyboardSubview in possibleKeyboard.subviews) {
                    viewName = NSStringFromClass(possibleKeyboardSubview.class);
                    if([viewName hasPrefix:@"UI"] && [viewName hasSuffix:@"InputSetHostView"]) {
                        CGRect convertedRect = [possibleKeyboard convertRect:possibleKeyboardSubview.frame toView:self];
                        CGRect intersectedRect = CGRectIntersection(convertedRect, self.bounds);
                        if (!CGRectIsNull(intersectedRect)) {
                            return CGRectGetHeight(intersectedRect);
                        }
                    }
                }
            }
        }
    }
#endif
    return 0;
}
- (UIWindow *)frontWindow {
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
        BOOL windowKeyWindow = window.isKeyWindow;
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
#endif
    return nil;
}
- (void)fadeInEffects {
    if(self.defaultStyle != EMAsync_ProgressHUDStyleCustom) {
        UIBlurEffectStyle blurEffectStyle = self.defaultStyle == EMAsync_ProgressHUDStyleDark ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
        self.hudView.effect = blurEffect;
        self.hudView.backgroundColor = [self.backgroundColorForStyle colorWithAlphaComponent:0.6f];
    } else {
        self.hudView.effect = self.hudViewCustomBlurEffect;
        self.hudView.backgroundColor =  self.backgroundColorForStyle;
    }
    self.backgroundView.alpha = 1.0f;
    self.imageView.alpha = 1.0f;
    self.statusLabel.alpha = 1.0f;
    self.indefiniteAnimatedView.alpha = 1.0f;
    self.ringView.alpha = self.backgroundRingView.alpha = 1.0f;
}
- (void)fadeOutEffects
{
    if(self.defaultStyle != EMAsync_ProgressHUDStyleCustom) {
        self.hudView.effect = nil;
    }
    self.hudView.backgroundColor = [UIColor clearColor];
    self.backgroundView.alpha = 0.0f;
    self.imageView.alpha = 0.0f;
    self.statusLabel.alpha = 0.0f;
    self.indefiniteAnimatedView.alpha = 0.0f;
    self.ringView.alpha = self.backgroundRingView.alpha = 0.0f;
}
#if TARGET_OS_IOS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (UINotificationFeedbackGenerator *)hapticGenerator NS_AVAILABLE_IOS(10_0) {
	if(!self.hapticsEnabled) {
		return nil;
	}
	if(!_hapticGenerator) {
		_hapticGenerator = [[UINotificationFeedbackGenerator alloc] init];
	}
	return _hapticGenerator;
}
#endif
#pragma mark - UIAppearance Setters
- (void)setDefaultStyle:(EMAsync_ProgressHUDStyle)style {
    if (!_isInitializing) _defaultStyle = style;
}
- (void)setDefaultMaskType:(EMAsync_ProgressHUDMaskType)maskType {
    if (!_isInitializing) _defaultMaskType = maskType;
}
- (void)setDefaultAnimationType:(EMAsync_ProgressHUDAnimationType)animationType {
    if (!_isInitializing) _defaultAnimationType = animationType;
}
- (void)setContainerView:(UIView *)containerView {
    if (!_isInitializing) _containerView = containerView;
}
- (void)setMinimumSize:(CGSize)minimumSize {
    if (!_isInitializing) _minimumSize = minimumSize;
}
- (void)setRingThickness:(CGFloat)ringThickness {
    if (!_isInitializing) _ringThickness = ringThickness;
}
- (void)setRingRadius:(CGFloat)ringRadius {
    if (!_isInitializing) _ringRadius = ringRadius;
}
- (void)setRingNoTextRadius:(CGFloat)ringNoTextRadius {
    if (!_isInitializing) _ringNoTextRadius = ringNoTextRadius;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (!_isInitializing) _cornerRadius = cornerRadius;
}
- (void)setFont:(UIFont*)font {
    if (!_isInitializing) _font = font;
}
- (void)setForegroundColor:(UIColor*)color {
    if (!_isInitializing) _foregroundColor = color;
}
- (void)setForegroundImageColor:(UIColor *)color {
    if (!_isInitializing) _foregroundImageColor = color;
}
- (void)setBackgroundColor:(UIColor*)color {
    if (!_isInitializing) _backgroundColor = color;
}
- (void)setBackgroundLayerColor:(UIColor*)color {
    if (!_isInitializing) _backgroundLayerColor = color;
}
- (void)setShouldTintImages:(BOOL)shouldTintImages {
    if (!_isInitializing) _shouldTintImages = shouldTintImages;
}
- (void)setInfoImage:(UIImage*)image {
    if (!_isInitializing) _infoImage = image;
}
- (void)setSuccessImage:(UIImage*)image {
    if (!_isInitializing) _successImage = image;
}
- (void)setErrorImage:(UIImage*)image {
    if (!_isInitializing) _errorImage = image;
}
- (void)setViewForExtension:(UIView*)view {
    if (!_isInitializing) _viewForExtension = view;
}
- (void)setOffsetFromCenter:(UIOffset)offset {
    if (!_isInitializing) _offsetFromCenter = offset;
}
- (void)setMinimumDismissTimeInterval:(NSTimeInterval)minimumDismissTimeInterval {
    if (!_isInitializing) _minimumDismissTimeInterval = minimumDismissTimeInterval;
}
- (void)setFadeInAnimationDuration:(NSTimeInterval)duration {
    if (!_isInitializing) _fadeInAnimationDuration = duration;
}
- (void)setFadeOutAnimationDuration:(NSTimeInterval)duration {
    if (!_isInitializing) _fadeOutAnimationDuration = duration;
}
- (void)setMaxSupportedWindowLevel:(UIWindowLevel)maxSupportedWindowLevel {
    if (!_isInitializing) _maxSupportedWindowLevel = maxSupportedWindowLevel;
}
@end
