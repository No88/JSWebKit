#import "EMAsyncTabButton.h"
#import "EMAsyncUIView+DHQExtension.h"
@implementation EMAsyncTabButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)commonInit{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = self.imageView.y + self.imageView.height - 3;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = 30;
    CGFloat imageH = 30;
    CGFloat x = (contentRect.size.width - imageW) * 0.5;
    CGFloat y = (contentRect.size.height - imageH) * 0.5 - 5;
    return CGRectMake(x, y, imageW, imageH);
}
@end
