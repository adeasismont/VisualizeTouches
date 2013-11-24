#import <UIKit/UIKit.h>

extern NSString *VTInterceptedEventNotification;
extern NSString *VTInterceptedEventUserInfoKey; // => UIEvent

@interface UIApplication (VTInterceptEvents)

+ (void)visualizetouches_swizzleSendEvent;
+ (BOOL)visualizetouches_sendEventSwizzled;

@end
