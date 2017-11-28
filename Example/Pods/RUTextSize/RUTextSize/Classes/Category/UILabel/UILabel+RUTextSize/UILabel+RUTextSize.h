//
//  UILabel+RUTextSize.h
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UILabel (RUTextSize)

#pragma mark - Text Size
-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ruTextSize;

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__NSAttributedString_RUTextSize_unitTest;
#endif

@end
