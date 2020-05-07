#ifndef EMAsync_Header_h
#define EMAsync_Header_h
#ifndef BLOCK_SAFE_CALLS
#define BLOCK_SAFE_CALLS(block, ...) block ? block(__VA_ARGS__) : nil
#endif
#ifndef WEAKSELF
#define WEAK_OBJECT(obj, weakObj)       __weak typeof(obj) weakObj = obj;
#define WEAKSELF                     WEAK_OBJECT(self, weakSelf);
#endif
#ifndef STRONGSELF
#define STRONG_OBJECT(objc, strongObjc) __strong typeof(objc) strongObjc = objc;
#define STRONGSELF                   STRONG_OBJECT(weakSelf, self);
#endif

#define WDIsiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define WDIsiPhoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f&& WDIsiPhone

//状态栏高度
#define kStatusBarHeight  (CGFloat)(WDIsiPhoneX?(44):(20))
// 导航栏高度
#define kNavBarHeight  (44)
// 状态栏和导航栏总高度
#define kNavBarHeightWithStatusBar  (CGFloat)(WDIsiPhoneX?(88):(64))
// TabBar高度
#define kTabBarHeight  (CGFloat)(WDIsiPhoneX?(49+34):(49))
// 顶部安全区域远离高度
#define kTopBarSafeHeight  (CGFloat)(WDIsiPhoneX?(44):(0))
// 底部安全区域远离高度
#define kBottomSafeHeight  (CGFloat)(WDIsiPhoneX?(34):(0))
// iPhoneX的状态栏高度差值
#define kTopBarDifHeight  (CGFloat)(WDIsiPhoneX?(24):(0))

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define WDRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#endif
