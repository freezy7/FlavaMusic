//
//  ViewController.m
//  FlavaMusic
//
//  Created by R_flava_Man on 16/2/19.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "ViewController.h"
#import "FMDataService.h"
#import "FMScanViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _titleLabel.text = NSLocalizedString(@"name", nil);
    
//    [FMDataService getRequestWithMethod:@"alibaba.xiami.api.rank.music.detail.get" parameters:nil success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
//        
//    }];
    
    
    NSString *proName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSLog(@"dicName ==== %@",[[NSBundle mainBundle] infoDictionary]);
    
    BOOL ret = [self checkIdentityCardString:@"41018419890228255X"];
    
    NSLog(@"dicName ==== %zd",ret);
    
}

- (BOOL)checkIdentityCardString:(NSString *)IdentityString
{
    NSInteger length = IdentityString.length;
    if (length != 18) {
        return NO;
    }
    
    NSString *birthday = [IdentityString substringWithRange:NSMakeRange(6, 8)];
    
    NSString *year = [IdentityString substringWithRange:NSMakeRange(6, 4)];
    NSString *month = [IdentityString substringWithRange:NSMakeRange(10, 2)];
    NSString *day = [IdentityString substringWithRange:NSMakeRange(12, 2)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *tempDate = [formatter dateFromString:birthday];
    
    //验证生日的合法性
    if (tempDate == nil) {
        return NO;
    }
    
    NSDateComponents *pc = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:tempDate];
    
    NSInteger yearNum = [pc year];
    NSInteger monthNum = [pc month];
    NSInteger dayNum = [pc day];
    
    if ([year integerValue] != yearNum || [month integerValue] != monthNum || [day integerValue] != dayNum) {
        return NO;
    }
    
    NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        NSString *subStr = [IdentityString substringWithRange:NSMakeRange(i, 1)];
        [numArray addObject:subStr];
    }
    
    NSArray *wArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    NSArray *cArray = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSUInteger sum = 0;
    
    //验证最后位校验码的合法性
    for (int i = 0; i < wArray.count; i ++) {
        sum = sum + [numArray[i] integerValue]*[wArray[i] integerValue];
    }
    
    NSInteger ret = sum%11;
    NSString *res = cArray[ret];
    
    if ([res isEqualToString:[numArray lastObject]]) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)tapAction:(id)sender
{
    FMScanViewController *controller = [[FMScanViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
