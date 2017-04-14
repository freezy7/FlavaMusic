//
//  CKUIView+Animation.h
//  CarMaintenance
//
//  Created by Kent on 13-7-9.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKUIView+Animation.h"
#import "BPUIViewAdditions.h"
#import "CKCoreUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (animation)

- (void)startRotateAnimation
{
	[self startRotateAnimation:1.0f];
}

-(void)startKeyframeAnimationWithImages:(NSArray *)images
{
    [self startKeyframeAnimationWithImages:images duration:2.0f repeatCount:HUGE_VALF];
}

-(void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration
{
    [self startKeyframeAnimationWithImages:images duration:duration repeatCount:HUGE_VALF];
}

-(void)startKeyframeAnimationWithImages:(NSArray *)images duration:(CFTimeInterval)duration repeatCount:(float)repeatCount
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = duration;
    animation.values = images;
    animation.repeatCount = repeatCount;
    [self.layer addAnimation:animation forKey:@"animation"];
}
- (void)startRotateAnimation:(CGFloat)duration
{
	CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
	theAnimation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0, 1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0, 0, 1)],
						   nil];
	theAnimation.cumulative = YES;
	theAnimation.duration = duration;
	theAnimation.repeatCount = HUGE_VALF;
	theAnimation.removedOnCompletion = YES;
	[self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)startFadeAnimation
{
	[self startFadeAnimation:1.0f];
}

- (void)startFadeAnimation:(CGFloat)duration
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:@(0.0f), @(1.0f), @(1.0f), @(0.0f), nil];
    theAnimation.cumulative = YES;
    theAnimation.duration = duration;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:theAnimation forKey:@"opacity"];
}

- (void)startPushFadeTransition
{
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
	[self.layer addAnimation:animation forKey:@"fade"];
}

- (void)startPushTransitionFromRight
{
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
	[animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
	[self.layer addAnimation:animation forKey:@"push"];
}

- (void)stopAllAnimation
{
    [self.layer removeAllAnimations];
}

- (void)startAnimationWithArray:(NSArray *)array
{
    [self startAnimationWith:array andIndex:0];
}

- (void)startMoveDistance:(NSString *)dis
{
    float distance = [dis floatValue];
    self.left+=distance;
    self.alpha = 1.0;
    [UIView animateWithDuration:18/25.f
                          delay:0.f
                        options:UIViewAnimationOptionOverrideInheritedCurve|UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.left-=distance;
                     } completion:^(BOOL finished) {
                         
                     }];
}

/**
 此方法用于多次反复缩放动画
 array 中的元素为字典，字典包含两个key : time and scale
 */
- (void)startAnimationWith:(NSArray *)array andIndex:(int)index
{
    if (index==0) {
        self.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
        self.alpha = 1.f;
    }
    if (index<array.count) {
        NSDictionary *dic = array[index];
        index++;
        [UIView animateWithDuration:[dic[@"time"] floatValue] animations:^{
            self.transform = CGAffineTransformMakeScale([dic[@"scale"] floatValue], [dic[@"scale"] floatValue]);
        } completion:^(BOOL finished) {
            [self startAnimationWith:array andIndex:index];
        }];
    }
}

- (void)startUpDownTranslationAnimation:(CGFloat)move duration:(CGFloat)duration
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y+move)];
    translation.duration = duration;
    translation.repeatCount = HUGE_VALF;
    translation.autoreverses = YES;
    [self.layer addAnimation:translation forKey:@"translation"];
}

- (void)startLeftTranslationAnimation:(CGFloat)move duration:(CGFloat)duration
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - move, self.center.y)];
    translation.duration = duration;
    translation.repeatCount = HUGE_VALF;
    translation.autoreverses = NO;
    [self.layer addAnimation:translation forKey:@"translation"];
}

- (void)startShakeAnimation
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/32, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/32, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/16, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/16, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/32, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/32, 0, 0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = 1.2;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.autoreverses = YES;
    self.layer.shouldRasterize = YES;//抗锯齿
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

- (void)startShakeAnimationWithDuration:(double)duration
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/100.f, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/100.f, 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.calculationMode = kCAAnimationLinear;
    theAnimation.duration = duration;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.autoreverses = YES;
    self.layer.shouldRasterize = YES;//抗锯齿
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}

@end

@implementation UITableViewCell (animation)

- (void)startDisplayAnimation
{
    if ([CKCoreUtil systemBigThan7]) {
        self.layer.opacity = 0.0f;
        self.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(1.1f, 1.1f, 1.0f), 0, 15.0f, 0);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6f];
        self.layer.transform = CATransform3DIdentity;
        self.layer.opacity = 1.0f;
        [UIView commitAnimations];
    }
}

@end