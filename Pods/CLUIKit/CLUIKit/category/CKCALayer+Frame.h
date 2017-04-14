//
//  CKCALayer+Frame.h
//  CLUIKit
//
//  Created by wangpeng on 16/1/8.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (Frame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@end
