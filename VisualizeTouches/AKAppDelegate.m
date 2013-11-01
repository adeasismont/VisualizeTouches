#import "AKAppDelegate.h"
#import "UIApplication+interceptEvents.h"
#import "TouchWindow.h"

@interface FakeTouch : NSObject <TVTouch>
- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p;
@property(nonatomic) UITouchPhase phase;
@property(nonatomic) CGPoint point;
@property(nonatomic) id<NSCopying> tv_touchKey;
- (CGPoint)locationInView:(UIView*)view;
@end


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
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeSystem];
    [play setTitle:@"Play touches" forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playTouches:) forControlEvents:UIControlEventTouchUpInside];
    [play sizeToFit];
    play.layer.position = CGPointMake(100, 100);
    [_window addSubview:play];
    
    // Show touches in this window
    _touchWindow = [TouchWindow new];
    _touchWindow.touchView.shouldDrawPaths = YES;
    _touchWindow.hidden = NO;
    
    // Intercept all touches in app and forward them to the visualizer
    [UIApplication visualizetouches_swizzleSendEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchReceived:) name:AKInterceptedTouchNotification object:nil];
    
    return YES;
}

- (void)touchReceived:(NSNotification*)notif
{
    UIEvent *event = notif.userInfo[AKInterceptedEventUserInfoKey];
    [_touchWindow.touchView updateTouchesWithVisibleTouches:event.allTouches];
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
            FakeTouch *fake = [[FakeTouch alloc] initWithPhase:UITouchPhaseBegan point:v.CGPointValue];
            [_touchWindow.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delayInSeconds+1.0) * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            FakeTouch *fake = [[FakeTouch alloc] initWithPhase:UITouchPhaseEnded point:v.CGPointValue];
            [_touchWindow.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });

        i++;
    }
}

@end

@implementation FakeTouch
- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p
{
    if(!(self = [super init]))
        return nil;
    _phase = phase;
    _point = p;
    _tv_touchKey = [NSValue valueWithNonretainedObject:self];
    return self;
}
- (CGPoint)locationInView:(UIView*)view
{
    return _point;
}
@end
