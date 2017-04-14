//
//  ViewController.m
//  FlavaMusic
//
//  Created by R_flava_Man on 16/2/19.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "ViewController.h"
#import "FMDataService.h"
#import "CLDataService.h"
#import "FMScrollHeaderCell.h"
#import "FMRefreshHeaderView.h"
#import "FLAnimatedImage.h"
#import "UIImageView+WebCache.h"
#import "CKStaticImageManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    FMRefreshHeaderView *_refreshHeaderView;
    FLAnimatedImageView *_gifImageView;
    FLAnimatedImageView *_gifImageView1;
    FLAnimatedImageView *_gifImageView2;
    FLAnimatedImageView *_gifImageView3;
    UITableView *_tableView;
    
    BOOL isSwitch;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [CLDataService getRequestWithMethod:@"v2-car-getModelEntranceInfo.html" parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"222222222");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
    
    NSLog(@"111111111");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_tableView];
    
    _refreshHeaderView = [[FMRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -64, _tableView.frame.size.width, 64)];
    _refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshHeaderView.defaultContentInset = _tableView.contentInset;
//    [_tableView addSubview:_refreshHeaderView];
    
//    CGFloat _downPay = round(198800 * 0.3);
//    CGFloat interstRate = 6.4;
//    
//    NSInteger year = 3;
//    CGFloat loanMonths = 12;
//    loanMonths = loanMonths * year;
//    
//    CGFloat yearRate = interstRate/100.0f;
//    CGFloat monthPercent = yearRate/12.0f;
//    CGFloat fenzi = (198800 - _downPay)*monthPercent*pow((1+monthPercent), loanMonths);
//    CGFloat fenmu = (pow(1+monthPercent, loanMonths)-1);
//    CGFloat _monthlyPay = round(fenzi/fenmu);
    
    _gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _gifImageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_gifImageView];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.backgroundColor = [UIColor lightGrayColor];
    switchBtn.frame = CGRectMake(125, 225, 50, 50);
    [switchBtn setTitle:@"切换" forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(swithcGIF) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    
    UIButton *switchBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn1.backgroundColor = [UIColor lightGrayColor];
    switchBtn1.frame = CGRectMake(125, 325, 50, 50);
    [switchBtn1 setTitle:@"重复" forState:UIControlStateNormal];
    [switchBtn1 addTarget:self action:@selector(repeatGIF) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn1];
    
    
    [self decodeLinkMapString];
}

- (void)decodeLinkMapString
{
    NSError *error = nil;
    NSString *linkMapString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QueryViolations_ent-LinkMap-normal-arm64" ofType:@"txt"] encoding:NSMacOSRomanStringEncoding error:&error];
    
    NSRange objectHeadRange = [linkMapString rangeOfString:@"# Object files:"];
    NSRange sectionHeadRange = [linkMapString rangeOfString:@"# Sections:"];
    NSRange symbolsHeadRange = [linkMapString rangeOfString:@"# Symbols:"];
    NSRange deadStrippedSymbolsHeadRange = [linkMapString rangeOfString:@"# Dead Stripped Symbols:"];
    
    NSString *object_filesStr = [[linkMapString substringFromIndex:objectHeadRange.location + objectHeadRange.length] substringToIndex:sectionHeadRange.location - objectHeadRange.location - objectHeadRange.length];
    NSString *sectionsStr = [[linkMapString substringFromIndex:sectionHeadRange.location + sectionHeadRange.length] substringToIndex:symbolsHeadRange.location - sectionHeadRange.location - sectionHeadRange.length];
    NSString *symbosStr = [[linkMapString substringFromIndex:symbolsHeadRange.location + symbolsHeadRange.length] substringToIndex:deadStrippedSymbolsHeadRange.location - symbolsHeadRange.location - symbolsHeadRange.length];
    NSString *deadStrippedStr = [linkMapString substringFromIndex:deadStrippedSymbolsHeadRange.location + deadStrippedSymbolsHeadRange.length];
    
//    NSArray *selectorsAll = [linkMapString st]
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_gifImageView sd_setImageWithURL:[NSURL URLWithString:@"https://picture.eclicks.cn/g1/l/2017/03/31/36b0a73aa5d20e1a_346_260.gif"] placeholderImage:nil];
}

- (void)swithcGIF
{
    if (isSwitch) {
        [_gifImageView sd_setImageWithURL:[NSURL URLWithString:@"https://picture.eclicks.cn/g1/l/2017/03/31/36b0a73aa5d20e1a_346_260.gif"] placeholderImage:nil];
    } else {
        [_gifImageView sd_setImageWithURL:[NSURL URLWithString:@"https://file-test.chelun.com/g1/img/2017/01/14/610247db997295d2_g_360_200.gif"] placeholderImage:nil];
    }
    isSwitch = !isSwitch;
    [self performSelector:@selector(swithcGIF) withObject:nil afterDelay:0.01];
}

- (void)repeatGIF
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

}

- (void)FMDataService
{
    [FMDataService getRequestWithMethod:@"alibaba.xiami.api.rank.index.get" parameters:nil success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FMScrollHeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FMScrollHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
    return [[UITableViewCell alloc] init];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView refreshHeaderViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView refreshHeaderViewDidEndDragging:scrollView];
}

@end
