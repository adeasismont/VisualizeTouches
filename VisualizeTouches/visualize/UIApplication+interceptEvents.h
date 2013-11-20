#import <UIKit/UIKit.h>

extern NSString *AKInterceptedTouchNotification;
extern NSString *AKInterceptedEventUserInfoKey; // => UIEvent

@interface UIApplication (AKInterceptEvents)
+ (void)visualizetouches_swizzleSendEvent;
@end
