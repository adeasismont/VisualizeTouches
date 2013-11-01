#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TouchViewType) {
    TouchViewCircleType = 0,
    TouchViewCrosshairType
};

@interface TouchView : UIView

@property(nonatomic,assign) TouchViewType type; // default: TouchViewCircleType
@property(nonatomic,assign) NSInteger touchNumber; // only displayed in TouchViewCircleType

@end
