//
//  TagView.m
//  LabelMe_work
//
//  Created by David Way on 4/4/12.
//  Updated by Josep Marc Mingot.
//  Copyright (c) 2012 CSAIL. All rights reserved.
//


#import "TagView.h"


#define kLineWidth 6
#define kExteriorBox 0
#define kUpperLeft 1
#define kUpperRight 2
#define kLowerLeft 3
#define kLowerRight 4
#define kInteriorBox 5

#define kUIViewAutoresizingFlexibleHeighWidth   \
UIViewAutoresizingFlexibleWidth           | \
UIViewAutoresizingFlexibleHeight



@interface TagView()
{
    BOOL _touchIsMoving;
    BOOL _touchIsResizing;
}
@end


@implementation TagView


#pragma mark -
#pragma mark Initialization


- (void) initialize
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    _touchIsMoving = NO;
    _touchIsResizing = NO;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) [self initialize];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self initialize];
    return self;
}



#pragma mark -
#pragma mark Public Methods


- (void) addBoxInView
{
    CGPoint newUpperLeft = CGPointMake(0.3, 0.3);
    CGPoint newLowerRight = CGPointMake(0.7, 0.7);
    
    Box *newBox = [[Box alloc] initWithUpperLeft:newUpperLeft lowerRight:newLowerRight];
    self.box = newBox;
}




#pragma mark -
#pragma mark Draw Rect

- (void) drawRect:(CGRect)rect
{
    self.box.lineWidth = kLineWidth/self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint upperLeft = CGPointMake(self.box.upperLeft.x*self.frame.size.width, self.box.upperLeft.y*self.frame.size.height);
    CGPoint lowerRight = CGPointMake(self.box.lowerRight.x*self.frame.size.width, self.box.lowerRight.y*self.frame.size.height);
    CGPoint upperRight = CGPointMake(self.box.lowerRight.x*self.frame.size.width, self.box.upperLeft.y*self.frame.size.height);
    CGPoint lowerLeft = CGPointMake(self.box.upperLeft.x*self.frame.size.width, self.box.lowerRight.y*self.frame.size.height);
    
    CGRect boxRect = CGRectMake(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
    
    // DRAW ALL THE SCREEN
    if(self.translucentBackground){
        UIColor *backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [backgroundColor setFill];
        UIRectFill(self.frame);
        
        [[UIColor clearColor] setFill];
        UIRectFill(boxRect);
    }
    
    // DRAW RECT
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, self.window.tintColor.CGColor);
    CGContextStrokeRect(context, boxRect);
    
    // DRAW CORNERS
    float radius = 3.0;
    CGContextSetFillColorWithColor(context, self.window.tintColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(upperLeft.x - radius*kLineWidth,
                                                     upperLeft.y - radius*kLineWidth,
                                                     2*radius*kLineWidth, 2*radius*kLineWidth));
    CGContextFillEllipseInRect(context, CGRectMake(lowerRight.x - radius*kLineWidth,
                                                     lowerRight.y - radius*kLineWidth,
                                                     2*radius*kLineWidth, 2*radius*kLineWidth));
    CGContextFillEllipseInRect(context, CGRectMake(upperRight.x - radius*kLineWidth,
                                                     upperRight.y - radius*kLineWidth,
                                                     2*radius*kLineWidth, 2*radius*kLineWidth));
    CGContextFillEllipseInRect(context, CGRectMake(lowerLeft.x - radius*kLineWidth,
                                                     lowerLeft.y - radius*kLineWidth,
                                                     2*radius*kLineWidth, 2*radius*kLineWidth));
}

#pragma mark -
#pragma mark Touch Event Delegate

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [self unitaryPointForPoint:location insideFrame:self.frame];
    
    int corner = [self.box touchAtPoint:location];
    
    if(corner == kInteriorBox){
        _touchIsMoving = YES;
        [self.box moveBeginAtPoint:location];
        
    }else if(corner == kExteriorBox){
        [self endEditing:YES];
        
    }else{
        _touchIsResizing = YES;
        [self.box resizeBeginAtPoint:location];
    }
    
    [self.delegate isObjectMoving:YES];
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [self unitaryPointForPoint:location insideFrame:self.frame];
    
    Box *currentBox = self.box;
    if (_touchIsMoving) [currentBox moveToPoint:location];
    else if (_touchIsResizing) [currentBox resizeToPoint:location];
    
    [self setNeedsDisplay];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((_touchIsMoving) || (_touchIsResizing)){
        [self.delegate isObjectMoving:NO];
    }
    _touchIsMoving = NO;
    _touchIsResizing = NO;
    
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Private Methods

- (CGPoint) unitaryPointForPoint:(CGPoint)point insideFrame:(CGRect)frame
{
    CGPoint unitaryPoint = CGPointMake(point.x/frame.size.width, point.y/frame.size.height);
    return unitaryPoint;
}


@end