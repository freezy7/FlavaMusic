//
//  BPNSNumberAdditions.m
//  BPCommon
//
//  Created by WangPeng on 12/12/12.
//
//

#import "BPNSNumberAdditions.h"

@implementation NSNumber (vge)

- (NSString *)stringForDecimalStyle
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:self];
}

@end
