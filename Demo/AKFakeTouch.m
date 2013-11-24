#import "AKFakeTouch.h"

@interface AKFakeTouch ()

@property(nonatomic) UITouchPhase phase;
@property(nonatomic) CGPoint point;

@end

@implementation AKFakeTouch

- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p
{
    if(!(self = [super init]))
        return nil;
    
    _phase = phase;
    _point = p;
    
    return self;
}

- (id<NSCopying>)vt_touchKey
{
    return [NSValue valueWithNonretainedObject:self];
}

- (CGPoint)locationInView:(UIView*)view
{
    return self.point;
}

@end
