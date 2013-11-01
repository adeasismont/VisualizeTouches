#import "UIApplication+interceptEvents.h"
#import <objc/runtime.h>

NSString *AKInterceptedTouchNotification = @"AKInterceptedTouchNotification";
NSString *AKInterceptedEventUserInfoKey = @"AKInterceptedEventUserInfoKey";

@implementation UIApplication (AKInterceptEvents)
+ (void)visualizetouches_swizzleSendEvent
{
    Method orig = class_getInstanceMethod([UIApplication class], @selector(sendEvent:));
    Method repl = class_getInstanceMethod([UIApplication class], @selector(visualizetouches_sendEvent:));
    method_exchangeImplementations(orig, repl);
}

- (void)visualizetouches_sendEvent:(UIEvent*)event
{
    [self visualizetouches_sendEvent:event];
    
    if(event.type == UIEventTypeTouches) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AKInterceptedTouchNotification object:nil userInfo:@{
            AKInterceptedEventUserInfoKey: event
        }];
    }
}
@end
