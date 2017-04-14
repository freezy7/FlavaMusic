//
//  CKTableViewGroupCell.m
//  CLUIKit
//
//  Created by wangpeng on 16/1/9.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKTableViewGroupCell.h"
#import "CKStaticImageManager.h"
#import "BPUIViewAdditions.h"
#import "CKCoreUtil.h"
#import "BPCoreUtil.h"
#import "CKUIManager.h"

@implementation CKTableViewGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setIsTopCell:(BOOL)isTopCell
{
    _isTopCell = isTopCell;
    
    if (_topSeparatorView==nil&&_isTopCell) {
        _topSeparatorView = [[UIImageView alloc] initWithFrame:CGRectMake(11.f, 0, 298.f,[CKCoreUtil screenOnePixel])];
        _topSeparatorView.contentMode = UIViewContentModeScaleToFill;
        _topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(cellSeparatorLineColor)] && [[CKUIManager sharedManager] cellSeparatorLineColor]) {
            _topSeparatorView.backgroundColor = [[CKUIManager sharedManager] cellSeparatorLineColor];
        } else {
            _topSeparatorView.backgroundColor = [BPCoreUtil colorWithHexString:@"dcdcdc" alpha:1];
        }
        [self.backgroundView addSubview:_topSeparatorView];
    }
    
    _topSeparatorView.hidden = !_isTopCell;
}

- (void)setTopSeparatorLineWithLeft:(CGFloat)left
{
    _topSeparatorView.frame = CGRectMake(left, 0, self.backgroundView.width-left*2, [CKCoreUtil screenOnePixel]);
}

- (void)setTopSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right
{
    _topSeparatorView.frame = CGRectMake(left, 0, self.backgroundView.width-left-right, [CKCoreUtil screenOnePixel]);
}

- (void)setTopSeparatorWithColor:(UIColor *)color
{
    _topSeparatorView.image = [CKCoreUtil imageWithColor:color];
}

- (void)setTopSeparatorWithImage:(UIImage *)image
{
    _topSeparatorView.image = image;
}

@end
