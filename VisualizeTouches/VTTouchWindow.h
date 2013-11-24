#import <UIKit/UIKit.h>

@class VTTouchVisualizationView;

/**
 * VTTouchWindow
 * Helper window for visualizing touches on the screen.
 * Instantiate and call -beginInterceptingEvents or set hidden to NO and
 * call -handleEvent: or manage touches manually in the VTTouchVisualizationView directly.
 */
@interface VTTouchWindow : UIWindow

@property (nonatomic, strong, readonly) VTTouchVisualizationView *touchView;

// nested
- (void)beginInterceptingEvents; // intercepts events using UIApplication+VTInterceptEvents
- (void)endInterceptingEvents;
@property (nonatomic, assign, getter = isInterceptingEvents) BOOL interceptingEvents;

- (void)handleEvent:(UIEvent *)event;

@end
