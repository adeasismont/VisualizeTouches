#import <UIKit/UIKit.h>

@class VTTouchVisualizationView;

@interface VTTouchWindow : UIWindow

@property (nonatomic, strong, readonly) VTTouchVisualizationView *touchView;

// nested
- (void)beginInterceptingEvents;
- (void)endInterceptingEvents;
@property (nonatomic, assign, getter = isInterceptingEvents) BOOL interceptingEvents;

- (void)handleEvent:(UIEvent *)event;

@end
