//
//  CKCoreUtil+Net.h
//  CLNetKit
//
//  Created by wangpeng on 16/1/13.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKCoreUtil.h"

@interface CKCoreUtil (Net)

#pragma mark - 通过链接获得图片大小
+ (CGSize)sizeWithImageLink:(NSString *)imageLink;

#pragma mark - 通过图片大小获得缩略图地址
//type:0 自动切成方形     type:1 表示_wh，有1:4限制    type:2 表示_w，等宽求高
+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size;
+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size thumbSize:(CGSize *)thumbSize;
+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size autoRetina:(BOOL)autoRetina;
+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size autoRetina:(BOOL)autoRetina type:(NSInteger)type;

@end
