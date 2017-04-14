//
//  COCarBadgeView.m
//  COCommon
//
//  Created by R_flava_Man on 16/4/8.
//  Copyright © 2016年 wu kai feng. All rights reserved.
//

#import "CKBadgeView.h"
#import "BPUIViewAdditions.h"
#import "BPCoreUtil.h"
#import "CKStaticImageManager.h"
#import "CKCoreUtil.h"

@interface CKBadgeView () {
    UILabel *_label;
    UIImageView *_bgView;
}

@end

@implementation CKBadgeView

@dynamic font;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_bgView];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_label];
        
        _maxBadge = 99;
        _badgeHeight = self.height;
        self.dotWidth = MIN(8, _badgeHeight);
        self.badgeColor = [BPCoreUtil colorWithHexString:@"FF5959"];
        
        _bgView.image = [[CKStaticImageManager sharedInstance] imageWithColorHex:@"FF5959" size:self.size corner:self.height/2];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
    if (font.pointSize>_badgeHeight) {
        self.badgeHeight = font.pointSize+2;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)setBadgeHeight:(CGFloat)badgeHeight
{
    _badgeHeight = badgeHeight;
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _badgeColor = badgeColor;
    
    _bgView.image = [[CKStaticImageManager sharedInstance] imageWithColorHex:@"FF5959" size:self.size corner:self.height/2];
}

- (void)setOnlyDot:(BOOL)onlyDot
{
    _onlyDot = onlyDot;
}

- (void)setBadge:(NSUInteger)badge
{
    _badge = badge;
    
    if (badge>0) {
        [self sizeOfBadge];
        if (_onlyDot) {
            _label.text = @"";
        } else {
            if (badge>_maxBadge) {
                _label.text = [NSString stringWithFormat:@"%d",_maxBadge];
            } else {
                _label.text = [NSString stringWithFormat:@"%lu", (unsigned long)badge];
            }
        }
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (CGSize)sizeOfBadge
{
    CGSize size = CGSizeZero;
    if (_badge>0) {
        if (_onlyDot) {
            size.width = size.height = _dotWidth;
        } else {
            NSString *text = @"";
            size.height = _badgeHeight;
            if (_badge>_maxBadge) {
                text = [NSString stringWithFormat:@"%d",_maxBadge];
            } else {
                text = [NSString stringWithFormat:@"%lu", (unsigned long)_badge];
            }
            size.width = [CKCoreUtil sizeWithFont:_label.font fixString:text].width+(_badgeHeight-_label.font.pointSize)+2;
            size.width = MAX(_badgeHeight, ceilf(size.width));
        }
        if (!CGSizeEqualToSize(self.size, size)) {
            self.size = size;
            _bgView.image = [CKCoreUtil imageWithColor:_badgeColor cornerRadius:size.height/2 withSize:size];
        }
    }
    return size;
}

@end
