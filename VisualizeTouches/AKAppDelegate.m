#import "AKAppDelegate.h"
#import "TouchWindow.h"

@implementation AKAppDelegate
{
    TouchWindow *_touchWindow;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Show touches in this window
    _touchWindow = [TouchWindow new];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeSystem];
    [play setTitle:@"Play touches" forState:UIControlStateNormal];
    [play addTarget:_touchWindow action:@selector(playTouches) forControlEvents:UIControlEventTouchUpInside];
    [play sizeToFit];
    play.layer.position = CGPointMake(100, 100);
    [_window addSubview:play];
    
    return YES;
}

@end
