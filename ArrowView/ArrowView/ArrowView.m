//
//  ArrowView.m
//  ArrowLabel
//
//  Created by renwei.chen on 2017/7.
//  Copyright © 2017年 renwei.chen. All rights reserved.
//

#import "ArrowView.h"

typedef enum : NSUInteger {
    kArcLeftTop,//左上角
    kArcRightTop,
    kArcRightBottom,
    kArcLeftBottom,
}ArrowPathArc;

/**
 添加圆角

 @param path 路径
 @param rect 圆角矩形边框
 @param arc 圆角位置
 @param cornerRadius 圆角半径
 */
static void PathAddArc(UIBezierPath*path,CGRect rect,ArrowPathArc arc , CGFloat cornerRadius){
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    switch (arc) {
        case kArcLeftTop:
        {
            [path addArcWithCenter:CGPointMake( x + cornerRadius, y + cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            break;
        }
        case kArcRightTop:{
            [path addArcWithCenter:CGPointMake( x + width - cornerRadius, y + cornerRadius) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            break;
        }
        case kArcLeftBottom:{
            [path addArcWithCenter:CGPointMake( x + cornerRadius,  y + height - cornerRadius) radius:cornerRadius  startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            break;
        }
        case kArcRightBottom:{
            [path addArcWithCenter:CGPointMake( x + width - cornerRadius, y + height - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2  clockwise:YES];
            break;
        }
    }
}


/**
 顺时针开始三角形三个点

 @param path 路径
 @param rect 依赖的圆角矩形
 @param direction 三角形方向
 @param offset 偏移位置
 @param arrowSize 三角形高度
 */
static void PathAddTriangle(UIBezierPath*path,CGRect rect,ArrowDirection direction,CGFloat offset ,CGFloat arrowSize){
    CGPoint p1 , p2 , p3;
    p1 = p2 = p3 = CGPointZero;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    switch (direction) {
        case ArrowDirectionUp:{
            p1.x = x + offset - arrowSize;
            p1.y = y;
            p2.x = x + offset;
            p2.y = y - arrowSize;
            p3.x = x + offset + arrowSize;
            p3.y = y;
            break;
        }
        case ArrowDirectionDown:{
            p1.x = x + offset + arrowSize;
            p1.y = y + height;
            p2.x = x + offset;
            p2.y = y + height + arrowSize;
            p3.x = x + offset - arrowSize;
            p3.y = y + height;
            break;
        }case ArrowDirectionLeft:{
            p1.x = x  ;
            p1.y = y + offset + arrowSize;
            p2.x = x - arrowSize;
            p2.y = y + offset ;
            p3.x = x ;
            p3.y = y +offset - arrowSize;
            break;
        }case ArrowDirectionRight:{
            p1.x = x + width;
            p1.y = y + offset - arrowSize;
            p2.x = x + width + arrowSize;
            p2.y = y + offset;
            p3.x = x + width;
            p3.y = y + offset + arrowSize;
            break;
        }
        default:{
            [path moveToPoint:CGPointMake(x+width*0.5, y)];
            return;
            break;
        }
    }
    
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
}


@interface ArrowView ()
{
    BOOL _valueInited;
    CAShapeLayer *_borderLayer;
}

@property(nonatomic,weak)UIView*contentView;
#if !ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
/**
 使用 Layer 渲染 ,默认使用 drawRect
 */
@property(nonatomic,assign)BOOL usingLayer;
#endif

@end

IB_DESIGNABLE
@implementation ArrowView


/**
 * 绘制所需路径
 * @return 路径
 */
-(UIBezierPath*)getBezierPath{
    UIBezierPath* path = [UIBezierPath bezierPath];
    if(self.fillColor!=nil || (self.strokeColor !=nil && self.strokWidth>0)) {
        CGSize size = self.bounds.size;
        float width = size.width;
        float height = size.height;
        CGFloat cornerRadius = self.cornerRadius;
        /*
         *      1        2
         *   8              3
         *
         *   7              4
         *      6        5
         **/
#define UIBezierPath_AddLineToPoint(path,x,y) [path addLineToPoint:CGPointMake(x, y)];
        CGFloat arrowSize = self.arrowSize;
        CGFloat offset = self.arrowOffsetXorY;
        CGRect drawRect = {{ 0.5*_strokWidth,0.5*_strokWidth},{ width-_strokWidth,height-_strokWidth}};
        switch (self.arrowDirection) {
            case ArrowDirectionUp:{
                //向下偏移 arrowSize
                drawRect.origin.y += arrowSize;
                drawRect.size.height -= arrowSize;
                
                PathAddTriangle(path, drawRect, self.arrowDirection, offset, arrowSize);
                PathAddArc(path , drawRect, kArcRightTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftTop, cornerRadius);
                break;
            }case ArrowDirectionDown:{
                drawRect.size.height -= arrowSize;
                
                PathAddTriangle(path, drawRect, self.arrowDirection, offset, arrowSize);
                PathAddArc(path , drawRect, kArcLeftBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightBottom, cornerRadius);
                
                break;
            }case ArrowDirectionLeft:{
                drawRect.origin.x += arrowSize;
                drawRect.size.width -= arrowSize;
                
                PathAddTriangle(path, drawRect, self.arrowDirection, offset, arrowSize);
                PathAddArc(path , drawRect, kArcLeftTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftBottom, cornerRadius);
                
                break;
            }case ArrowDirectionRight:{
                drawRect.size.width -= arrowSize;
                
                PathAddTriangle(path, drawRect, self.arrowDirection, offset, arrowSize);
                PathAddArc(path , drawRect, kArcRightBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightTop, cornerRadius);
                
                break;
            }
            default:{
                [path moveToPoint:CGPointMake(drawRect.origin.x +  cornerRadius, drawRect.origin.y)];
                PathAddArc(path , drawRect, kArcRightTop, cornerRadius);
                PathAddArc(path , drawRect, kArcRightBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftBottom, cornerRadius);
                PathAddArc(path , drawRect, kArcLeftTop, cornerRadius);
                break;
            }
        }
    }
    [path closePath];
    return path;
}

-(void)addSubview:(UIView *)view{
    [self setContentView:view];
}

-(void)setContentView:(UIView *)contentView{
#if !TARGET_INTERFACE_BUILDER
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
#endif
    _contentView = contentView;
    for (UIView*sub in self.subviews) {
        [sub removeFromSuperview];
    }
    [super addSubview:contentView];
    NSLayoutConstraint *layoutMarginTop = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0];
    NSLayoutConstraint *layoutMarginLeft = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeLeftMargin multiplier:1 constant:0];
    NSLayoutConstraint *layoutMarginBottom =[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0];
    NSLayoutConstraint *layoutMarginRight = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0];
    [self addConstraints:@[layoutMarginTop,layoutMarginLeft,layoutMarginRight,layoutMarginBottom]];
    _contentView.backgroundColor = [UIColor clearColor];
}

-(void)valueInit{
    if(!_valueInited){
        self.backgroundColor = [UIColor clearColor];
        self.arrowSize = 5;
        self.arrowDirection = ArrowDirectionDown;
        self.clearsContextBeforeDrawing = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.cornerRadius = 5;
#if ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
        //可选启用
        self.usingLayer = NO;
#elif ARROWVIEW_SHARELAYER_ENABLE
        //仅启用 layer
        self.usingLayer = YES;
#endif
    }
}

-(void)setUsingLayer:(BOOL)usingLayer{
    if(usingLayer!=_usingLayer){
        if(_borderLayer==nil){
            _borderLayer = [CAShapeLayer layer];
            _borderLayer.masksToBounds = YES;
            _borderLayer.lineCap = kCALineCapRound;
            _borderLayer.lineJoin = kCALineJoinRound;
            if(_strokeColor!=nil){
                _borderLayer.strokeColor = _strokeColor.CGColor;
            }
            if(_fillColor!=nil){
                _borderLayer.fillColor = _fillColor.CGColor;
            }
            _borderLayer.lineWidth = _strokWidth;
            [self.layer insertSublayer:_borderLayer atIndex:0];
        }else{
            [_borderLayer removeFromSuperlayer];
            _borderLayer = nil;
        }
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    _usingLayer = usingLayer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if( self = [super initWithFrame:frame]){
        [self valueInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self valueInit];
    }
    return self;
}

// 这个函数是专门为 xib设计的，会在渲染前设置你想要配置的属性。
- (void)prepareForInterfaceBuilder
{
    [self valueInit];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)updateConstraints{
    UIEdgeInsets inset = UIEdgeInsetsZero;
    switch (self.arrowDirection) {
        case ArrowDirectionUp:
        {
        inset.top += self.arrowSize;
        break;
        }case ArrowDirectionDown:{
            inset.bottom += self.arrowSize;
            break;
        }case ArrowDirectionLeft:{
            inset.left += self.arrowSize;
            break;
        }case ArrowDirectionRight:{
            inset.right += self.arrowSize;
            break;
        }
        default:
            break;
    }
    self.layoutMargins = inset;
    [super updateConstraints];
}

#if ARROWVIEW_SHARELAYER_ENABLE
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
#if ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
    if(self.usingLayer)
#endif
    {
        _borderLayer.frame = self.bounds;
        _borderLayer.path = [[self getBezierPath]CGPath];
        [self setNeedsDisplay];
    }
}
#endif

#if ARROWVIEW_DRAWRECT_ENABLE
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
#if ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
    if(!self.usingLayer)
#endif
        {
        UIBezierPath *path = [self getBezierPath];
        if(_fillColor){
            [_fillColor setFill];
            [path fill];
        }
        if(_strokWidth>0&& _strokeColor){
            [_strokeColor setStroke];
            [path setLineWidth:_strokWidth];
            [path stroke];
        }
    }
    
}
#endif

-(void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    _borderLayer.fillColor = fillColor.CGColor;
    [self setNeedsDisplay];
}

-(void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    _borderLayer.strokeColor = strokeColor.CGColor;
    [self setNeedsDisplay];
}

-(void)setStrokWidth:(CGFloat)strokWidth{
    _strokWidth = strokWidth;
    _borderLayer.lineWidth = strokWidth;
    [self setNeedsDisplay];
}

-(void)setArrowDirection:(NSInteger)arrowDirection{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)setArrowSize:(NSUInteger)arrowSize{
    _arrowSize = arrowSize;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)setArrowOffsetXorY:(CGFloat)arrowOffsetXorY{
    _arrowOffsetXorY = arrowOffsetXorY;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(NSUInteger)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


@end
