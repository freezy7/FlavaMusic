//
//  FMScrollHeaderItemView.m
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/10.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMScrollHeaderItemView.h"

@interface FMScrollHeaderItemView ()
{
    UIView *_itemView, *_itemSubView;
    
    UIDynamicAnimator *_animator;
    
    UICollisionBehavior *_collisonBehavior;
}

@end

@implementation FMScrollHeaderItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _itemView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, self.frame.size.height - 20)];
        _itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _itemView.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:_itemView];
        
        _itemSubView = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 50, 50)];
        _itemSubView.backgroundColor = [UIColor redColor];
        [_itemView addSubview:_itemSubView];
    }
    return self;
}

@end
