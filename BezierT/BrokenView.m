//
//  BrokenView.m
//  BezierT
//
//  Created by LiuJianning on 2019/4/12.
//  Copyright © 2019 1231. All rights reserved.
//


#import "BrokenView.h"

@interface BrokenView ()

//Y轴每个格代表多少
@property (nonatomic, assign) float yCount;

//Y轴均分的份数
@property (nonatomic, assign) float yAllCount;

//x值数组
@property (nonatomic, strong) NSArray * XcountArr;

//y值数组
@property (nonatomic, strong) NSArray * YcountArr;

@end

@implementation BrokenView

- (instancetype)initWithXArray:(NSArray *)xArray
                        YArray:(NSArray *)yArray
                   everyYcount:(float)everyYcount
                         leftX:(float)leftX
                          topY:(float)topY
{
    
    _yCount = everyYcount;
    float max =[[yArray valueForKeyPath:@"@max.floatValue"] floatValue];
    float H =  ((max /_yCount)+1)*20 +45;
    float W = ((yArray.count+2) *30);
    _yAllCount = max / _yCount +1;
    _XcountArr = xArray;
    _YcountArr = yArray;
    self = [super initWithFrame:CGRectMake(leftX, topY, W, H)];
    self.backgroundColor = K_CanvasBackgroundColor
    return self;
}

#pragma mark ===  UI- X轴/Y轴
-(void)drawXYLineWithXArr
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.画直线
    
    //Y轴直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, 0)];
    //X轴直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    
    //2.画箭头
    
    //Y轴箭头
    [path moveToPoint:CGPointMake(MARGIN, 0)];
    [path addLineToPoint:CGPointMake(MARGIN-5, 5)];
    [path moveToPoint:CGPointMake(MARGIN, 0)];
    [path addLineToPoint:CGPointMake(MARGIN+5, 5)];
     //X轴箭头
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-MARGIN-5, CGRectGetHeight(self.frame)-MARGIN-5)];
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-MARGIN-5, CGRectGetHeight(self.frame)-MARGIN+5)];
    
    //3.添加索引格
    
    //X轴
    for (int i = 0; i < _XcountArr.count; i++) {
        CGFloat X = MARGIN + MARGIN*(i+1);
        CGPoint point = CGPointMake(X, CGRectGetHeight(self.frame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴
    for (int i = 0; i < _yAllCount; i++) {
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-Y_EVERY_MARGIN*i;
        CGPoint point = CGPointMake(MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //4.添加索引格文字
    
    //X轴
    for (int i = 0; i < _XcountArr.count; i++) {
        
        float X = MARGIN + 15 + MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(self.frame)-MARGIN, MARGIN, 20)];
        textLabel.text = _XcountArr[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = K_X_textFont
        textLabel.textColor = K_X_textColor
        [self addSubview:textLabel];
    }
    //Y轴
    //最小值是0,最大值是150,y轴总共10个格子,每个小格即为15,
    
    for (int i = 0; i < _yAllCount;  i++) {
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-Y_EVERY_MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%.f", _yCount*i];//[yArry objectAtIndex:i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = K_Y_textFont
        textLabel.textColor = K_Y_textColor;
        [self addSubview:textLabel];
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = K_XYColor
    shapeLayer.fillColor = [UIColor clearColor].CGColor; //填充色
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
}

#pragma mark ===  开始画图
-(void)drawLineWithLineType:(LineType) lineType
{
    if (lineType ==  BrokenLineENUM || lineType == CurveENUM) {
        [self drawWithLineType:lineType];
    }
    else if (lineType ==  HistogramENUM) {
        [self drawHistogram];
    }
    else if (lineType == PieChartENUM) {
        [self drawPieChart];
    }
}

#pragma mark ===  折线图
-(void)drawWithLineType:(LineType) lineType
{
    //1.画坐标轴
    [self drawXYLineWithXArr];
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray new];
    for (int i = 0; i < _XcountArr.count; i++) {
        
        //调整Y轴比例,每个格代表15,每个格的实际尺寸是20,所以此处的比例为(20.00/15.00)
        
        CGFloat doubleValue = (Y_EVERY_MARGIN/_yCount) *[_YcountArr[i] floatValue];
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-doubleValue;
        CGFloat X = MARGIN + MARGIN*(i+1);
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = K_BrokenLineTurnPointColor
        layer.fillColor = K_BrokenLineColor
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case BrokenLineENUM: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case CurveENUM:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
       default:
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];

    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];

        CGPoint NowPoint = [allPoints[i] CGPointValue];
        float topY = NowPoint.y-20;
        if (NowPoint.y>PrePonit.y && i != 0 &&  [_YcountArr[i] integerValue] != 0) {
            topY = NowPoint.y;
        }
        label.frame = CGRectMake(NowPoint.x-MARGIN/2, topY, MARGIN, 20);
        PrePonit = NowPoint;
        label.text = _YcountArr[i];
    }
}


#pragma mark ===
#pragma mark ===
#pragma mark ===
#pragma mark ===
#pragma mark ===  柱状图
-(void)drawHistogram
{
    //1.画坐标轴
    [self drawXYLineWithXArr];

    //2.每一个目标值点坐标
    for (int i=0; i<_YcountArr.count; i++) {
        CGFloat doubleValue = (Y_EVERY_MARGIN/_yCount) *[_YcountArr[i] floatValue];
        CGFloat X = MARGIN + MARGIN*(i+1)+5;
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-doubleValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X-MARGIN/2, Y, MARGIN-10, doubleValue)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = self.randomColor.CGColor;
        shapeLayer.borderWidth = 2.0;
        [self.layer addSublayer:shapeLayer];
        
        //3.添加文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X-MARGIN/2, Y-20, MARGIN-10, 20)];
        label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(self.frame)-Y-MARGIN)/2];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}

#pragma mark ===
#pragma mark ===
#pragma mark ===
#pragma mark ===
#pragma mark ===  饼图
-(void)drawPieChart{
    
    //设置圆点
    CGPoint point = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle ;
    CGFloat radius = 60;
    
    //计算总数
    __block CGFloat allValue = 0;
    [_YcountArr enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        allValue += [targetNumber floatValue];
    }];
    
    //画图
    for (int i =0; i<_YcountArr.count; i++) {
        
        CGFloat targetValue = [_YcountArr[i] floatValue];
        
        endAngle = startAngle + targetValue/allValue*2 *M_PI;

        //bezierPath形成闭合的扇形路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point
                                                                  radius:radius
                                                              startAngle:startAngle
                                                                endAngle:endAngle
                                                               clockwise:YES];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        
        //添加文字
        CGFloat X = point.x + (radius+20)*cos(startAngle+(endAngle-startAngle)/2) - 10;
        CGFloat Y = point.y + (radius +10) *sin(startAngle+(endAngle-startAngle)/2) - 10;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.text = _XcountArr[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor redColor];
        [self addSubview:label];
        
        
        //渲染
        CAShapeLayer *shapeLayer=[CAShapeLayer layer];
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = self.randomColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        startAngle = endAngle;
    }
}

//获取随机色
- (UIColor *)randomColor {
    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0)
                                           green:((float)arc4random_uniform(256) / 255.0)
                                            blue:((float)arc4random_uniform(256) / 255.0)
                                           alpha:1.0];
    return randomColor;
}


@end
