//
//  BPOnePixLineView.m
//  BPCommon
//
//  Created by Huang Tao on 2/25/14.
//
//

#import "BPOnePixLineView.h"
#import "BPCoreUtil.h"

@implementation BPOnePixLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)setMode:(BPOnePixLineMode)mode
{
    _mode = mode;
    if (mode==BPOnePixLineModeHorizontal) {
        self.height = 1.f;
    } else {
        self.width = 1.f;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat bottomInset = [BPCoreUtil screenOnePixel]/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    // draw
    CGContextSetLineWidth(context, bottomInset*2);
    // _lineColor is the color of the 1 pixel height line
    if (!_lineColor) {
        _lineColor = [UIColor grayColor];
    }
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    if (_mode==BPOnePixLineModeHorizontal) {
        if (_direction == BPOnePixLineDirectionTopOrLeft) {
            CGContextMoveToPoint(context, 0, bottomInset);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), bottomInset);
        } else {
            CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-bottomInset);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-bottomInset);
        }
    } else {
        if (_direction == BPOnePixLineDirectionTopOrLeft) {
            CGContextMoveToPoint(context, bottomInset, 0);
            CGContextAddLineToPoint(context, bottomInset, CGRectGetHeight(rect));
        } else {
            CGContextMoveToPoint(context, CGRectGetWidth(rect)-bottomInset, 0);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect)-bottomInset, CGRectGetHeight(rect));
        }
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
