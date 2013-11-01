#import <UIKit/UIKit.h>
#import "TouchVisualizationView.h"

/*
    Uses a TouchVisualizationView to overlay the app with touches.
*/
@interface TouchWindow : UIWindow
@property(nonatomic,readonly) TouchVisualizationView *touchView;
- (id)init;
@end
