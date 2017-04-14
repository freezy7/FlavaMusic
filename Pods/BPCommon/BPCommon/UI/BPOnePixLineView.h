//
//  BPOnePixLineView.h
//  BPCommon
//
//  Created by Huang Tao on 2/25/14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    BPOnePixLineModeHorizontal = 0,
    BPOnePixLineModeVertical,
}BPOnePixLineMode;

typedef enum {
    BPOnePixLineDirectionBottomOrRight = 0,
    BPOnePixLineDirectionTopOrLeft,
}BPOnePixLineDirection;

@interface BPOnePixLineView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) BPOnePixLineMode mode;
@property (nonatomic) BPOnePixLineDirection direction;

@end
