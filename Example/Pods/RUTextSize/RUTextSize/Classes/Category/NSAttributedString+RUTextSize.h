//
//  NSAttributedString+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/4/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface NSAttributedString (RUTextSize)

#pragma mark - Text Size
-(CGSize)ru_textSizeWithBoundingWidth:(CGFloat)boundingWidth;

#pragma mark - Attributed String With
-(nullable NSAttributedString*)ru_attributedStringWithAttributesAppliedToBlankGaps:(nonnull NSDictionary<NSString *,id>*)attributesToAdd;

#if DEBUG
#pragma mark - Unit Testing
-(BOOL)DEBUG__NSAttributedString_RUTextSize_unitTest_withBoundingSize:(CGSize)boundingSize
													 textBoundingRect:(CGRect)textBoundingRect
															  options:(NSStringDrawingOptions)options;
-(nullable NSString*)DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage_withBoundingSize:(CGSize)boundingSize
																				textBoundingRect:(CGRect)textBoundingRect
																						 options:(NSStringDrawingOptions)options;
#endif

@end
