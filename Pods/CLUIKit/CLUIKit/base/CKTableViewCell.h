//
//  CKTableViewCell.h
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CKTableViewCellStyleCommon,
    CKTableViewCellStyleBottom,
} CKTableViewCellBaseStyle;

@interface CKTableViewCell : UITableViewCell

@property (nonatomic) CKTableViewCellBaseStyle cellBaseStyle;

@property (nonatomic, strong, readonly) UIImageView *separatorView;
@property (nonatomic, readonly) BOOL isShowArrow;

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setSeparatorLineWithLeft:(CGFloat)left;//左右缩进相等
- (void)setSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right;
- (void)setSeparatorWithColor:(UIColor *)color;
- (void)setSeparatorWithImage:(UIImage *)image;

- (UIImageView *)createArrowImage;//若不使用默认箭头，可在子类实现
- (void)setArrowWithLeft:(CGFloat)left;//when need arrow
- (void)setArrowWithTopOffset:(CGFloat)offset;
- (void)setArrowFrame:(CGRect)frame;
- (void)showArrow:(BOOL)show;
- (BOOL)hasArrow;

@end
