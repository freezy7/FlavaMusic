//
//  CKUIView+Animation.h
//  CarMaintenance
//
//  Created by Kent on 13-7-9.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (animation)

- (void)startPushTransitionFromRight;
- (void)startPushFadeTransition;
- (void)startRotateAnimation;
- (void)startFadeAnimation;
- (void)startFadeAnimation:(CGFloat)duration;
- (void)startRotateAnimation:(CGFloat)duration;

- (void)startKeyframeAnimationWithImages:(NSArray *)images;
- (void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration;
- (void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration repeatCount:(float)repeatCount;

- (void)stopAllAnimation;

- (void)startAnimationWithArray:(NSArray *)array;
- (void)startMoveDistance:(NSString *)dis;

- (void)startUpDownTranslationAnimation:(CGFloat)move duration:(CGFloat)duration;
- (void)startLeftTranslationAnimation:(CGFloat)move duration:(CGFloat)duration;

//抖动
- (void)startShakeAnimation;
- (void)startShakeAnimationWithDuration:(double)duration;

@end

@interface UITableViewCell (animation)

- (void)startDisplayAnimation;

@end