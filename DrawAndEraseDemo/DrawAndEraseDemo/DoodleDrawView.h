//
//  DoodleDrawView.h
//  DrawAndEraseDemo
//
//  Created by Victor Ji on 16/7/8.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DrawType) {
    DrawTypeNone,
    DrawTypeDraw,
    DrawTypeErase
};

@class DoodleDrawView;

@protocol DoodleDrawViewDelegate <NSObject>

@optional
- (void)doodleDrawView:(DoodleDrawView *)doodleDrawView lineStartEndDrawing:(DrawType)type startEnd:(BOOL)start lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor point:(CGPoint)point;
- (void)doodleDrawView:(DoodleDrawView *)doodleDrawView lineDrawingPoint:(CGPoint)point;

@end

@interface DoodleDrawView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <DoodleDrawViewDelegate> delegate;

// 自己的绘制
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat eraseWidth;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) DrawType type;

@property (assign, nonatomic) CGMutablePathRef path; // 自己正在画的路径
@property (strong, nonatomic) NSMutableArray *lines; // 自己画的涂鸦线条
@property (strong, nonatomic) NSMutableArray *currentLine; // 当前正在画的涂鸦

// 对方的绘制
@property (assign, nonatomic) CGPoint lastPoint;
@property (assign, nonatomic) DrawType peerDrawType;
@property (assign, nonatomic) CGFloat drawWidth;
@property (strong, nonatomic) UIColor *drawColor;

- (void)startDraw:(DrawType)type drawWidth:(CGFloat)drawWidth drawColor:(UIColor *)drawColor startPoint:(CGPoint)point;
- (void)drawToPoint:(CGPoint)point;
- (void)drawFinishToPoint:(CGPoint)point;
- (void)cleanDoodles;


//- (void)drawFrom:(CGPoint)startPoint To:(CGPoint)endPoint LineWidth:(CGFloat)width LineColor:(UIColor *)color;
//- (void)eraseFrom:(CGPoint)startPoint To:(CGPoint)endPoint LineWidth:(CGFloat)width;
//- (void)drawPath:(CGPathRef)path LineWidth:(CGFloat)width LineColor:(UIColor *)color;
//- (void)erasePath:(CGPathRef)path LineWidth:(CGFloat)width;
//- (void)clean;

@end
