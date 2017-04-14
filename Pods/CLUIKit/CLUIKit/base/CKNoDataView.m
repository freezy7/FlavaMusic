//
//  CKNoDataView.m
//  CLCommon
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKNoDataView.h"
#import "BPUIViewAdditions.h"
#import "BPCoreUtil.h"
#import "CKCoreUtil.h"
#import "CKUIManager.h"

#define kMaxLabelWidth    130

@implementation CKNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf((self.width-56)/2), floorf((self.height-58)/2)-(_disableHeightOffset?0:60), 56, 58)];
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_imgView];
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorf((self.width-200)/2), _imgView.bottom+20, 200, 30)];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _msgLabel.backgroundColor = [UIColor clearColor];
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(noDataViewMessageLabelTextColor)] && [[CKUIManager sharedManager] noDataViewMessageLabelTextColor]) {
            _msgLabel.textColor = [[CKUIManager sharedManager] noDataViewMessageLabelTextColor];
        } else {
            _msgLabel.textColor = [BPCoreUtil colorWithHexString:@"cbcbcb" alpha:1];
        }
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:15];
        _msgLabel.numberOfLines = 0;
        [self addSubview:_msgLabel];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [CKCoreUtil sizeWithFont:_msgLabel.font constrainedToSize:CGSizeMake(200, 10000) fixString:_msgLabel.text];
    _msgLabel.height = size.height;
    
    _imgView.frame = CGRectMake(floorf((self.width-_image.size.width)/2), floorf((self.height-_image.size.height)/2)-(_disableHeightOffset?0:60), _image.size.width, _image.size.height);
    
    CGFloat top = floorf((self.height-_imgView.height-20-size.height)/2)-(_disableHeightOffset?0:60);
    _imgView.top = top;
    _msgLabel.top = _imgView.bottom+20;
}

- (void)setMsg:(NSString *)msg
{
    _msg = msg;
    
    _msgLabel.text = msg;
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imgView.image = image;
    
    [self setNeedsLayout];
}

- (void)tapAction
{
    [_delegate noDataViewDidClick:self];
}

@end
