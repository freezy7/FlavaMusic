//
//  FMRefreshAnimationView.h
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/20.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRefreshAnimationView : UIView

@property (nonatomic) BOOL isAnimation;

- (void)AnimationViewDidAnimationWithScrollView:(UIScrollView *)scrollView;

- (void)startFlipAnimation;

- (void)stopAnimation;

@end
