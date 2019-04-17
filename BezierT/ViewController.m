//
//  ViewController.m
//  BezierT
//
//  Created by LiuJianning on 2019/4/12.
//  Copyright © 2019 1231. All rights reserved.
//

#import "ViewController.h"

#import "BrokenView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawLineView];
}


- (void)drawLineView
{
    NSArray *xArr = @[@"小明",@"小红",@"小刚", @"小黑",@"小王", @"默默", @"小刚", @"小黑",@"小王", @"默默"];
    NSArray *yArr = @[@"200", @"300", @"100", @"160", @"180", @"60", @"70", @"160", @"180", @"60"];
    if (xArr.count == yArr.count) {
        BrokenView *brokenView = [[BrokenView alloc] initWithXArray:xArr YArray:yArr everyYcount:50 leftX:10 topY:100];
        [self.view addSubview:brokenView];
        [brokenView drawLineWithLineType:PieChartENUM];
    }
}


@end
