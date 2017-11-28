//
//  RUAttributesDictionaryBuilder.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "RUAttributesDictionaryBuilder.h"
#import "NSMutableDictionary+RUUtil.h"
#import "RUClassOrNilUtil.h"
#import "RUConditionalReturn.h"
#import "RUSystemVersionUtils.h"

#if DEBUG
#import "NSString+RUTextSizeStrings.h"
#import <NSAttributedString+RUTextSize.h>
#endif

#import <CoreText/CoreText.h>





@implementation RUAttributesDictionaryBuilder

#if DEBUG
#pragma mark - Unit tests
+(void)load
{
	[self DEBUG__RUAttributesDictionaryBuilder_RUTextSize_kerning_unitTest];
}
#endif

#pragma mark - Properties
-(void)setProperty:(nullable id)propertyValue
	 attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	kRUConditionalReturn(RUAttributesDictionaryBuilder_attributeType__isInRange(attributeType) == false, YES);

	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_font:
			[self setFont:kRUClassOrNil(propertyValue, UIFont)];
			break;

		case RUAttributesDictionaryBuilder_attributeType_paragraphStyle:
		{
			NSParagraphStyle* const paragraphStyle = kRUClassOrNil(propertyValue, NSParagraphStyle);
			kRUConditionalReturn((propertyValue == nil) != (paragraphStyle != nil), YES);
			[self setLineBreakMode:paragraphStyle.lineBreakMode];
			[self setLineSpacing:@(paragraphStyle.lineSpacing)];
			[self setTextAlignment:paragraphStyle.alignment];
		}
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor:
			[self setTextColor:kRUClassOrNil(propertyValue, UIColor)];
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey:
		{
			NSNumber* const textColorShouldUseCoreTextKey = kRUNumberOrNil(propertyValue);
			kRUConditionalReturn((propertyValue == nil) != (textColorShouldUseCoreTextKey != nil), YES);

			[self setTextColorShouldUseCoreTextKey:textColorShouldUseCoreTextKey.boolValue];
		}
			break;

		case RUAttributesDictionaryBuilder_attributeType_kerning:
			[self setKerning:kRUNumberOrNil(propertyValue)];
			break;

		case RUAttributesDictionaryBuilder_attributeType_underline:
		{
			NSNumber* const underlineStyle_number = kRUNumberOrNil(propertyValue);
			NSAssert((propertyValue == nil) == (underlineStyle_number == nil), @"unhandled");

			[self setUnderlineStyle:(underlineStyle_number ? underlineStyle_number.integerValue : 0)];
		}
			break;

		case RUAttributesDictionaryBuilder_attributeType_strikethrough:
		{
			NSNumber* const strikethroughStyle_number = kRUNumberOrNil(propertyValue);
			NSAssert((propertyValue == nil) == (strikethroughStyle_number == nil), @"unhandled");

			[self setStrikethroughStyle:(strikethroughStyle_number ? strikethroughStyle_number.integerValue : 0)];
		}
			break;
	}
}

#pragma mark - Absorb
-(void)absorbPropertiesAttributesDictionary:(nonnull NSDictionary*)attributesDictionary
						   ignoreNilEntries:(BOOL)ignoreNilEntries
{
	for (RUAttributesDictionaryBuilder_attributeType attributeType = RUAttributesDictionaryBuilder_attributeType__first;
		 attributeType <= RUAttributesDictionaryBuilder_attributeType__last;
		 attributeType++)
	{
		NSString* const attributeKey = [[self class] attributeType_key_for_attributeType:attributeType];
		BOOL const attributeKey_use = (attributeKey != nil);
		if (attributeKey_use == false)
		{
			NSAssert(attributeKey_use, @"unhandled");
			continue;
		}

		id const attributeValue = [attributesDictionary objectForKey:attributeKey];

		if ((ignoreNilEntries == NO) ||
			(attributeValue != nil))
		{
			[self setProperty:attributeValue
				attributeType:attributeType];
		}
	}
}

#pragma mark - attributesDictionary
-(nonnull NSDictionary<NSString*,id>*)attributesDictionary_generate
{
	NSMutableDictionary<NSString*,id>* const attributesDictionary = [NSMutableDictionary<NSString*,id> dictionary];

	for (RUAttributesDictionaryBuilder_attributeType attributeType = RUAttributesDictionaryBuilder_attributeType__first;
		 attributeType <= RUAttributesDictionaryBuilder_attributeType__last;
		 attributeType++)
	{
		id const value = [self attributesDictionary_value_for_attributeType:attributeType];
		[attributesDictionary setObjectOrRemoveIfNil:value
											  forKey:[[self class] attributeType_key_for_attributeType:attributeType]];

		NSDictionary<NSString*,id>* const extraValues = [self attributesDictionary_extraValues_for_value:value
																						   attributeType:attributeType];
		if (extraValues)
		{
			[attributesDictionary addEntriesFromDictionary:extraValues];
		}
	}

	return [NSDictionary<NSString*,id> dictionaryWithDictionary:attributesDictionary];
}

-(nullable id)attributesDictionary_value_for_attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_font:
			return self.font;
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_paragraphStyle:
		{
			NSMutableParagraphStyle* const style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			[style setLineBreakMode:self.lineBreakMode];
			[style setAlignment:self.textAlignment];
			
			if (self.lineSpacing)
			{
				[style setLineSpacing:self.lineSpacing.floatValue];
			}

			return style;
		}
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_textColor:
			return
			(
			 self.textColorShouldUseCoreTextKey
			 ?
			 nil
			 :
			 self.textColor
			 );
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey:
			return
			(
			 self.textColorShouldUseCoreTextKey
			 ?
			 self.textColor
			 :
			 nil
			 );
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_kerning:
			return self.kerning;
			break;

		case RUAttributesDictionaryBuilder_attributeType_underline:
		{
			NSUnderlineStyle const underlineStyle = self.underlineStyle;
			return (underlineStyle == 0 ? nil : @(underlineStyle));
		}
			break;

		case RUAttributesDictionaryBuilder_attributeType_strikethrough:
		{
			NSUnderlineStyle const strikethroughStyle = self.strikethroughStyle;
			return (strikethroughStyle == 0 ? nil : @(strikethroughStyle));
		}
			break;
	}

	NSAssert(false, @"unhandled attributeType %li",attributeType);
	return nil;
}

-(nullable NSDictionary<NSString*,id>*)attributesDictionary_extraValues_for_value:(nullable id)value
																	attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_strikethrough:
		{
			/*
			 There seems to be a bug on iOS 10.3.x where strikethrough doesn't work in a few scenarios:
			 1) Text has more than one line.
			 2) Strikethrough applies to only some of the text in a string.
			 
			 Open Radar ticket:
			 http://www.openradar.me/31174934
			 
			 Discussed:
			 https://stackoverflow.com/questions/43112345/ios-10-3-nsstrikethroughstyleattributename-is-not-rendered
			 */
			if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.3")
				&&
				SYSTEM_VERSION_LESS_THAN(@"10.4"))
			{
				kRUConditionalReturn_ReturnValueNil(value == nil, NO);

				return
				@{
				  NSBaselineOffsetAttributeName		: @(0),
				  };
			}
		}
			break;

		default:
			break;
	}

	return nil;
}

#pragma mark - attributeType
+(nullable NSString*)attributeType_key_for_attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_font:
			return NSFontAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_paragraphStyle:
			return NSParagraphStyleAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor:
			return NSForegroundColorAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey:
			return (
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-bool-conversion"
					((&kCTForegroundColorAttributeName) != nil) ?
#pragma clang diagnostic pop
					(NSString *)kCTForegroundColorAttributeName :
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
					[self attributeType_key_for_attributeType:RUAttributesDictionaryBuilder_attributeType_textColor]);
#pragma clang diagnostic pop
			break;

		case RUAttributesDictionaryBuilder_attributeType_kerning:
			return NSKernAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_underline:
			return NSUnderlineStyleAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_strikethrough:
			return NSStrikethroughStyleAttributeName;
			break;
	}

	NSAssert(false, @"unhandled attributeType %li",attributeType);
	return nil;
}

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__RUAttributesDictionaryBuilder_RUTextSize_kerning_unitTest
{
	NSString* const superLongText= [NSString ru_exampleString_longestTest];

	CGFloat const boundedWidth = 100.0f;

	RUAttributesDictionaryBuilder* const attributes = [RUAttributesDictionaryBuilder new];
	[attributes setFont:[UIFont systemFontOfSize:24.0f]];

	NSAttributedString* const non_kerned_string = [[NSAttributedString alloc] initWithString:superLongText attributes:[attributes attributesDictionary_generate]];

	CGSize const non_kerned_size = [non_kerned_string ru_textSizeWithBoundingWidth:boundedWidth];

	[attributes setKerning:@(10)];

	NSAttributedString* const kerned_string = [[NSAttributedString alloc] initWithString:superLongText attributes:[attributes attributesDictionary_generate]];

	CGSize const kerned_size = [kerned_string ru_textSizeWithBoundingWidth:boundedWidth];

	NSAssert((CGSizeEqualToSize(non_kerned_size, kerned_size) == false), @"These should be different sizes");
}
#endif

@end
