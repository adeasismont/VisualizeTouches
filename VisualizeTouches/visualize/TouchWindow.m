#import "TouchWindow.h"
#import "UIApplication+interceptEvents.h"

@interface FakeTouch : NSObject <TVTouch>

@property(nonatomic) UITouchPhase phase;
@property(nonatomic) CGPoint point;
@property(nonatomic) id<NSCopying> tv_touchKey;

- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p;
- (CGPoint)locationInView:(UIView*)view;

@end

@implementation FakeTouch

- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p {
    if(!(self = [super init]))
        return nil;
    _phase = phase;
    _point = p;
    _tv_touchKey = [NSValue valueWithNonretainedObject:self];
    return self;
}

- (CGPoint)locationInView:(UIView*)view {
    return _point;
}

@end

@interface TouchWindow ()

@property(nonatomic,readonly) TouchVisualizationView *touchView;

@end

@implementation TouchWindow

- (id)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame {
    if(!(self = [super initWithFrame:frame]))
        return nil;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.windowLevel = UIWindowLevelStatusBar;
    _touchView = [[TouchVisualizationView alloc] initWithFrame:self.bounds];
    [self addSubview:_touchView];
    
    self.touchView.shouldDrawPaths = YES;
    self.hidden = NO;
    
    // Intercept all touches in app and forward them to the visualizer
    [UIApplication visualizetouches_swizzleSendEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchReceived:) name:AKInterceptedTouchNotification object:nil];
    
    return self;
}

- (void)touchReceived:(NSNotification*)notification {
    UIEvent *event = notification.userInfo[AKInterceptedEventUserInfoKey];
    [self.touchView updateTouchesWithVisibleTouches:event.allTouches];
}

#pragma mark - Play sequence of touches, just for show

- (void)playTouches {
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
            [self.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delayInSeconds+1.0) * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            FakeTouch *fake = [[FakeTouch alloc] initWithPhase:UITouchPhaseEnded point:v.CGPointValue];
            [self.touchView updateTouchesWithVisibleTouches:[NSSet setWithObject:fake]];
        });
        
        i++;
    }
}

@end
