#import "AKAppDelegate.h"
#import "VisualizeTouches.h"
#import "AKFakeTouch.h"

@interface AKAppDelegate ()

@property (nonatomic, strong) VTTouchWindow *touchWindow;

@end

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeSystem];
    [play setTitle:@"Play touches" forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playTouches:) forControlEvents:UIControlEventTouchUpInside];
    [play sizeToFit];
    play.layer.position = CGPointMake(100, 100);
    [self.window addSubview:play];
    
    // Show touches in this window
    self.touchWindow = [VTTouchWindow new];
    self.touchWindow.touchView.shouldDrawPaths = YES;
    
    // Start intercepting application events
    [self.touchWindow beginInterceptingEvents];
    
    return YES;
}

- (IBAction)playTouches:(id)sender
{
    int i = 0;
    NSArray *positions = @[
        [NSValue valueWithCGPoint:CGPointMake(150, 200)],
        [NSValue valueWithCGPoint:CGPointMake(200, 220)],
        [NSValue valueWithCGPoint:CGPointMake(250, 220)],
        [NSValue valueWithCGPoint:CGPointMake(300, 200)],
        [NSValue valueWithCGPoint:CGPointMake(200, 150)],
        [NSValue valueWithCGPoint:CGPointMake(250, 150)],
    ];
    for(NSValue *v in positions) {
        double delayInSeconds = i/2.;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            AKFakeTouch *fake = [[AKFakeTouch alloc] initWithPhase:UITouchPhaseBegan point:v.CGPointValue];
            [_touchWindow.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delayInSeconds+1.0) * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            AKFakeTouch *fake = [[AKFakeTouch alloc] initWithPhase:UITouchPhaseEnded point:v.CGPointValue];
            [_touchWindow.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });

        i++;
    }
}

@end

