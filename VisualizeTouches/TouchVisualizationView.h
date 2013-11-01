#import <UIKit/UIKit.h>
#import "TouchView.h"

/**
    Visualizes touches; either ones captured by UIApplication+interceptEvents
    or TVTouch-conforming recorded touches.
*/
@interface TouchVisualizationView : UIView
@property(nonatomic,assign) TouchViewType touchViewType;
@property(nonatomic,assign) BOOL shouldDrawPaths;
- (void)updateTouchesWithVisibleTouches:(NSSet *)touches;
@end

/** The TVTouch protocol exists so that you can play back recorded touches
    or other synthesized touches without having to create real UITouches */
@protocol TVTouch <NSObject>
@property(nonatomic,readonly) UITouchPhase        phase;
- (CGPoint)locationInView:(UIView*)view;
/// Uniquely identify this touch. For UITouch, returns NSValue with self.
- (id<NSCopying>)tv_touchKey;
@end

@interface UITouch (TVTouchCompliance) <TVTouch>
@end