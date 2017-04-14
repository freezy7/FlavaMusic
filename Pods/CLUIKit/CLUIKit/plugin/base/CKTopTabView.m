//
//  CLTopTabView.m
//  CLCommon
//
//  Created by ali on 15/1/8.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "CKTopTabView.h"
#import "BPOnePixLineView.h"
#import "CKBadgeButton.h"
#import "BPCoreUtil.h"
#import "BPUIViewAdditions.h"

@interface CKTopTabView () {
    NSMutableArray *_itemViews;
    BOOL _fixedSelectLineWidth;
    BOOL _fixedSelectLineGap;
    
    CGFloat _selectLineGap;
    
    BOOL _isAnimated;
}

@property (nonatomic, strong) UIView *selectedLine;

@end

@implementation CKTopTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemViews = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        
        BPOnePixLineView *bottomLine = [[BPOnePixLineView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        bottomLine.lineColor = [BPCoreUtil colorWithHexString:@"dddddd"];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:_itemViews];
    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemViews removeAllObjects];

    CGFloat width = ceilf(self.width / _items.count);
    for (NSInteger i = 0; i < _items.count; i++) {
        CKBadgeButton *button = [[CKBadgeButton alloc] initWithFrame:CGRectMake(width * i, 0, width, self.height)];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        if (i == 0) {
            [button setTitleColor:[BPCoreUtil colorWithHexString:@"39acff"] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[BPCoreUtil colorWithHexString:@"828892"] forState:UIControlStateNormal];
        }
        [button setTitle:_items[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_itemViews addObject:button];
    }
    self.selectedLine.width = width;
}

- (UIView *)selectedLine
{
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 2, 0, 2)];
        _selectedLine.backgroundColor = [BPCoreUtil colorWithHexString:@"39acff"];
        [self addSubview:_selectedLine];
    }
    [self bringSubviewToFront:_selectedLine];
    return _selectedLine;
}

- (CKBadgeButton *)itemWithIndex:(NSInteger)index
{
    if (index<_itemViews.count) {
        return _itemViews[index];
    }
    return nil;
}

- (void)setSelectedLineWidth:(CGFloat)width
{
    _fixedSelectLineGap = NO;
    _fixedSelectLineWidth = YES;
    _selectedLine.width = width;
    UIButton *btn = [self itemWithIndex:_selectedIndex];
    if (btn) {
        _selectedLine.frame = CGRectMake(btn.width/2-_selectedLine.width/2, _selectedLine.top, _selectedLine.width, _selectedLine.height);
    }
}

- (void)setSelectedLineGap:(CGFloat)gap
{
    _fixedSelectLineWidth = NO;
    _fixedSelectLineGap = YES;
    UIButton *btn = [self itemWithIndex:_selectedIndex];
    if (btn) {
        _selectedLine.frame = CGRectMake(_selectLineGap, _selectedLine.top, btn.width-_selectLineGap*2, _selectedLine.height);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex withEvent:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withEvent:(BOOL)event
{
    if (selectedIndex + 1 > _items.count || selectedIndex == _selectedIndex || _isAnimated) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    _isAnimated = YES;
    [UIView animateWithDuration:.25f animations:^{
        UIButton *btn = [self itemWithIndex:selectedIndex];
        if (btn) {
            if (_fixedSelectLineWidth) {
                _selectedLine.frame = CGRectMake(btn.left+(btn.width/2-_selectedLine.width/2), _selectedLine.top, _selectedLine.width, _selectedLine.height);
            } else if (_fixedSelectLineGap) {
                _selectedLine.frame = CGRectMake(btn.left+_selectLineGap, _selectedLine.top, btn.width-_selectLineGap*2, _selectedLine.height);
            } else {
                _selectedLine.frame = CGRectMake(btn.left, _selectedLine.top, btn.width, _selectedLine.height);
            }
        } else {
            self.selectedLine.left = _selectedIndex * self.selectedLine.width;
        }
    } completion:^(BOOL finished) {
        for (UIButton *button in _itemViews) {
            if (button.tag - 1000 == _selectedIndex) {
                [button setTitleColor:[BPCoreUtil colorWithHexString:@"39acff"] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[BPCoreUtil colorWithHexString:@"828892"] forState:UIControlStateNormal];
            }
        }
        if (event) {
            [_delegate topTabView:self didSelectAtIndex:_selectedIndex];
        }
        _isAnimated = NO;
    }];
}

- (void)setBadgeForIndex:(NSInteger)index
{
    if (_itemViews.count < index + 1) {
        return;
    }
    CKBadgeButton *button = _itemViews[index];
    button.showBadge = YES;
}

- (void)setNumberBadge:(NSInteger)number forIndex:(NSInteger)index
{
    if (_itemViews.count < index + 1) {
        return;
    }
    CKBadgeButton *button = _itemViews[index];
    button.badgeNumber = number;
    button.showNumberBadge = YES;
}

- (void)removeBadgeForIndex:(NSInteger)index
{
    if (_itemViews.count < index + 1) {
        return;
    }
    CKBadgeButton *button = _itemViews[index];
    button.showBadge = NO;
    button.showNumberBadge = NO;
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag - 1000;
    self.selectedIndex = index;
    [self removeBadgeForIndex:index];
}

@end
