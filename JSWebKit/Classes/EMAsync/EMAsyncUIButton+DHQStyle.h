#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, DHQButtonEdgeInsetsStyle) {
    DHQButtonEdgeInsetsStyleTop,
    DHQButtonEdgeInsetsStyleLeft,
    DHQButtonEdgeInsetsStyleBottom,
    DHQButtonEdgeInsetsStyleRight
};
typedef enum {
    ButtonCornerTypeLeft,
    ButtonCornerTypeRight,
    ButtonCornerTypeTopLeft,
    ButtonCornerTypeTopRight,
    ButtonCornerTypeBottomLeft,
    ButtonCornerTypeBottomRight
} ButtonCornerType;
@interface UIButton (DHQStyle)
#pragma mark - 
- (void)layoutButtonWithEdgeInsetsStyle:(DHQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
- (void)dhq_layoutButtonHorizontalStyle:(DHQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
#pragma mark -
- (void)countDownFromTime:(NSInteger)startTime title:(NSString *)title unitTitle:(NSString *)unitTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
- (void)dhq_countDownFromTime:(NSInteger)startTime
                originalTitle:(NSString *)originalTitle
               countdownTitle:(NSString *)countdownTitle
          originalButtonColor:(UIColor *)originalButtonColor
               countdownColor:(UIColor *)countdownColor;
#pragma mark -
@property (assign , nonatomic) CGFloat cornerRadius;
- (void)dhq_setRoundSide:(ButtonCornerType)type;
@end
