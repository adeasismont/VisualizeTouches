#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VTTouchViewType) {
    VTTouchViewCircleType = 0,
    VTTouchViewCrosshairType
};

@interface VTTouchView : UIView

@property(nonatomic,assign) VTTouchViewType type; // default: TouchViewCircleType
@property(nonatomic,assign) NSInteger touchNumber; // only displayed in TouchViewCircleType

@end
