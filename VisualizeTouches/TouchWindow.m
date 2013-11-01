#import "TouchWindow.h"

@implementation TouchWindow
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
    _touchView = [[TouchVisualizationView alloc] initWithFrame:self.bounds];
    [self addSubview:_touchView];
    
    return self;
}
@end
