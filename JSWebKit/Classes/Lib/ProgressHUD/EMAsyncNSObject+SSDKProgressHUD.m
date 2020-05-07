#import "EMAsyncNSObject+SSDKProgressHUD.h"
@implementation NSObject (EMAsyncSSDKProgressHUD)
- (void)EMAsync_showText:(NSString *)aText {
    if (!aText.length) {
        [self EMAsync_dismiss];
        return;
    }
    [EMAsyncSSDKProgressHUD showWithStatus:aText];
}
- (void)EMAsync_showErrorText:(NSString *)aText {
    if (!aText.length) {
        [self EMAsync_dismiss];
        return;
    }
    [EMAsyncSSDKProgressHUD showErrorWithStatus:aText];
}
- (void)EMAsync_showSuccessText:(NSString *)aText {
    if (!aText.length) {
        [self EMAsync_dismiss];
        return;
    }
    [EMAsyncSSDKProgressHUD showSuccessWithStatus:aText];
}
- (void)EMAsync_showLoading {
    [EMAsyncSSDKProgressHUD show];
}
- (void)EMAsync_dismiss {
    [EMAsyncSSDKProgressHUD dismiss];
}
- (void)EMAsync_showProgress:(NSInteger)progress {
    [EMAsyncSSDKProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}
- (void)EMAsync_showImage:(UIImage*)image text:(NSString*)aText {
    if (!aText.length || !image) {
        [self EMAsync_showLoading];
        return;
    }
    [EMAsyncSSDKProgressHUD showImage:image status:aText];
}
@end
