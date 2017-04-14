//
//  CKSlideDeleteTableView.m
//  CLCommon
//
//  Created by Kent on 13-12-6.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKSlideDeleteTableView.h"
#import "BPUIViewAdditions.h"
#import "CKCoreUtil.h"
#import <objc/runtime.h>

const static CGFloat kDeleteBtnWidth = 80.f;
const static CGFloat kDeleteBtnHeight = 44.f;

#define screenWidth() (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)?[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height)

const static char * CKSlideDeleteTableViewIndexPathKey = "CKSlideDeleteTableViewIndexPathKey";

@interface UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPath;

@end

@implementation UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, CKSlideDeleteTableViewIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath
{
    id obj = objc_getAssociatedObject(self, CKSlideDeleteTableViewIndexPathKey);
    if ([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}

@end

@interface CKSlideDeleteTableView () <UIGestureRecognizerDelegate> {
    UISwipeGestureRecognizer *_leftSwipe, *_rightSwipe;
    UITapGestureRecognizer *_tap;
    UIButton *_deleteBtn;
    
    NSIndexPath *_editingIndexPath;
}

@end

@implementation CKSlideDeleteTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        _leftSwipe.delegate = self;
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_leftSwipe];
        
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        _rightSwipe.delegate = self;
        _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightSwipe];
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tap.delegate = self;
        [self addGestureRecognizer:_tap];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(screenWidth(), 0, kDeleteBtnWidth, kDeleteBtnHeight);
        _deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
   return [self initWithFrame:frame style:UITableViewStylePlain];
}

#pragma mark - Actions

- (void)swipeAction:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [self cellIndexPathForGestureRecognizer:gestureRecognizer];
    if (!indexPath) return;
    if (![self.dataSource tableView:self canEditRowAtIndexPath:indexPath]) return;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (gestureRecognizer==_leftSwipe&&![_editingIndexPath isEqual:indexPath]) {
        [self setEditing:YES atIndexPath:indexPath cell:cell];
    } else if (gestureRecognizer==_rightSwipe&&[_editingIndexPath isEqual:indexPath]) {
        [self setEditing:NO atIndexPath:indexPath cell:cell];
    }
}

- (void)tapAction:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (_editingIndexPath) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    } else {
        [self.delegate tableView:self didSelectRowAtIndexPath:[self cellIndexPathForGestureRecognizer:gestureRecognizer]];
    }
}

- (void)deleteItemAction:(UIButton *)button
{
    NSIndexPath * indexPath = button.indexPath;
    
    [self.dataSource tableView:self commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    _editingIndexPath = nil;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = _deleteBtn.frame;
        _deleteBtn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    } completion:^(BOOL finished) {
        CGRect frame = _deleteBtn.frame;
        _deleteBtn.frame = CGRectMake(screenWidth(), frame.origin.y, frame.size.width, kDeleteBtnHeight);
    }];
}

#pragma mark - Private Method

- (void)setEditing:(BOOL)editing atIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell
{
    if (editing) {
        if (_editingIndexPath) {
            UITableViewCell *editingCell = [self cellForRowAtIndexPath:_editingIndexPath];
            [self setEditing:NO atIndexPath:_editingIndexPath cell:editingCell];
            
        }
        [self addGestureRecognizer:_tap];
    } else {
        [self removeGestureRecognizer:_tap];
    }
    
    CGRect frame = cell.frame;
    CGFloat cellXOffset;
    CGFloat deleteBtnXOffsetOld;
    CGFloat deleteBtnXOffset;
    
    if (editing) {
        cellXOffset = -kDeleteBtnWidth;
        deleteBtnXOffset = screenWidth()-kDeleteBtnWidth;
        deleteBtnXOffsetOld = screenWidth();
        _editingIndexPath = indexPath;
    } else {
        cellXOffset = 0.0f;
        deleteBtnXOffset = screenWidth();
        deleteBtnXOffsetOld = screenWidth()-kDeleteBtnWidth;
        _editingIndexPath = nil;
    }
    
    CGFloat cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    _deleteBtn.frame = CGRectMake(deleteBtnXOffsetOld, frame.origin.y, _deleteBtn.width, cellHeight);
    
    _deleteBtn.indexPath = indexPath;
    [UIView animateWithDuration:.2f animations:^{
        cell.frame = CGRectMake(cellXOffset, frame.origin.y, frame.size.width, frame.size.height);
        _deleteBtn.frame = CGRectMake(deleteBtnXOffset, frame.origin.y, _deleteBtn.width, cellHeight);
    }];
}

- (NSIndexPath *)cellIndexPathForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if (![view isKindOfClass:[UITableView class]]) {
        return nil;
    }
    CGPoint point = [gestureRecognizer locationInView:view];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:point];
    return indexPath;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([CKCoreUtil systemBigThan7]) {
        return YES;
    } else {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || gestureRecognizer == _leftSwipe || gestureRecognizer == _rightSwipe || gestureRecognizer == _tap) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return ![touch.view isKindOfClass:[UIButton class]];
}

@end
