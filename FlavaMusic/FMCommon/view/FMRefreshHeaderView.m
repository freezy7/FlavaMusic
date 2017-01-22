//
//  FMRefreshHeaderView.m
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/20.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMRefreshHeaderView.h"
#import "FMRefreshAnimationView.h"

@interface FMRefreshHeaderView ()
{
    FMRefreshAnimationView *_animationView;
}

@end

@implementation FMRefreshHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultContentHeight = 64.0;
        self.backgroundColor = [UIColor clearColor];
        
        _animationView = [[FMRefreshAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _defaultContentHeight)];
        
    }
    return self;
}

- (void)didMoveToWindow
{
    [self.superview.superview insertSubview:_animationView belowSubview:self.superview];
}

- (void)refreshHeaderViewDidScroll:(UIScrollView *)scrollView
{
    [_animationView AnimationViewDidAnimationWithScrollView:scrollView];
}

- (void)refreshHeaderViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -64 && !_animationView.isAnimation) {
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [_animationView startFlipAnimation];
        [self performSelector:@selector(stopRefresh:) withObject:scrollView afterDelay:5];
    }
}

- (void)stopRefresh:(UIScrollView *)scrollView
{
    
    [UIView animateWithDuration:0.25 animations:^{
        _animationView.alpha = 0;
        scrollView.contentInset = _defaultContentInset;
        [_animationView stopAnimation];
    } completion:^(BOOL finished) {
        _animationView.alpha = 1.0f;
    }];
}

@end
