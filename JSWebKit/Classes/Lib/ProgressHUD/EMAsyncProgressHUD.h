#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>
extern NSString * _Nonnull const EMAsync_ProgressHUDDidReceiveTouchEventNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDDidTouchDownInsideNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDWillDisappearNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDDidDisappearNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDWillAppearNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDDidAppearNotification;
extern NSString * _Nonnull const EMAsync_ProgressHUDStatusUserInfoKey;
typedef NS_ENUM(NSInteger, EMAsync_ProgressHUDStyle) {
    EMAsync_ProgressHUDStyleLight NS_SWIFT_NAME(light),   
    EMAsync_ProgressHUDStyleDark NS_SWIFT_NAME(dark),     
    EMAsync_ProgressHUDStyleCustom NS_SWIFT_NAME(custom)  
};
typedef NS_ENUM(NSUInteger, EMAsync_ProgressHUDMaskType) {
    EMAsync_ProgressHUDMaskTypeNone NS_SWIFT_NAME(none) = 1,      
    EMAsync_ProgressHUDMaskTypeClear NS_SWIFT_NAME(clear),        
    EMAsync_ProgressHUDMaskTypeBlack NS_SWIFT_NAME(black),        
    EMAsync_ProgressHUDMaskTypeGradient NS_SWIFT_NAME(gradient),  
    EMAsync_ProgressHUDMaskTypeCustom NS_SWIFT_NAME(custom)       
};
typedef NS_ENUM(NSUInteger, EMAsync_ProgressHUDAnimationType) {
    EMAsync_ProgressHUDAnimationTypeFlat NS_SWIFT_NAME(flat),     
    EMAsync_ProgressHUDAnimationTypeNative NS_SWIFT_NAME(native)  
};
typedef void (^EMAsync_ProgressHUDShowCompletion)(void);
typedef void (^EMAsync_ProgressHUDDismissCompletion)(void);
@interface EMAsyncProgressHUD : UIView
#pragma mark - Customization
@property (assign, nonatomic) EMAsync_ProgressHUDStyle defaultStyle UI_APPEARANCE_SELECTOR;                   
@property (assign, nonatomic) EMAsync_ProgressHUDMaskType defaultMaskType UI_APPEARANCE_SELECTOR;             
@property (assign, nonatomic) EMAsync_ProgressHUDAnimationType defaultAnimationType UI_APPEARANCE_SELECTOR;   
@property (strong, nonatomic, nullable) UIView *containerView;                                          
@property (assign, nonatomic) CGSize minimumSize UI_APPEARANCE_SELECTOR;                        
@property (assign, nonatomic) CGFloat ringThickness UI_APPEARANCE_SELECTOR;                     
@property (assign, nonatomic) CGFloat ringRadius UI_APPEARANCE_SELECTOR;                        
@property (assign, nonatomic) CGFloat ringNoTextRadius UI_APPEARANCE_SELECTOR;                  
@property (assign, nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;                      
@property (strong, nonatomic, nonnull) UIFont *font UI_APPEARANCE_SELECTOR;                     
@property (strong, nonatomic, nonnull) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;         
@property (strong, nonatomic, nonnull) UIColor *foregroundColor UI_APPEARANCE_SELECTOR;         
@property (strong, nonatomic, nullable) UIColor *foregroundImageColor UI_APPEARANCE_SELECTOR;   
@property (strong, nonatomic, nonnull) UIColor *backgroundLayerColor UI_APPEARANCE_SELECTOR;    
@property (assign, nonatomic) CGSize imageViewSize UI_APPEARANCE_SELECTOR;                      
@property (assign, nonatomic) BOOL shouldTintImages UI_APPEARANCE_SELECTOR;                     
@property (strong, nonatomic, nonnull) UIImage *infoImage UI_APPEARANCE_SELECTOR;               
@property (strong, nonatomic, nonnull) UIImage *successImage UI_APPEARANCE_SELECTOR;            
@property (strong, nonatomic, nonnull) UIImage *errorImage UI_APPEARANCE_SELECTOR;              
@property (strong, nonatomic, nonnull) UIView *viewForExtension UI_APPEARANCE_SELECTOR;         
@property (assign, nonatomic) NSTimeInterval graceTimeInterval;                                 
@property (assign, nonatomic) NSTimeInterval minimumDismissTimeInterval;                        
@property (assign, nonatomic) NSTimeInterval maximumDismissTimeInterval;                        
@property (assign, nonatomic) UIOffset offsetFromCenter UI_APPEARANCE_SELECTOR; 
@property (assign, nonatomic) NSTimeInterval fadeInAnimationDuration UI_APPEARANCE_SELECTOR;    
@property (assign, nonatomic) NSTimeInterval fadeOutAnimationDuration UI_APPEARANCE_SELECTOR;   
@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel; 
@property (assign, nonatomic) BOOL hapticsEnabled;      
@property (assign, nonatomic) BOOL motionEffectEnabled; 
+ (void)setDefaultStyle:(EMAsync_ProgressHUDStyle)style;                      
+ (void)setDefaultMaskType:(EMAsync_ProgressHUDMaskType)maskType;             
+ (void)setDefaultAnimationType:(EMAsync_ProgressHUDAnimationType)type;       
+ (void)setContainerView:(nullable UIView*)containerView;               
+ (void)setMinimumSize:(CGSize)minimumSize;                             
+ (void)setRingThickness:(CGFloat)ringThickness;                        
+ (void)setRingRadius:(CGFloat)radius;                                  
+ (void)setRingNoTextRadius:(CGFloat)radius;                            
+ (void)setCornerRadius:(CGFloat)cornerRadius;                          
+ (void)setBorderColor:(nonnull UIColor*)color;                         
+ (void)setBorderWidth:(CGFloat)width;                                  
+ (void)setFont:(nonnull UIFont*)font;                                  
+ (void)setForegroundColor:(nonnull UIColor*)color;                     
+ (void)setForegroundImageColor:(nullable UIColor*)color;               
+ (void)setBackgroundColor:(nonnull UIColor*)color;                     
+ (void)setHudViewCustomBlurEffect:(nullable UIBlurEffect*)blurEffect;  
+ (void)setBackgroundLayerColor:(nonnull UIColor*)color;                
+ (void)setImageViewSize:(CGSize)size;                                  
+ (void)setShouldTintImages:(BOOL)shouldTintImages;                     
+ (void)setInfoImage:(nonnull UIImage*)image;                           
+ (void)setSuccessImage:(nonnull UIImage*)image;                        
+ (void)setErrorImage:(nonnull UIImage*)image;                          
+ (void)setViewForExtension:(nonnull UIView*)view;                      
+ (void)setGraceTimeInterval:(NSTimeInterval)interval;                  
+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;         
+ (void)setMaximumDismissTimeInterval:(NSTimeInterval)interval;         
+ (void)setFadeInAnimationDuration:(NSTimeInterval)duration;            
+ (void)setFadeOutAnimationDuration:(NSTimeInterval)duration;           
+ (void)setMaxSupportedWindowLevel:(UIWindowLevel)windowLevel;          
+ (void)setHapticsEnabled:(BOOL)hapticsEnabled;						    
+ (void)setMotionEffectEnabled:(BOOL)motionEffectEnabled;               
#pragma mark - Show Methods
+ (void)show;
+ (void)showWithMaskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use show and setDefaultMaskType: instead.")));
+ (void)showWithStatus:(nullable NSString*)status;
+ (void)showWithStatus:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showWithStatus: and setDefaultMaskType: instead.")));
+ (void)showProgress:(float)progress;
+ (void)showProgress:(float)progress maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress: and setDefaultMaskType: instead.")));
+ (void)showProgress:(float)progress status:(nullable NSString*)status;
+ (void)showProgress:(float)progress status:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress:status: and setDefaultMaskType: instead.")));
+ (void)setStatus:(nullable NSString*)status; 
+ (void)showInfoWithStatus:(nullable NSString*)status;
+ (void)showInfoWithStatus:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showInfoWithStatus: and setDefaultMaskType: instead.")));
+ (void)showSuccessWithStatus:(nullable NSString*)status;
+ (void)showSuccessWithStatus:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showSuccessWithStatus: and setDefaultMaskType: instead.")));
+ (void)showErrorWithStatus:(nullable NSString*)status;
+ (void)showErrorWithStatus:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showErrorWithStatus: and setDefaultMaskType: instead.")));
+ (void)showImage:(nonnull UIImage*)image status:(nullable NSString*)status;
+ (void)showImage:(nonnull UIImage*)image status:(nullable NSString*)status maskType:(EMAsync_ProgressHUDMaskType)maskType __attribute__((deprecated("Use showImage:status: and setDefaultMaskType: instead.")));
+ (void)setOffsetFromCenter:(UIOffset)offset;
+ (void)resetOffsetFromCenter;
+ (void)popActivity; 
+ (void)dismiss;
+ (void)dismissWithCompletion:(nullable EMAsync_ProgressHUDDismissCompletion)completion;
+ (void)dismissWithDelay:(NSTimeInterval)delay;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(nullable EMAsync_ProgressHUDDismissCompletion)completion;
+ (BOOL)isVisible;
+ (NSTimeInterval)displayDurationForString:(nullable NSString*)string;
@end
