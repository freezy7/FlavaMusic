//
//  CKTableViewCell.m
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableViewCell.h"
#import "CKStaticImageManager.h"
#import "BPCoreUtil.h"
#import "CKCoreUtil.h"
#import "BPUIViewAdditions.h"
#import "CKUIManager.h"

@interface CKTableViewCell () {
    UIImageView *_arrow;
}

@end

@implementation CKTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = nil;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        for (UIView *view in self.subviews) {
            view.clipsToBounds = NO;
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bgView;
        
        // 选中背景
        UIView *selBgView = [[UIView alloc] initWithFrame:self.bounds];
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(cellSelectedBackgroundViewColor)] && [[CKUIManager sharedManager] cellSelectedBackgroundViewColor]) {
            selBgView.backgroundColor = [[CKUIManager sharedManager] cellSelectedBackgroundViewColor];
        } else {
            selBgView.backgroundColor = [BPCoreUtil colorWithHexString:@"eeeeee" alpha:1];
        }
        self.selectedBackgroundView = selBgView;
        
        _separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(11.f, self.height-[CKCoreUtil screenOnePixel], 298.f,[CKCoreUtil screenOnePixel])];
        _separatorView.contentMode = UIViewContentModeScaleToFill;
        _separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(cellSeparatorLineColor)] && [[CKUIManager sharedManager] cellSeparatorLineColor]) {
            _separatorView.backgroundColor = [[CKUIManager sharedManager] cellSeparatorLineColor];
        } else {
            _separatorView.backgroundColor = [BPCoreUtil colorWithHexString:@"dcdcdc" alpha:1];
        }
        [self.backgroundView addSubview:_separatorView];
        
        if ([CKCoreUtil systemBigThan8]) {
            self.width = self.contentView.width = [UIScreen mainScreen].bounds.size.width;
        }
    }
    return self;
}

- (void)setSeparatorLineWithLeft:(CGFloat)left
{
    _separatorView.frame = CGRectMake(left, self.backgroundView.height-[CKCoreUtil screenOnePixel], self.backgroundView.width-left*2, [CKCoreUtil screenOnePixel]);
}

- (void)setSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right
{
    _separatorView.frame = CGRectMake(left, self.backgroundView.height-[CKCoreUtil screenOnePixel], self.backgroundView.width-left-right, [CKCoreUtil screenOnePixel]);
}

- (void)setSeparatorWithColor:(UIColor *)color
{
    _separatorView.image = [CKCoreUtil imageWithColor:color];
}

- (void)setSeparatorWithImage:(UIImage *)image
{
    _separatorView.image = image;
}

- (BOOL)hasArrow
{
    if (_arrow == nil) {
        return NO;
    } else {
        if (_arrow.hidden) {
            return NO;
        }
        return YES;
    }
}

- (UIImageView *)createArrowImage
{
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.width-15-6, floorf((self.contentView.height-12)/2), 6, 12)];
    arrow.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    arrow.image = [UIImage imageNamed:@"CLUIKit.bundle/cell_arrow"];
    return arrow;
}

- (void)setArrowWithLeft:(CGFloat)left
{
    if (_arrow==nil) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    _arrow.left = left;
}

- (void)setArrowWithTopOffset:(CGFloat)offset
{
    if (_arrow==nil) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    _arrow.top -= offset;
}
- (void)setArrowFrame:(CGRect)frame{

    if (_arrow==nil) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    _arrow.frame = frame;
}

- (void)showArrow:(BOOL)show
{
    if (_arrow==nil&&show) {
        [self setArrowWithLeft:self.contentView.width-15-6];
    }
    _isShowArrow = show;
    _arrow.hidden = !show;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedBackgroundView.frame = CGRectMake(0, -[CKCoreUtil screenOnePixel], self.width, self.height+[CKCoreUtil screenOnePixel]);
    _separatorView.top = self.height-[CKCoreUtil screenOnePixel];
    self.selectedBackgroundView.superview.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellBaseStyle:(CKTableViewCellBaseStyle)cellBaseStyle
{
    _cellBaseStyle = cellBaseStyle;
    if (_cellBaseStyle == CKTableViewCellStyleCommon) {
        _separatorView.hidden = NO;
    } else {
        _separatorView.hidden = YES;
    }
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 44;
}

@end
