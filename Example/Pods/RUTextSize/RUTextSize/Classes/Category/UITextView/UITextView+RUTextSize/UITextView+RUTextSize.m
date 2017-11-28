//
//  UITextView+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 1/16/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "UITextView+RUTextSize.h"
#import "NSAttributedString+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"
#import "UITextView+RUAttributesDictionaryBuilder.h"





@implementation UITextView (RUTextSize)

#pragma mark - Text Size
-(CGSize)ru_textSizeConstrainedToWidth:(CGFloat)width
{
	if (([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
		([self.text respondsToSelector:@selector(ruTextSizeWithBoundingWidth:attributes:)]))
	{
		RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[self ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder];
		return [self.text ruTextSizeWithBoundingWidth:width attributes:[attributesDictionaryBuilder attributesDictionary_generate]];
	}
	else if ([self respondsToSelector:@selector(attributedText)] &&
			 (self.attributedText.length))
	{
		return [self.attributedText ru_textSizeWithBoundingWidth:width];
	}
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
	}
}

-(CGSize)ru_textSize
{
	return [self ru_textSizeConstrainedToWidth:CGFLOAT_MAX];
}

@end
