#import "TouchView.h"

@interface TouchView ()
@property(nonatomic,strong) UILabel *label;
@end

@implementation TouchView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont boldSystemFontOfSize:13];
    self.label.textColor = [UIColor blackColor];
    self.label.shadowColor = [UIColor whiteColor];
    self.label.shadowOffset = CGSizeMake(0, -1);
    [self addSubview:self.label];
    
    return self;
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
            NSLog(@"Unknown touch view type: %ld", self.type);
            break;
    }
}

- (void)drawCircleInRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [[UIColor colorWithWhite:1.0 alpha:0.75] set];
    [path fill];
    
    [[UIColor darkGrayColor] set];
    path.lineWidth = 1;
    [path stroke];
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