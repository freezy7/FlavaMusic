//
//  CLTopTabButton.m
//  CLCommon
//
//  Created by ali on 15/2/2.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "CKBadgeButton.h"
#import "BPUIViewAdditions.h"
#import "CKBadgeView.h"
#import "BPCoreUtil.h"
#import "CKStaticImageManager.h"

@interface CKBadgeButton () {
    UIImageView *_dotView;
    CKBadgeView *_numberView;
}
@end

@implementation CKBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[BPCoreUtil colorWithHexString:@"828892"] forState:UIControlStateNormal];
        self.type = CKBadgeBtnDotType_Center;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showBadge) {
        if (_dotView.left != self.titleLabel.right + self.imageView.right + 2) {
            switch (self.type) {
                case CKBadgeBtnDotType_Top:
                    _dotView.origin = CGPointMake(self.titleLabel.right + self.imageView.right + 2, 10.f);
                    break;
                case CKBadgeBtnDotType_Center:
                    _dotView.origin = CGPointMake(self.titleLabel.right + self.imageView.right + 2, (self.height - _dotView.height) / 2);
                    break;
                case CKBadgeBtnDotType_Bottom:
                    _dotView.origin = CGPointMake(self.titleLabel.right + self.imageView.right + 2, self.height - _dotView.height);
                    break;
                default:
                    break;
            }
        }
    }
    if (self.showNumberBadge) {
        if (_numberView.center.x != self.titleLabel.right + self.imageView.right + 2) {
            _numberView.center = CGPointMake(self.titleLabel.right + self.imageView.right + 2, (self.height - _numberView.height) / 4 + _numberView.height/2);
        }
    }
}

- (void)setShowBadge:(BOOL)showBadge
{
    _showBadge = showBadge;
    
    if (_showBadge) {
        if ([self.subviews containsObject:_dotView]) {
            return;
        }
        if (!_dotView) {
            UIImage *badgeDot = [[CKStaticImageManager sharedInstance] imageWithColorHex:@"ff4242" size:CGSizeMake(6, 6) corner:3];
            _dotView = [[UIImageView alloc] initWithImage:badgeDot];
        }
        switch (self.type) {
            case CKBadgeBtnDotType_Top:
                _dotView.origin = CGPointMake(self.titleLabel.right + 2, 10.f);
                break;
            case CKBadgeBtnDotType_Center:
                _dotView.origin = CGPointMake(self.titleLabel.right + 2, (self.height - _dotView.height) / 2);
                break;
            case CKBadgeBtnDotType_Bottom:
                _dotView.origin = CGPointMake(self.titleLabel.right + 2, self.height - _dotView.height);
                break;
            default:
                break;
        }
        [self addSubview:_dotView];
    } else {
        [_dotView removeFromSuperview];
    }
}

- (void)setShowNumberBadge:(BOOL)showNumberBadge
{
    _showNumberBadge = showNumberBadge;
    
    if (_showNumberBadge) {
        if (_numberView == nil) {
            _numberView = [[CKBadgeView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            _numberView.center = CGPointMake(self.titleLabel.right + self.imageView.right + 2, (self.height - _numberView.height) / 4 + _numberView.height/2);
            [self addSubview:_numberView];
        }
        [_numberView setBadge:_badgeNumber];
    } else {
        [_numberView removeFromSuperview];
    }
}

@end
