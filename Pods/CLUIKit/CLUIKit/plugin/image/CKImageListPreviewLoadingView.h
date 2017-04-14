//
//  CLImageLoadingView.h
//  CLCommon
//
//  Created by Kent on 13-12-27.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKImageListPreviewLoadingView : UIView

@property (nonatomic) float progress;

- (void)startAnimation;
- (void)stopAnimation;

@end
