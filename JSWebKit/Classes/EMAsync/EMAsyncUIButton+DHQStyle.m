#import "EMAsyncUIButton+DHQStyle.h"
#import <objc/runtime.h>
#import "EMAsyncUIView+DHQExtension.h"
@implementation UIButton (DHQStyle)
- (void)layoutButtonWithEdgeInsetsStyle:(DHQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    switch (style) {
        case DHQButtonEdgeInsetsStyleTop: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case DHQButtonEdgeInsetsStyleLeft: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case DHQButtonEdgeInsetsStyleBottom: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case DHQButtonEdgeInsetsStyleRight: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
- (void)dhq_layoutButtonHorizontalStyle:(DHQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    [self layoutButtonWithEdgeInsetsStyle:style imageTitleSpace:space];
    [self sizeToFit];
    self.width += space;
}
#pragma mark -
- (void)countDownFromTime:(NSInteger)startTime title:(NSString *)title unitTitle:(NSString *)unitTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    __weak typeof(self) weakSelf = self;
    __block NSInteger remainTime = startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title forState:UIControlStateNormal];
                weakSelf.enabled = YES;
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", remainTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = color;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,unitTitle] forState:UIControlStateDisabled];
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}
- (void)dhq_countDownFromTime:(NSInteger)startTime
                originalTitle:(NSString *)originalTitle
               countdownTitle:(NSString *)countdownTitle
          originalButtonColor:(UIColor *)originalButtonColor
               countdownColor:(UIColor *)countdownColor {
    __weak typeof(self) weakSelf = self;
    __block NSInteger remainTime = startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitleColor:originalButtonColor forState:UIControlStateNormal];
                [weakSelf setTitle:originalTitle forState:UIControlStateNormal];
                weakSelf.enabled = YES;
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", remainTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitleColor:countdownColor forState:UIControlStateDisabled];
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@", timeStr, countdownTitle] forState:UIControlStateDisabled];
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}
#pragma mark - 
static const void *kCornerRadius = @"kCornerRadius";
- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, kCornerRadius, [NSNumber numberWithFloat:cornerRadius], OBJC_ASSOCIATION_ASSIGN);
}
- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, kCornerRadius) floatValue];
}
- (void)dhq_setRoundSide:(ButtonCornerType)type {
    UIBezierPath *maskPath;
    switch (type) {
        case ButtonCornerTypeLeft:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height )
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:CGSizeMake(self.cornerRadius , self.cornerRadius )];
            break;
        case ButtonCornerTypeRight:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                                   cornerRadii:CGSizeMake(self.cornerRadius , self.cornerRadius )];
            break;
        case ButtonCornerTypeTopLeft:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft)
                                                   cornerRadii:CGSizeMake(self.cornerRadius, 0)];
            break;
        case ButtonCornerTypeTopRight:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
            break;
        case ButtonCornerTypeBottomLeft:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
            break;
        case ButtonCornerTypeBottomRight:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
            break;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}
@end
