//
//  FMScrollHeaderCell.m
//  FlavaMusic
//
//  Created by R_style_Man on 16/8/10.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMScrollHeaderCell.h"
#import "FMScrollHeaderItemView.h"

@interface FMScrollHeaderCell ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollContenView;
    
    UIDynamicAnimator *_animator;
    
    UICollisionBehavior *_collisionBehavior;
    
    UIAttachmentBehavior *_attachmentBehavior;
    
    NSMutableArray *_itemViews;
}

@end

@implementation FMScrollHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _itemViews = [NSMutableArray array];
        
        _scrollContenView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollContenView.delegate = self;
        _scrollContenView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollContenView.backgroundColor = [UIColor orangeColor];
//        _scrollContenView.pagingEnabled = YES;
        
        [self.contentView addSubview:_scrollContenView];
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_scrollContenView];
        
        _collisionBehavior = [[UICollisionBehavior alloc] init];
        _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        //Need to add item behavior specific to this
        UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] init];
        itemBehavior.elasticity = 1;
        //Add it as a child behavior
        [_collisionBehavior addChildBehavior:itemBehavior];
        
        [_animator addBehavior:_collisionBehavior];
        
        for (int i = 0; i< 4; i++) {
            FMScrollHeaderItemView *itemView = [[FMScrollHeaderItemView alloc] initWithFrame:CGRectMake(_scrollContenView.frame.size.width*i + 20, 10, _scrollContenView.frame.size.width - 40, _scrollContenView.frame.size.height - 20)];
            itemView.tag = 100 + i;
            itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_scrollContenView addSubview:itemView];
            
            [_itemViews addObject:itemView];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollContenView.contentSize = CGSizeMake(self.contentView.frame.size.width * 4, self.contentView.frame.size.height);
    
    for (int i = 0; i < _itemViews.count; i++) {
        FMScrollHeaderItemView *itemView = [_itemViews objectAtIndex:i];
        itemView.frame = CGRectMake(_scrollContenView.frame.size.width*i + 20, 10, _scrollContenView.frame.size.width - 40, _scrollContenView.frame.size.height - 20);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    
    NSInteger index = contentOffset.x/scrollView.bounds.size.width;
    
    index = MIN(index, 3);
    
    index = MAX(index, 0);
    
    FMScrollHeaderItemView *itemView = [_itemViews objectAtIndex:index];
    
    [_collisionBehavior addItem:itemView];
    
    UIAttachmentBehavior* attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:itemView attachedToAnchor:itemView.center];
    attachmentBehavior.damping = 0.5;
    attachmentBehavior.frequency = 0.8;
    attachmentBehavior.length = 0;
    
    [_animator addBehavior:attachmentBehavior];
    
    if (index == 3) {
        return;
    }
    
    FMScrollHeaderItemView *itemView2 = [_itemViews objectAtIndex:MIN(index + 1, 3)];
    
    [_collisionBehavior addItem:itemView2];
    
    UIAttachmentBehavior* attachmentBehavior2 = [[UIAttachmentBehavior alloc] initWithItem:itemView attachedToAnchor:itemView2.center];
    attachmentBehavior2.damping = 0.5;
    attachmentBehavior2.frequency = 0.8;
    attachmentBehavior2.length = 0;
    
    [_animator addBehavior:attachmentBehavior2];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

@end
