#import "TouchView.h"

@interface TouchView ()
@property(nonatomic,strong) UILabel *label;
@end

@implementation TouchView

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.alpha = 0.f;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont boldSystemFontOfSize:13];
        self.label.textColor = [UIColor blackColor];
        self.label.shadowColor = [UIColor whiteColor];
        self.label.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:self.label];
    }
    return self;
}

- (void)didMoveToSuperview {
    if ([self superview] != nil) {
        CGRect finalFrame = [self frame];
        [self setFrame:CGRectInset([self frame],
                                   CGRectGetWidth([self frame])/2,
                                   CGRectGetHeight([self frame])/2)];
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [self setFrame:finalFrame];
                             [self.label setAlpha:1.f];
                         }
                         completion:^(BOOL finished) {
                             ;
                         }];
    }
}

- (void)remove {
    CGRect newTouchFrame = CGRectInset([self frame],
                                       CGRectGetWidth([self frame])/2,
                                       CGRectGetHeight([self frame])/2);
    [UIView animateWithDuration:.2f
                     animations:^{
                         [self setFrame:newTouchFrame];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Accessors

- (NSInteger)touchNumber
{
    return [self.label.text integerValue];
}

- (void)setTouchNumber:(NSInteger)touchNumber
{
    self.label.text = [@(touchNumber) stringValue];
}

- (void)setType:(TouchViewType)type
{
    if (_type == type)
        return;
    
    _type = type;
    
    self.label.hidden = (_type != TouchViewCircleType);
    
    [self setNeedsDisplay];
}


#pragma mark - View

- (void)drawRect:(CGRect)rect
{
    switch (self.type) {
        case TouchViewCircleType:
            [self drawCircleInRect:rect];
            break;
        case TouchViewCrosshairType:
            [self drawCrosshairInRect:rect];
            break;
        default:
            NSLog(@"Unknown touch view type: %d", self.type);
            break;
    }
}

- (void)drawCircleInRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [[UIColor colorWithRed:1.f
                     green:234.f/255.f
                      blue:193.f/255.f
                     alpha:.3f] setFill];
    [path fill];
}

- (void)drawCrosshairInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextSaveGState(context); {
        [[UIColor whiteColor] set];
        CGContextTranslateCTM(context, 1, 1);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    [[UIColor darkGrayColor] set];
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGPathRelease(path);
}

@end