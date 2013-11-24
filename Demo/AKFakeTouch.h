#import <UIKit/UIKit.h>
#import "VisualizeTouches.h"

@interface AKFakeTouch : NSObject <VTTouch>

- (id)initWithPhase:(UITouchPhase)phase point:(CGPoint)p;

@end