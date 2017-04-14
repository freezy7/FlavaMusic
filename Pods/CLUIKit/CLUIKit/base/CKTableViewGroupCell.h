//
//  CKTableViewGroupCell.h
//  CLUIKit
//
//  Created by wangpeng on 16/1/9.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKTableViewCell.h"

@interface CKTableViewGroupCell : CKTableViewCell

@property (nonatomic, strong, readonly) UIImageView *topSeparatorView;
@property (nonatomic) BOOL isTopCell;

- (void)setTopSeparatorLineWithLeft:(CGFloat)left;
- (void)setTopSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right;
- (void)setTopSeparatorWithColor:(UIColor *)color;
- (void)setTopSeparatorWithImage:(UIImage *)image;

@end
