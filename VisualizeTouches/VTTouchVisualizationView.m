#import "VTTouchVisualizationView.h"
#import "VTTouchView.h"
#import "VTTouchesPathView.h"
#import "SPFunctional.h"


@interface VTTouchVisualizationView ()
@property(nonatomic,strong) NSMutableDictionary *touchViews;
@property(nonatomic,strong) NSMutableArray *orderedTouchViews;
@end

@implementation VTTouchVisualizationView

- (id)initWithFrame:(CGRect)frame
{
    return [[super initWithFrame:frame] commonInit];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [[super initWithCoder:aDecoder] commonInit];
}

- (id)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    self.touchViews = [[NSMutableDictionary alloc] init];
    self.orderedTouchViews = [[NSMutableArray alloc] init];
    
    return self;
}


#pragma mark - Public

- (void)updateTouchesWithVisibleTouches:(NSSet *)touches
{
    // iterate touches
    for (id<VTTouch> touch in touches) {
        id<NSCopying> key = [touch vt_touchKey];
        NSDictionary *value = self.touchViews[key];
        
        if (touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded) {
            [self removeKey:key];
        } else {
            VTTouchView *touchView = [value[@"touch"] pointerValue];
            VTTouchesPathView *pathView = [value[@"path"] pointerValue];
            
            if (!value) {
                touchView = [[VTTouchView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                touchView.type = self.touchViewType;
                
                if (self.shouldDrawPaths)
                    pathView = [[VTTouchesPathView alloc] initWithFrame:self.bounds];
                
                [self insertSubview:pathView atIndex:0];
                [self addSubview:touchView];
                
                self.touchViews[key] = @{
                    @"touch": [NSValue valueWithPointer:(__bridge const void *)touchView],
                    @"path": [NSValue valueWithPointer:(__bridge const void *)pathView]
                };
                
                [self.orderedTouchViews addObject:[NSValue valueWithPointer:(__bridge  const void *)touchView]];
            }
            
            CGPoint location = [touch locationInView:self];
            touchView.center = location;
            [pathView addLocation:location];
        }
    }
    
    // remove no longer present touches (a bug in iOS)
    NSMutableSet *keys = [NSMutableSet setWithArray:[self.touchViews allKeys]];
    [keys minusSet:[touches sp_map:^(id<VTTouch> touch) {
        return [touch vt_touchKey];
    }]];
    
    for (NSValue *key in keys)
        [self removeKey:key];
    
    // update index numbers on touch views
    NSInteger index = 1;
    for (NSValue *value in self.orderedTouchViews) {
        VTTouchView *view = (VTTouchView *)[value pointerValue];
        view.touchNumber = index++;
    }
}


#pragma mark - Internal

- (void)removeKey:(id<NSCopying>)key
{
    NSDictionary *value = self.touchViews[key];
    if (!value)
        return;
    
    UIView *touchView = [value[@"touch"] pointerValue];
    UIView *pathView = [value[@"path"] pointerValue];
    
    [self.orderedTouchViews removeObject:value[@"touch"]];
    [self.touchViews removeObjectForKey:key];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         touchView.alpha = 0.0;
                         pathView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [touchView removeFromSuperview];
                         [pathView removeFromSuperview];
                     }];
}

@end

@implementation UITouch (VTTouchCompliance)
- (id<NSCopying>)vt_touchKey
{
    return [NSValue valueWithNonretainedObject:self];
}
@end