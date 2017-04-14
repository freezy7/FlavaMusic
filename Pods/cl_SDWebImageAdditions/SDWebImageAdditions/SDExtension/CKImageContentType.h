//
//  CKImageContentType.h
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+ImageContentType.h"

@interface CKImageContentType : NSObject

+ (NSString *)getImageContentTypeWithFormat:(SDImageFormat)imageFormat;

@end
