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
#import "UILabel+RUAttributesDictionaryBuilder.h"

#if DEBUG
#import "NSString+RUTextSizeStrings.h"
#import "NSAttributedString+RUTextSizeStrings.h"
#endif





@implementation UILabel (RUTextSize)

#pragma mark - Text Size
-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width
{
	CGSize(^actions)(void (^ _Nullable attributesDictionaryBuilderBlock)(RUAttributesDictionaryBuilder* _Nonnull attributesDictionaryBuilder),
					  NSAttributedString* _Nullable  (^ _Nullable attributedStringBlock)(NSAttributedString* _Nonnull attributedString)) =
	^(void(^ _Nullable attributesDictionaryBuilderBlock)(RUAttributesDictionaryBuilder* _Nonnull attributesDictionaryBuilder),
	  NSAttributedString* _Nullable  (^ _Nullable attributedStringBlock)(NSAttributedString* _Nonnull attributedString)) {
		if ([self respondsToSelector:@selector(attributedText)] &&
			(self.attributedText.length))
		{
			RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
			[self ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder];

			if (attributesDictionaryBuilderBlock)
			{
				attributesDictionaryBuilderBlock(attributesDictionaryBuilder);
			}

			NSAttributedString* const attributedText = self.attributedText;
			NSAttributedString* const attributedText_withAddedAttributesFromLabel = [attributedText ru_attributedStringWithAttributesAppliedToBlankGaps:[attributesDictionaryBuilder attributesDictionary_generate]];
			NSAttributedString* const attributedString_toUse = (attributedText_withAddedAttributesFromLabel ?: attributedText);
			NSAttributedString* const attributedString_final =
			(attributedStringBlock ?
			 attributedStringBlock(attributedString_toUse) :
			 attributedString_toUse);

			return [attributedString_final ru_textSizeWithBoundingWidth:width];
		}
		else if (([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
				 ([self.text respondsToSelector:@selector(ruTextSizeWithBoundingWidth:attributes:)]))
		{
			RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
			[self ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder];

			if (attributesDictionaryBuilderBlock)
			{
				attributesDictionaryBuilderBlock(attributesDictionaryBuilder);
			}

			return [self.text ruTextSizeWithBoundingWidth:width attributes:[attributesDictionaryBuilder attributesDictionary_generate]];
		}
		else
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
#pragma clang diagnostic pop
		}
	};

	/**
	 The following code attempts to update attributes necessary to deal with the issue where lineBreakMode `NSLineBreakByTruncatingTail` won't give multiline height.
	 */
	NSLineBreakMode const lineBreakMode_old = self.lineBreakMode;
	BOOL const lineBreakMode_needsSwap = (lineBreakMode_old == NSLineBreakByTruncatingTail);
	if (lineBreakMode_needsSwap)
	{
		NSLineBreakMode const lineBreakMode_replacement = NSLineBreakByCharWrapping;
		return actions(^(RUAttributesDictionaryBuilder* _Nonnull attributesDictionaryBuilder){

			[attributesDictionaryBuilder setLineBreakMode:lineBreakMode_replacement];

		}, ^NSAttributedString* _Nullable(NSAttributedString* _Nonnull attributedString){

			NSMutableAttributedString* const mutableAttributedString = [NSMutableAttributedString new];
			NSString* const attributeName_paragraphStyle = [RUAttributesDictionaryBuilder attributeType_key_for_attributeType:RUAttributesDictionaryBuilder_attributeType_paragraphStyle];

			[attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length)
												 options:(0)
											  usingBlock:
			 ^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
				 
				 NSMutableDictionary<NSString*,id>* const attrs_new = [NSMutableDictionary<NSString*,id> dictionaryWithDictionary:attrs];
				 
				 NSParagraphStyle* const paragraphStyle = [attrs objectForKey:attributeName_paragraphStyle];
				 NSMutableParagraphStyle* const paragraphStyle_new = [paragraphStyle mutableCopy];
				 [paragraphStyle_new setLineBreakMode:lineBreakMode_replacement];

				 [attrs_new setObject:paragraphStyle_new forKey:attributeName_paragraphStyle];

				 [mutableAttributedString appendAttributedString:
				  [[NSAttributedString alloc]initWithString:[[attributedString attributedSubstringFromRange:range]string]
												 attributes:[NSDictionary<NSString *,id> dictionaryWithDictionary:attrs_new]]];

			 }];

			return [[NSAttributedString alloc]initWithAttributedString:mutableAttributedString];
		});
	}

	return actions(nil,nil);
}

-(CGSize)ruTextSize
{
	return [self ruTextSizeConstrainedToWidth:CGFLOAT_MAX];
}

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__NSAttributedString_RUTextSize_unitTest
{
	NSString* const superLongText = [NSString ru_exampleString_longestTest];

	UILabel* const debugLabel = [UILabel new];
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
