//
//  CLTopTabButton.h
//  CLCommon
//
//  Created by ali on 15/2/2.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CKBadgeBtnDotType) {
    CKBadgeBtnDotType_Top,
    CKBadgeBtnDotType_Center,
    CKBadgeBtnDotType_Bottom,
};

///titleLabel的右上角加badge
@interface CKBadgeButton : UIButton

@property (nonatomic) CKBadgeBtnDotType type;
@property (nonatomic) BOOL showBadge;
@property (nonatomic) BOOL showNumberBadge;
@property (nonatomic) NSInteger badgeNumber;

@end
