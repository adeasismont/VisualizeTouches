#import "UIApplication+VTInterceptEvents.h"
#import <objc/runtime.h>

NSString *VTInterceptedEventNotification = @"VTInterceptedEventNotification";
NSString *VTInterceptedEventUserInfoKey = @"VTInterceptedEventUserInfoKey";

static BOOL _VTInterceptEventsSwizzled = NO;

@implementation UIApplication (VTInterceptEvents)

+ (void)visualizetouches_swizzleSendEvent
{
    if ([self visualizetouches_sendEventSwizzled])
        return;
    
    _VTInterceptEventsSwizzled = YES;
    
    Method orig = class_getInstanceMethod([UIApplication class], @selector(sendEvent:));
    Method repl = class_getInstanceMethod([UIApplication class], @selector(visualizetouches_sendEvent:));
    method_exchangeImplementations(orig, repl);
}

+ (BOOL)visualizetouches_sendEventSwizzled
{
    return _VTInterceptEventsSwizzled;
}

- (void)visualizetouches_sendEvent:(UIEvent*)event
{
    [self visualizetouches_sendEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VTInterceptedEventNotification
                                                        object:nil
                                                      userInfo:@{ VTInterceptedEventUserInfoKey: event }];
}
@end
