//
//  COCarBadgeView.h
//  COCommon
//
//  Created by R_flava_Man on 16/4/8.
//  Copyright © 2016年 wu kai feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKBadgeView : UIView

@property (nonatomic, strong) UIColor *badgeColor; // redColor by default
@property (nonatomic, assign) NSUInteger badge; // 0 by default
@property (nonatomic, assign) int maxBadge;//default is 99
@property (nonatomic, assign) BOOL onlyDot; // NO by default
@property (nonatomic, assign) CGFloat dotWidth; // 8 by default
@property (nonatomic, assign) CGFloat badgeHeight;
@property (nonatomic) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

- (CGSize)sizeOfBadge;

@end
