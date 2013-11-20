#import "TouchVisualizationView.h"
#import "TouchView.h"
#import "TouchesPathView.h"
#import "SPFunctional.h"


@interface TouchVisualizationView ()
@property(nonatomic,strong) NSMutableDictionary *touchViews;
@property(nonatomic,strong) NSMutableArray *orderedTouchViews;
@end

@implementation TouchVisualizationView

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
    for (id<TVTouch> touch in touches) {
        id<NSCopying> key = [touch tv_touchKey];
        NSDictionary *value = self.touchViews[key];
        
        if (touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded) {
            [self removeKey:key];
        } else {
            TouchView *touchView = [value[@"touch"] pointerValue];
            TouchesPathView *pathView = [value[@"path"] pointerValue];
            
            if (!value) {
                touchView = [TouchView new];
                touchView.type = self.touchViewType;
                
                if (self.shouldDrawPaths)
                    pathView = [[TouchesPathView alloc] initWithFrame:self.bounds];
                
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
    [keys minusSet:[touches sp_map:^(id<TVTouch> touch) {
        return [touch tv_touchKey];
    }]];
    
    for (NSValue *key in keys)
        [self removeKey:key];
    
    // update index numbers on touch views
    NSInteger index = 1;
    for (NSValue *value in self.orderedTouchViews) {
        TouchView *view = (TouchView *)[value pointerValue];
        view.touchNumber = index++;
    }
}


#pragma mark - Internal

- (void)removeKey:(id<NSCopying>)key
{
    NSDictionary *value = self.touchViews[key];
    if (!value)
        return;
    
    TouchView *touchView = [value[@"touch"] pointerValue];
    UIView *pathView = [value[@"path"] pointerValue];
    
    [self.orderedTouchViews removeObject:value[@"touch"]];
    [self.touchViews removeObjectForKey:key];
    
    [touchView remove];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [pathView setAlpha:0.f];
                     }
                     completion:^(BOOL finished) {
                         [pathView removeFromSuperview];
                     }];
}

@end

@implementation UITouch (TVTouchCompliance)
- (id<NSCopying>)tv_touchKey
{
    return [NSValue valueWithNonretainedObject:self];
}
@end