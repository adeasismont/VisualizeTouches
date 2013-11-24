#import <UIKit/UIKit.h>
#import "VTTouchView.h"
#import "VTTouch.h"

/**
    Visualizes touches; either ones captured by UIApplication+interceptEvents
    or TVTouch-conforming recorded touches.
*/
/**
 * VTTouchVisualizationView
 * Visualizes touches; see VTTouchWindow for capturing touch events,
 * or VTTouch-conforming synthesized touches.
 */
@interface VTTouchVisualizationView : UIView

/**
 * Specfies how the touches should be drawn.
 * See VTTouchView.
 */
@property(nonatomic,assign) VTTouchViewType touchViewType;

/**
 * Specifies if touch paths should be drawn.
 * Default: NO
 */
@property(nonatomic,assign) BOOL shouldDrawPaths;

/**
 * Updates the touch visualization with the passed in set of touches.
 * See -[VTTouchWindow handleEvent:] for sample implementation.
 * @param touches Current visible touches
 */
- (void)updateTouchesWithVisibleTouches:(NSSet *)touches;

@end

/**
 * VTTouch compliance for UITouch.
 */
@interface UITouch (VTTouchCompliance) <VTTouch>
@end