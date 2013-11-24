#import <UIKit/UIKit.h>

/**
 * VTTouch protocol.
 * Used to create synthesized touches without having to create real UITouches.
 */
@protocol VTTouch <NSObject>

@property (nonatomic, readonly) UITouchPhase phase;

- (CGPoint)locationInView:(UIView*)view;

/// Uniquely identify this touch. For UITouch, returns NSValue with self.
- (id<NSCopying>)vt_touchKey;

@end
