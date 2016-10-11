//
//  UILabel+RUTextSize.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "UILabel+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"
#import "NSAttributedString+RUTextSize.h"

#if DEBUG
#import "NSString+RUTextSizeStrings.h"
#import "NSAttributedString+RUTextSizeStrings.h"
#endif





@implementation UILabel (RUTextSize)

#pragma mark - Text Size
-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width
{
	if ([self respondsToSelector:@selector(attributedText)] &&
		(self.attributedText.length))
	{
		RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[attributesDictionaryBuilder absorbPropertiesFromLabel:self];

		NSAttributedString* attributedText_withAddedAttributesFromLabel = [self.attributedText ru_attributedStringWithAttributesAppliedToBlankGaps:[attributesDictionaryBuilder createAttributesDictionary]];

		return [(attributedText_withAddedAttributesFromLabel ?: self.attributedText) ru_textSizeWithBoundingWidth:width];
	}
	else if (([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
		([self.text respondsToSelector:@selector(ruTextSizeWithBoundingWidth:attributes:)]))
	{
		RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[attributesDictionaryBuilder absorbPropertiesFromLabel:self];
		return [self.text ruTextSizeWithBoundingWidth:width attributes:[attributesDictionaryBuilder createAttributesDictionary]];
	}
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
#pragma clang diagnostic pop
	}
}

-(CGSize)ruTextSize
{
	return [self ruTextSizeConstrainedToWidth:CGFLOAT_MAX];
}

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__NSAttributedString_RUTextSize_unitTest
{
	NSString* superLongText = [NSString ru_exampleString_longestTest];
	
	UILabel* debugLabel = [UILabel new];
	[debugLabel setFont:[UIFont systemFontOfSize:24.0f]];
	[debugLabel setText:superLongText];
	[debugLabel setLineBreakMode:NSLineBreakByWordWrapping];
	
	CGFloat const boundedWidth = 100.0f;

	[debugLabel ruTextSizeConstrainedToWidth:boundedWidth];

	NSAttributedString* ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb = [NSAttributedString ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb];
	[debugLabel setAttributedText:ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb];
	[debugLabel ruTextSizeConstrainedToWidth:boundedWidth];
}
#endif

@end
