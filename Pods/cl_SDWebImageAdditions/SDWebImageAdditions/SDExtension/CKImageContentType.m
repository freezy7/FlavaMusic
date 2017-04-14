//
//  CKImageContentType.m
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "CKImageContentType.h"

@implementation CKImageContentType

+ (NSString *)getImageContentTypeWithFormat:(SDImageFormat)imageFormat
{
    switch (imageFormat) {
        case SDImageFormatJPEG:
            return @"image/jpeg";
            break;
        case SDImageFormatPNG:
            return @"image/png";
            break;
        case SDImageFormatGIF:
            return @"image/gif";
            break;
        case SDImageFormatTIFF:
            return @"image/tiff";
            break;
        case SDImageFormatWebP:
            return @"image/webp";
            break;
        default:
            return nil;
            break;
    }
}

@end
