#import <UIKit/UIKit.h>
#import "EMAsyncSSDKProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (EMAsyncSSDKProgressHUD)
- (void)EMAsync_showText:(NSString *)aText;
- (void)EMAsync_showErrorText:(NSString *)aText;
- (void)EMAsync_showSuccessText:(NSString *)aText;
- (void)EMAsync_showLoading;
- (void)EMAsync_dismiss;
- (void)EMAsync_showProgress:(NSInteger)progress;
- (void)EMAsync_showImage:(UIImage*)image text:(NSString*)aText;
@end
NS_ASSUME_NONNULL_END
