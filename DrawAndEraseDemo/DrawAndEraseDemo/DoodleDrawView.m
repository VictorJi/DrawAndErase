//
//  DoodleDrawView.m
//  DrawAndEraseDemo
//
//  Created by Victor Ji on 16/7/8.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "DoodleDrawView.h"

@implementation DoodleDrawView

#pragma mark - initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupProperties];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupProperties];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperties];
    }
    return self;
}

- (void)setupProperties {
    self.lines = [[NSMutableArray alloc] init];
    self.currentLine = [[NSMutableArray alloc] init];
    self.lastPoint = CGPointMake(-1, -1);
}

- (void)drawRect:(CGRect)rect {
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
}

- (CGRect)docViewSizeThatFits:(UIImage *)image {
    CGSize imgSize = image.size;
    CGFloat scal = self.frame.size.width / imgSize.width;
    NSInteger width = scal * imgSize.width;
    NSInteger height = scal * imgSize.height;
    return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
}


#pragma mark - draw actions

- (void)startDraw:(DrawType)type drawWidth:(CGFloat)drawWidth drawColor:(UIColor *)drawColor startPoint:(CGPoint)point {
    self.peerDrawType = type;
    self.drawWidth = drawWidth;
    self.drawColor = drawColor;
    self.lastPoint = [self convertPointToPointInView:point];
}

- (void)drawToPoint:(CGPoint)point {
    if (self.drawWidth <= 0 || self.lastPoint.x < 0 || self.lastPoint.y < 0) {
        return;
    }
    CGPoint viewPoint = [self convertPointToPointInView:point];
    if (self.peerDrawType == DrawTypeDraw) {
        [self drawFrom:self.lastPoint To:viewPoint LineWidth:self.drawWidth LineColor:self.drawColor];
    } else {
        [self eraseFrom:self.lastPoint To:viewPoint LineWidth:self.drawWidth];
    }
    self.lastPoint = viewPoint;
}

- (void)drawFinishToPoint:(CGPoint)point {
    if (self.drawWidth <= 0 || self.lastPoint.x < 0 || self.lastPoint.y < 0) {
        return;
    }
    CGPoint viewPoint = [self convertPointToPointInView:point];
    if (self.peerDrawType == DrawTypeDraw) {
        [self drawFrom:self.lastPoint To:viewPoint LineWidth:self.drawWidth LineColor:self.drawColor];
    } else if (self.peerDrawType == DrawTypeErase) {
        [self eraseFrom:self.lastPoint To:viewPoint LineWidth:self.drawWidth];
    }
    self.lastPoint = CGPointMake(-1, -1);
}

- (void)cleanDoodles {
    [self clean];
}

- (CGPoint)convertPointToPointInView:(CGPoint)point {
    return CGPointMake(self.bounds.size.width * point.x, self.bounds.size.height * point.y);
}

- (CGPoint)convertPointInViewToPercentMode:(CGPoint)point {
    return CGPointMake(point.x / self.bounds.size.width, point.y / self.bounds.size.height);
}

#pragma mark - draw actions

- (void)drawFrom:(CGPoint)startPoint To:(CGPoint)endPoint LineWidth:(CGFloat)width LineColor:(UIColor *)color {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)eraseFrom:(CGPoint)startPoint To:(CGPoint)endPoint LineWidth:(CGFloat)width {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)drawPath:(CGPathRef)path LineWidth:(CGFloat)width LineColor:(UIColor *)color {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)erasePath:(CGPathRef)path LineWidth:(CGFloat)width {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)clean {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:[self docViewSizeThatFits:self.image]];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

#pragma mark - track actions

- (void)startTrack:(CGPoint)point {
    if (self.path) CFRelease(self.path);
    self.path = CGPathCreateMutable();
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    NSValue *val = [NSValue valueWithCGPoint:point];
    [self.currentLine addObject:val];
    
    if (self.type > DrawTypeNone && self.delegate && [self.delegate respondsToSelector:@selector(doodleDrawView:lineStartEndDrawing:startEnd:lineWidth:lineColor:point:)]) {
        CGPoint percentPoint = [self convertPointInViewToPercentMode:point];
        [self.delegate doodleDrawView:self lineStartEndDrawing:self.type startEnd:YES lineWidth:self.type == DrawTypeDraw ? self.lineWidth : self.eraseWidth lineColor:self.type == DrawTypeDraw ? self.lineColor : nil point:percentPoint];
    }
}

- (void)trackPoint:(CGPoint)point {
    if (!self.currentLine) {
        return;
    }
    
    if (point.x < 0 || point.y < 0 || point.x > self.bounds.size.width || point.y > self.bounds.size.height) {
        return;
    }
    
    NSValue *lastPointValue = [self.currentLine lastObject];
    CGPoint lastPoint = [lastPointValue CGPointValue];
    CGPathAddQuadCurveToPoint(self.path, NULL, lastPoint.x, lastPoint.y, (point.x + lastPoint.x) / 2, (point.y + lastPoint.y) / 2);
    if (self.type == DrawTypeDraw) {
        [self drawPath:self.path LineWidth:self.lineWidth LineColor:self.lineColor];
    } else if (self.type == DrawTypeErase) {
        [self erasePath:self.path LineWidth:self.eraseWidth];
    }
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    [self.currentLine addObject:pointValue];
    
    if (self.type > DrawTypeNone && self.delegate && [self.delegate respondsToSelector:@selector(doodleDrawView:lineDrawingPoint:)]) {
        CGPoint percentPoint = [self convertPointInViewToPercentMode:point];
        [self.delegate doodleDrawView:self lineDrawingPoint:percentPoint];
    }
}

- (void)endTrack:(CGPoint)point {
    if (!self.currentLine) {
        return;
    }
    
    if (self.type > DrawTypeNone && self.delegate && [self.delegate respondsToSelector:@selector(doodleDrawView:lineStartEndDrawing:startEnd:lineWidth:lineColor:point:)]) {
        CGPoint percentPoint = [self convertPointInViewToPercentMode:point];
        [self.delegate doodleDrawView:self lineStartEndDrawing:self.type startEnd:NO lineWidth:self.type == DrawTypeDraw ? self.lineWidth : self.eraseWidth lineColor:self.type == DrawTypeDraw ? self.lineColor : nil point:percentPoint];
    }
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (event.allTouches.count > 1) return;
    NSMutableArray *currentLine = [[NSMutableArray alloc] init];
    self.currentLine = currentLine;
    CGPoint point = [[touches anyObject] locationInView:self];
    [self startTrack:point];
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (event.allTouches.count > 1) return;
    CGPoint point = [[touches anyObject] locationInView:self];
    [self trackPoint:point];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (event.allTouches.count > 1) return;
    CGPoint point = [[touches anyObject] locationInView:self];
    [self trackPoint:point];
    [self endTrack:point];
    [self.lines addObject:self.currentLine];
}

@end
