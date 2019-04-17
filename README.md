# 使用贝赛尔曲线画折线图、曲线图、柱状图、饼图

折线图效果，支持动态改变y轴大小<br>
![imge](https://github.com/dndo/Bezier/blob/master/BezierT/pic1.png)<br>
//使用方法
1.引入头文件 
```
#import "BrokenView.h"
```
2.调用方法
```
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
```

注：可以根据自己的实际业务更改配置，详见 
```
BrokenView.h文件

//画布背景色<br>
#define K_CanvasBackgroundColor  [UIColor lightGrayColor];

// 坐标轴与画布间距
#define MARGIN 30

// y轴每一个值的间隔数
#define Y_EVERY_MARGIN 20.00

// x/y轴的颜色
#define K_XYColor  [UIColor yellowColor].CGColor;

//x轴字体颜色
#define K_X_textColor [UIColor redColor];

//x轴字号大小
#define K_X_textFont [UIFont systemFontOfSize:10];

//x轴字体颜色
#define K_Y_textColor [UIColor yellowColor];

//x轴字号大小
#define K_Y_textFont [UIFont systemFontOfSize:10];

//折线转折点颜色
#define K_BrokenLineTurnPointColor [UIColor purpleColor].CGColor;

//折线颜色
#define K_BrokenLineColor [UIColor purpleColor].CGColor;

// 线条类型
typedef NS_ENUM(NSInteger, LineType) {
    BrokenLineENUM, //折线图
    CurveENUM,//曲线图
    HistogramENUM,//柱状图
    PieChartENUM //饼图
};

@interface BrokenView : UIView


/**
 自定义初始化

 @param xArray x值数组
 @param yArray y值数组
 @param everyYcount y轴每个小格代表的值
 @param leftX 画布布局X值
 @param topY 画布布局Y值
 @return 画布
 */
- (instancetype)initWithXArray:(NSArray *)xArray
                        YArray:(NSArray *)yArray
                   everyYcount:(float)everyYcount
                         leftX:(float)leftX
                          topY:(float)topY;

/**
 开始画图
 @param lineType  图形类型(折线/曲线/柱状/饼)
 */
-(void)drawLineWithLineType:(LineType) lineType;
```
