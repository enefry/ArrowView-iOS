//
//  ArrowView.h
//  ArrowLabel
//
//  Created by renwei.chen on 2017/7.
//  Copyright © 2017年 renwei.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用绘制
#define ARROWVIEW_DRAWRECT_ENABLE 1
//使用 ShapeLayer
#define ARROWVIEW_SHARELAYER_ENABLE 1

//默认都启用
//#define ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE 1

#if ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
#define ARROWVIEW_DRAWRECT_ENABLE 1
#define ARROWVIEW_SHARELAYER_ENABLE 1
#endif

#if !ARROWVIEW_SHARELAYER_ENABLE && !ARROWVIEW_DRAWRECT_ENABLE
#define ARROWVIEW_DRAWRECT_ENABLE 1
#endif

//#define ARROWVIEW_SHARELAYER_ENABLE 1

// drawrect 和 layer 都可用
#if defined(ARROWVIEW_DRAWRECT_ENABLE) && defined(ARROWVIEW_SHARELAYER_ENABLE) && ARROWVIEW_DRAWRECT_ENABLE && ARROWVIEW_SHARELAYER_ENABLE
// 启用宏 ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
#if !ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
#define ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE 1
#endif

#endif


typedef enum : NSUInteger {
    ArrowDirectionNone = 0,
    ArrowDirectionUp = UIPopoverArrowDirectionUp,
    ArrowDirectionDown = UIPopoverArrowDirectionDown,
    ArrowDirectionLeft = UIPopoverArrowDirectionLeft,
    ArrowDirectionRight = UIPopoverArrowDirectionRight,
} ArrowDirection;

 IB_DESIGNABLE
@interface ArrowView : UIView

//default is GuardArrowDirectionDown
@property(nonatomic,assign)IBInspectable /*ArrowDirection*/NSInteger arrowDirection;

//default is 5
@property(nonatomic,assign)IBInspectable NSUInteger arrowSize;

/**
 * 偏移位置
 */
@property(nonatomic,assign)IBInspectable CGFloat arrowOffsetXorY;

/**
 * 圆角大小
 */
@property(nonatomic,assign)IBInspectable NSUInteger cornerRadius;

/**
 * 填充颜色
 */
@property(nonatomic,strong)IBInspectable UIColor *fillColor;

/**
 * 边框颜色
 */
@property(nonatomic,strong)IBInspectable UIColor *strokeColor;

/**
 *边框宽度
 */
@property(nonatomic,assign)IBInspectable CGFloat strokWidth;

#if ARROWVIEW_SHARELAYER_DRAWRECT_ENABLE
/**
 使用 Layer 渲染 ,默认使用 drawRect
 */
@property(nonatomic,assign)IBInspectable BOOL usingLayer;
#endif

-(void)setContentView:(UIView*)contentView;



@end
