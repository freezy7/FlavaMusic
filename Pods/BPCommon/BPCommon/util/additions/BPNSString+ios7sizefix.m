//
//  BPNSString+ios7sizefix.m
//  BPCommon
//
//  Created by wangpeng on 11/29/13.
//
//

#import "BPNSString+ios7sizefix.h"
#import <CoreText/CoreText.h>

@implementation NSString (ios7sizefix)

- (CGSize)sizeWithFont:(UIFont *)font
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        CGSize result = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    } else {
        CGSize result = [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    }
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    } else {
        CGSize result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    }
}

@end
