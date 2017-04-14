//
//  CKNoDataView.h
//  CLCommon
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKNoDataView;

@protocol CKNoDataViewDelegate <NSObject>

- (void)noDataViewDidClick:(CKNoDataView *)view;

@end

@interface CKNoDataView : UIView {
    UIImageView *_imgView;
    UILabel *_msgLabel;
}

@property (nonatomic, weak) id<CKNoDataViewDelegate> delegate;

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL disableHeightOffset;

@end
