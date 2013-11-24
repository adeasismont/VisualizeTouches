#import <UIKit/UIKit.h>

extern NSString *VTInterceptedEventNotification;
extern NSString *VTInterceptedEventUserInfoKey; // => UIEvent

/**
 * Intercepts all events in UIApplication and sends a VTInterceptedEventNotification notification
 * for each event.
 */
@interface UIApplication (VTInterceptEvents)

+ (void)visualizetouches_swizzleSendEvent;
+ (BOOL)visualizetouches_sendEventSwizzled;

@end
