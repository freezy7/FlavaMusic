//
//  CKTableTextLoadMoreCell.m
//  CLCommon
//
//  Created by wangpeng on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableTextLoadMoreCell.h"
#import "BPUIViewAdditions.h"
#import "BPCoreUtil.h"
#import "CKUIManager.h"

@interface CKTableTextLoadMoreCell () {
    UIActivityIndicatorView *_aiView;
    UILabel *_loadingLabel;
    UILabel *_normalLabel;
    UIButton *_failBtn;
    
    UIImageView *_bgImgView;
    UIImageView *_selBgImgView;
}

@end

@implementation CKTableTextLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellBaseStyle = CKTableViewCellStyleBottom;
        
        _aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _aiView.transform = CGAffineTransformMakeScale(18.0f/_aiView.width, 18.0f/_aiView.width);
        [self.contentView addSubview:_aiView];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.font = [UIFont systemFontOfSize:15];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"加载中...";
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(loadMoreCellNormalTextColor)] && [[CKUIManager sharedManager] loadMoreCellNormalTextColor]) {
            _loadingLabel.textColor = [[CKUIManager sharedManager] loadMoreCellNormalTextColor];
        } else {
            _loadingLabel.textColor = [BPCoreUtil colorWithHexString:@"555555" alpha:1.0f];
        }
        
        [_loadingLabel sizeToFit];
        [self.contentView addSubview:_loadingLabel];
        
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalLabel.font = [UIFont systemFontOfSize:15];
        _normalLabel.backgroundColor = [UIColor clearColor];
        _normalLabel.text = self.isTopLoad?@"下拉加载更多":@"上拉加载更多";
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(loadMoreCellNormalTextColor)] && [[CKUIManager sharedManager] loadMoreCellNormalTextColor]) {
            _normalLabel.textColor = [[CKUIManager sharedManager] loadMoreCellNormalTextColor];
        } else {
            _normalLabel.textColor = [BPCoreUtil colorWithHexString:@"555555" alpha:1.0f];
        }
        
        [_normalLabel sizeToFit];
        [self.contentView addSubview:_normalLabel];
        
        _aiView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        _loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        _normalLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        
        _loadingLabel.baselineAdjustment = _normalLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        [self setState:CKTableLoadMoreNormal];
        
        self.height = 44;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.width = self.width;
    
    CGFloat height = self.contentView.height;
    _normalLabel.origin = CGPointMake(self.contentView.width/2-_normalLabel.width/2, _topShadowHeight/2+(height-3)/2-_normalLabel.height/2);
    _aiView.origin = CGPointMake(self.contentView.width/2-(4+_aiView.width+_loadingLabel.width)/2, _topShadowHeight/2+(height-3)/2-_aiView.height/2);
    _loadingLabel.origin = CGPointMake(_aiView.right+4, _topShadowHeight/2+(height-3)/2-_loadingLabel.height/2);
}

- (void)setTopShadowHeight:(CGFloat)topShadowHeight
{
    _topShadowHeight = topShadowHeight;
    
    _bgImgView.frame = CGRectMake(_selBgImgView.left, _topShadowHeight, _selBgImgView.width, _selBgImgView.height-_topShadowHeight);
    _selBgImgView.frame = CGRectMake(_selBgImgView.left, _topShadowHeight, _selBgImgView.width, _selBgImgView.height-_topShadowHeight);
}

- (void)setState:(CKTableLoadMoreState)state
{
    [super setState:state];
    switch (state) {
        case CKTableLoadMoreNormal:
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [_aiView stopAnimating];
            _normalLabel.hidden = NO;
            _normalLabel.text = self.isTopLoad?@"下拉加载更多":@"上拉加载更多";
            _aiView.hidden = YES;
            _loadingLabel.hidden = YES;
            break;
        case CKTableLoadMoreFailed:
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            _normalLabel.hidden = NO;
            _normalLabel.text = @"点击加载更多";
            [_aiView stopAnimating];
            _aiView.hidden = YES;
            _loadingLabel.hidden = YES;
            break;
        default:
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            _normalLabel.hidden = YES;
            [_aiView startAnimating];
            _aiView.hidden = NO;
            _loadingLabel.hidden = NO;
            break;
    }
}

- (void)setStarMoreCellStyle
{
    if ([[CKUIManager sharedManager] respondsToSelector:@selector(loadMoreCellBackgroundColor)] && [[CKUIManager sharedManager] loadMoreCellBackgroundColor]) {
        self.backgroundColor = [[CKUIManager sharedManager] loadMoreCellBackgroundColor];
        self.contentView.backgroundColor = [[CKUIManager sharedManager] loadMoreCellBackgroundColor];
    } else {
        self.backgroundColor = [BPCoreUtil colorWithHexString:@"26282c" alpha:1];
        self.contentView.backgroundColor = [BPCoreUtil colorWithHexString:@"26282c"];
    }
    _aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _loadingLabel.textColor = [UIColor whiteColor];
    _normalLabel.textColor = [UIColor whiteColor];
}

@end
