//
//  CLTopTabView.h
//  CLCommon
//
//  Created by ali on 15/1/8.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKTopTabView;
@protocol CKTopTabViewDelegate <NSObject>

- (void)topTabView:(CKTopTabView *)view didSelectAtIndex:(NSInteger)index;

@end

/**
 顶部的tabview
 中间没有竖线分隔
 宽度平均分
 没试过最大title长度和最多items数量
 */
@interface CKTopTabView : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, weak) id<CKTopTabViewDelegate> delegate;

- (void)setSelectedIndex:(NSInteger)selectedIndex withEvent:(BOOL)event;

- (void)setBadgeForIndex:(NSInteger)index;
- (void)setNumberBadge:(NSInteger)number forIndex:(NSInteger)index;
- (void)removeBadgeForIndex:(NSInteger)index;

- (void)setSelectedLineWidth:(CGFloat)width;//固定宽度
- (void)setSelectedLineGap:(CGFloat)gap;//固定间隙

@end
