#import <UIKit/UIKit.h>
#import "VTTouchVisualizationView.h"

/*
    Uses a TouchVisualizationView to overlay the app with touches.
*/
@interface TouchWindow : UIWindow
@property(nonatomic,readonly) VTTouchVisualizationView *touchView;
- (id)init;
@end
