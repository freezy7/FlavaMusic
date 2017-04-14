//
//  CLPlatePostImageCheckView.h
//  CLCommon
//
//  Created by Kent on 13-12-26.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKViewController.h"

@class CKImageListPreviewController;

@protocol CKImageListPreviewControllerDelegate <NSObject>

- (void)imageListPreviewController:(CKImageListPreviewController *)controller didClickShareImageLink:(NSString *)imageLink;

@end

@interface CKImageListPreviewController : CKViewController

@property (nonatomic, weak) id<CKImageListPreviewControllerDelegate> delegate;

/**
 *  @brief 用presentController方式显示图片列表
 *
 *  @param controller       从哪个controller进行present
 *  @param imageLinkList    图片原链接列表
 *  @param startImageLink   当前图片的原链接
 *  @param imageViewDict    字典中key为@(index)，value为UIImageView
 *  @param delegate
 */
+ (void)showInController:(UIViewController *)controller imageLinkList:(NSArray *)imageLinkList startIndex:(NSInteger)startIndex imageViewDict:(NSDictionary *)imageViewDict delegate:(id<CKImageListPreviewControllerDelegate>)delegate;

@end