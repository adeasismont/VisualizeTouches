#import "VTTouchWindow.h"
#import "VTTouchVisualizationView.h"
#import "UIApplication+VTInterceptEvents.h"

@interface VTTouchWindow ()

@property (nonatomic, strong) VTTouchVisualizationView *touchView;
@property (nonatomic, assign) NSInteger interceptEventsCount;

@end

@implementation VTTouchWindow

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    if(!(self = [super initWithFrame:frame]))
        return nil;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.windowLevel = UIWindowLevelStatusBar;
    
    _touchView = [[VTTouchVisualizationView alloc] initWithFrame:self.bounds];
    [self addSubview:_touchView];
    
    return self;
}

- (void)dealloc
{
    [self _stopInterceptingEvents];
}


#pragma mark - Public

- (void)beginInterceptingEvents
{
    self.interceptEventsCount++;
    if (self.interceptEventsCount == 1)
        [self _startInterceptingEvents];
}

- (void)endInterceptingEvents
{
    if (!self.interceptEventsCount)
        return;
    
    self.interceptEventsCount--;
    if (!self.interceptEventsCount)
        [self _stopInterceptingEvents];
}

- (BOOL)isInterceptingEvents
{
    return self.interceptEventsCount > 0;
}

- (void)handleEvent:(UIEvent *)event
{
    if (event.type != UIEventTypeTouches)
        return;
    
    [self.touchView updateTouchesWithVisibleTouches:event.allTouches];
}


#pragma mark - Private

- (void)_startInterceptingEvents
{
    [UIApplication visualizetouches_swizzleSendEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interceptedEventNotification:)
                                                 name:VTInterceptedEventNotification
                                               object:nil];
    
    self.hidden = NO;
}

- (void)_stopInterceptingEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VTInterceptedEventNotification object:nil];
    
    self.hidden = YES;
}

- (void)interceptedEventNotification:(NSNotification *)notification
{
    UIEvent *event = notification.userInfo[VTInterceptedEventUserInfoKey];
    [self handleEvent:event];
}

@end
