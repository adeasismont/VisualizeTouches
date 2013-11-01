#import "TouchesPathView.h"

@interface TouchesPathView ()
@property(nonatomic,strong) NSMutableArray *locations;
@end

@implementation TouchesPathView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.locations = [NSMutableArray array];
    
    return self;
}


#pragma mark - Public

- (void)addLocation:(CGPoint)location
{
    if ([self.locations count]) {
        CGPoint lastLocation = [[self.locations lastObject] CGPointValue];
        // don't add the location if it's the same as the last one
        if (CGPointEqualToPoint(location, lastLocation))
            return;
    }
    
    [self.locations addObject:[NSValue valueWithCGPoint:location]];
    [self setNeedsDisplay];
}


#pragma mark - View

- (void)drawRect:(CGRect)rect
{
    if ([self.locations count] < 2)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL first = YES;
    for (NSValue *value in self.locations) {
        CGPoint location = [value CGPointValue];
        
        if (first) {
            CGContextMoveToPoint(context, location.x, location.y);
            first = NO;
        } else {
            CGContextAddLineToPoint(context, location.x, location.y);
        }
    }
    
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.2] set];
    CGContextSetLineWidth(context, 3);
    CGContextStrokePath(context);
}

@end