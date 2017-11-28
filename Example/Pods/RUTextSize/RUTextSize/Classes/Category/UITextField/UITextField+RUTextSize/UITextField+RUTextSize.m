//
//  UITextField+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UITextField+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"
#import "NSAttributedString+RUTextSize.h"
#import "UITextField+RUAttributesDictionaryBuilder.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation UITextField (RUTextSize)

#pragma mark - Text Size
-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width
{
	if ([self respondsToSelector:@selector(attributedText)] &&
		(self.attributedText.length))
	{
		return [self.attributedText ru_textSizeWithBoundingWidth:width];
	}
	else if (([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
			 ([self.text respondsToSelector:@selector(ruTextSizeWithBoundingWidth:attributes:)]))
	{
		RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[self ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder];

		return [self.text ruTextSizeWithBoundingWidth:width
										   attributes:[attributesDictionaryBuilder attributesDictionary_generate]];
	}
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
	}
}

-(CGSize)ruTextSize
{
	return [self ruTextSizeConstrainedToWidth:CGFLOAT_MAX];
}

@end
