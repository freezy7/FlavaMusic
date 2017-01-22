//
//  FMRefreshHeaderView.h
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/20.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRefreshHeaderView : UIView
{
    @protected
    CGFloat _defaultContentHeight;
}

@property (nonatomic) UIEdgeInsets defaultContentInset;

- (void)refreshHeaderViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshHeaderViewDidEndDragging:(UIScrollView *)scrollView;

@end
