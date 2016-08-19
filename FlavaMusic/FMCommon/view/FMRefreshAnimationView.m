//
//  FMRefreshAnimationView.m
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/20.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMRefreshAnimationView.h"

@interface FMRefreshAnimationView ()
{
    UIImageView *_aniImageView, *_animationView1, *_animationView2;
    
    CGFloat _defaultHeight;
    
}

@end

@implementation FMRefreshAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        _defaultHeight = 64;
        
        _aniImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 36)/2.0f, (self.frame.size.height - 34)/2.0f - 17, 36, 34)];
        _aniImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _aniImageView.image = [UIImage imageNamed:@"refresh_header_ani_0"];
        [self addSubview:_aniImageView];
        
        _animationView1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 36)/2.0f, (self.frame.size.height - 34)/2.0f - 17, 36, 34)];
        _animationView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _animationView1.image = [UIImage imageNamed:@"refresh_header_ani_1"];
        _animationView1.layer.anchorPoint = CGPointMake(0.5, 0);
        
        _animationView2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 36)/2.0f, (self.frame.size.height - 34)/2.0f - 17, 36, 34)];
        _animationView2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _animationView2.image = [UIImage imageNamed:@"refresh_header_ani_2"];
        _animationView2.layer.anchorPoint = CGPointMake(0.5, 0);
        
        _aniImageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _aniImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return self;
}

- (void)AnimationViewDidAnimationWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY + 64 > 0) {
            CGFloat scale = -offsetY/64;
            scale = MAX(0.5, scale);
            _aniImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)startFlipAnimation
{
    _isAnimation = YES;
    [UIView transitionFromView:_aniImageView toView:_animationView1 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        [UIView transitionFromView:_animationView1 toView:_animationView2 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [UIView transitionFromView:_animationView2 toView:_aniImageView duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
                if (_isAnimation) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startFlipAnimation) object:nil];
                    [self performSelector:@selector(startFlipAnimation) withObject:nil];
                }
            }];
        }];
    }];
}

- (void)stopAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startFlipAnimation) object:nil];
    _isAnimation = NO;
}


@end
