//
//  NSAttributedString+RUTextSizeStrings.m
//  Pods
//
//  Created by Benjamin Maer on 4/11/16.
//
//

#import "NSAttributedString+RUTextSizeStrings.h"

#import <RUTextSize/RUAttributesDictionaryBuilder.h>
#import <RUTextSize/UILabel+RUAttributesDictionaryBuilder.h>





@implementation NSAttributedString (RUTextSizeStrings)

#if (DEBUG || NSString_RUTextSizeStrings__Enable_DEBUG_Code)
#pragma mark - Unit Testing
+(nonnull instancetype)ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb
{
	UILabel* const label = [UILabel new];
	[label setTextAlignment:NSTextAlignmentCenter];

	NSMutableAttributedString* const attributedText = [NSMutableAttributedString new];

	RUAttributesDictionaryBuilder* const attributesDictionaryBuilder_emoji = [RUAttributesDictionaryBuilder new];
	[label ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder_emoji];
	[attributesDictionaryBuilder_emoji setFont:[UIFont systemFontOfSize:54.0f weight:UIFontWeightMedium]];

	[attributedText appendAttributedString:[[NSAttributedString alloc]initWithString:@"🎉"
																		  attributes:[attributesDictionaryBuilder_emoji attributesDictionary_generate]]];

	RUAttributesDictionaryBuilder* const attributesDictionaryBuilder_text = [RUAttributesDictionaryBuilder new];
	[label ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder_text];
	[attributesDictionaryBuilder_text setFont:[UIFont systemFontOfSize:13.0f]];
	[attributesDictionaryBuilder_text setTextColor:[UIColor blackColor]];

	[attributedText appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n\nPost Created"
																		  attributes:[attributesDictionaryBuilder_text attributesDictionary_generate]]];

	return [attributedText copy];
}
#endif

@end
