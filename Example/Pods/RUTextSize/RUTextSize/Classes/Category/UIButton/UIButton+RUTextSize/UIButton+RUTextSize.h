//
//  UIButton+RUTextSize.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 8/18/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIButton (RUTextSize)

#pragma mark - Current Title Size
-(CGSize)ru_currentTitleTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ru_currentTitleTextSize;

#pragma mark - Current Attribed Title Size
-(CGSize)ru_currentAttributedTitleTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ru_currentAttributedTitleTextSize;

@end
