#import <UIKit/UIKit.h>

/**
 * VTTouchesPathView
 * Draws the path for a touch.
 */
@interface VTTouchesPathView : UIView

/**
 * Add a touch location.
 * @param location Touch location to add to the path
 */
- (void)addLocation:(CGPoint)location;

@end
