//
//  PHCycleView.m
//  mtc_kwm
//
//  Created by 1 on 2020/11/13.
//  Copyright © 2020 yzl. All rights reserved.
//

#import "PHCycleView.h"

#define kBorderWith 10
#define center CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)//角都转弧度

@interface PHCycleView()

@property (strong, nonatomic) CAShapeLayer *outLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@end

@implementation PHCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawProgress];
        
        
    }
    return self;
}

-(void)drawProgress{
    
    UIBezierPath *outsidePath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width - 5)/ 2.0+8 startAngle:DEGREES_TO_RADIANS(130) endAngle:DEGREES_TO_RADIANS(130) + DEGREES_TO_RADIANS(280) clockwise:YES];
// 内圈
    UIBezierPath *insidePath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width - 30)/ 2.0 startAngle:-M_PI_2 endAngle:M_PI * 3.0 / 2.0 clockwise:YES];
    CAShapeLayer *insideLayer = [CAShapeLayer layer];
    insideLayer.strokeColor = [UIColor clearColor].CGColor;
    insideLayer.lineWidth = kBorderWith;
    insideLayer.fillColor =  [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    insideLayer.path = insidePath.CGPath;
    [self.layer addSublayer:insideLayer];
    //外圈
    self.outLayer = [CAShapeLayer layer];
    self.outLayer.lineWidth = 3;
    self.outLayer.strokeColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.3].CGColor;
    self.outLayer.fillColor =  [UIColor clearColor].CGColor;
    self.outLayer.path = outsidePath.CGPath;
    [self.layer addSublayer:self.outLayer];

    // 进度条
//    self.progressLayer = [CAShapeLayer layer];
//    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
//    self.progressLayer.lineWidth = 3;
//    self.progressLayer.strokeStart = M_PI/12;
//    self.progressLayer.path = outsidePath.CGPath;
//    [self.layer addSublayer:self.progressLayer];

    // 进度Label
    // 进度Label
    self.progressLabel = [UILabel new];
    self.progressLabel.frame = CGRectMake(0,30,self.frame.size.width ,40);
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.progressLabel];

    //描述Label
    self.describeLabel = [UILabel new];
    self.describeLabel.frame = CGRectMake(0, 70, self.frame.size.width , 30);
    self.describeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.describeLabel];
}

- (CALayer*)_createLinesLayerWithFrame:(CGRect)frame
                              preAngle:(CGFloat)angle
                              lineSize:(CGSize)size
                                 color:(UIColor*)color{
    CALayer* linesLayer = [[CALayer alloc] init];
    linesLayer.frame = frame;
    for (int i = 0; i < (int)(360/angle); i++) {
        CGFloat curAngle = i * angle;
        if (curAngle > 225 && curAngle < 315) {
            continue;
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint layerCenter = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        CGPoint start = [self _calcCircleCoordinateWithCenter:layerCenter angle:i * angle radius:layerCenter.x];
        CGPoint end = [self _calcCircleCoordinateWithCenter:layerCenter angle:i * angle radius:layerCenter.x - size.height];
        [path moveToPoint:start];
        [path addLineToPoint:end];
        CAShapeLayer* lineLayer = [[CAShapeLayer alloc] init];
        lineLayer.strokeColor = color.CGColor;
        lineLayer.lineWidth = size.width;
        lineLayer.path = path.CGPath;
        lineLayer.lineCap = kCALineCapRound;
        [linesLayer addSublayer:lineLayer];
    }
    return linesLayer;
}

- (CGPoint)_calcCircleCoordinateWithCenter:(CGPoint)ct angle:(CGFloat)angle radius:(CGFloat)radius
{
    CGFloat x2 = radius * cosf(angle * M_PI / 180);
    CGFloat y2 = radius * sinf(angle * M_PI / 180);
    return CGPointMake(ct.x + x2, ct.y - y2);
}

- (void)updateProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    CGFloat endAngle = 0;
    endAngle = DEGREES_TO_RADIANS(130) + DEGREES_TO_RADIANS(280)*progress;
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineWidth = 3;
    [self.layer addSublayer:self.progressLayer];
    UIBezierPath *outsidePath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width - 5)/ 2.0+8 startAngle:DEGREES_TO_RADIANS(130) endAngle:endAngle clockwise:YES];
    self.progressLayer.path = outsidePath.CGPath;
    [CATransaction commit];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f",progress];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.progressLayer.strokeColor = progressColor.CGColor;
    
}
- (void)setProgressFont:(UIFont *)progressFont
{
    self.progressLabel.font = progressFont;
}
-(void)setDescribeStr:(NSString *)describeStr{
    _describeStr = describeStr;
    self.describeLabel.text = describeStr;
}
-(void)setDescribeFont:(UIFont *)describeFont{
    _describeFont = describeFont;
    self.describeLabel.font = describeFont;
}
-(void)setProgressTextColor:(UIColor *)progressTextColor{
    _progressTextColor = progressTextColor;
    self.progressLabel.textColor = progressTextColor;
}
-(void)setDescribeTextColor:(UIColor *)describeTextColor{
    _describeTextColor = describeTextColor;
    self.describeLabel.textColor = describeTextColor;
}
-(void)setOutLayerColor:(UIColor *)outLayerColor{
    _outLayerColor = outLayerColor;
    self.outLayer.strokeColor = outLayerColor.CGColor;
}
-(void)setLinePreAngle:(CGFloat)preAngle lineSize:(CGSize)size color:(UIColor *)color{
    CALayer* linesLayer = [self _createLinesLayerWithFrame:self.bounds
                                                  preAngle:preAngle
                                                  lineSize:size
                                                     color:color];
    [self.layer addSublayer:linesLayer];
}
@end
