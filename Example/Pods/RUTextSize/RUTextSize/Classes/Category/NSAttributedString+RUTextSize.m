//
//  NSAttributedString+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/4/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSAttributedString+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"

#import <ResplendentUtilities/RUConstants.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation NSAttributedString (RUTextSize)

#pragma mark - Text Size
- (CGSize)ru_textSizeWithBoundingWidth:(CGFloat)boundingWidth
{
	if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)])
	{
		CGSize boundingSize = (CGSize){
			.width		= boundingWidth,
			.height		= CGFLOAT_MAX,
		};
		
		__block NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
		NSString* const attributeName_paragraphStyle = [RUAttributesDictionaryBuilder attributeType_key_for_attributeType:RUAttributesDictionaryBuilder_attributeType_paragraphStyle];

		[self enumerateAttributesInRange:NSMakeRange(0, self.length)
								 options:0
							  usingBlock:
		 ^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

			 NSParagraphStyle* const paragraphStyle = [attrs objectForKey:attributeName_paragraphStyle];

			 if (paragraphStyle)
			 {
				 switch (paragraphStyle.lineBreakMode)
				 {
					 case NSLineBreakByWordWrapping:
					 case NSLineBreakByCharWrapping:
					 {
						 options |= (NSStringDrawingTruncatesLastVisibleLine);
						 *stop = YES;
						 
					 }
						 break;
						 
					 default:
						 break;
				 }
			 }

		 }];
		CGRect const textBoundingRect = [self boundingRectWithSize:boundingSize options:options context:nil];
		
		NSAssert([self DEBUG__NSAttributedString_RUTextSize_unitTest_withBoundingSize:boundingSize
																	 textBoundingRect:textBoundingRect
																			  options:options], @"unhandled");
		
		return (CGSize){
			.width	= CGRectGetMaxX(textBoundingRect),
			.height = CGRectGetMaxY(textBoundingRect)
		};
	}
	else
	{
		NSAssert(false, @"not supported");
		return CGSizeZero;
	}
	
}

#pragma mark - Attributed String With
-(nullable NSAttributedString*)ru_attributedStringWithAttributesAppliedToBlankGaps:(nonnull NSDictionary<NSString *,id>*)attributesToAdd
{
	kRUConditionalReturn_ReturnValueNil(attributesToAdd == nil, YES);
	kRUConditionalReturn_ReturnValueNil(attributesToAdd.count == 0, NO);

	NSMutableAttributedString* mutableAttributedText = [NSMutableAttributedString new];
	
	[self enumerateAttributesInRange:NSMakeRange(0, self.length)
							 options:(0)
						  usingBlock:
	 ^(NSDictionary<NSString *,id> * _Nonnull attributes_existing, NSRange range, BOOL * _Nonnull stop) {
		 
		 NSMutableDictionary* attributes_new = [NSMutableDictionary dictionary];
		 BOOL attributes_existing_useOld = (attributes_existing != nil);
		 if (attributes_existing_useOld)
		 {
			 [attributes_new addEntriesFromDictionary:attributes_existing];
		 }

		 [attributesToAdd enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

			 if ([attributes_new objectForKey:key] == nil)
			 {
				 [attributes_new setObject:obj forKey:key];
			 }

		 }];
		 
		 [mutableAttributedText appendAttributedString:[[NSAttributedString alloc]initWithString:[[self string]substringWithRange:range]
																					  attributes:[attributes_new copy]]];
		 
	 }];

	return [[NSAttributedString alloc]initWithAttributedString:mutableAttributedText];
}

#if DEBUG
#pragma mark - Unit Testing
-(BOOL)DEBUG__NSAttributedString_RUTextSize_unitTest_withBoundingSize:(CGSize)boundingSize
													 textBoundingRect:(CGRect)textBoundingRect
															  options:(NSStringDrawingOptions)options
{
	NSString* DEBUG__unitTest_errorMessage = [self DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage_withBoundingSize:boundingSize
																											  textBoundingRect:textBoundingRect
																													   options:options];
	if (DEBUG__unitTest_errorMessage)
	{
		NSAssert(false, DEBUG__unitTest_errorMessage);
		return NO;
	}
	
	return YES;
}

-(nullable NSString*)DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage_withBoundingSize:(CGSize)boundingSize
																				textBoundingRect:(CGRect)textBoundingRect
																						 options:(NSStringDrawingOptions)options
{
	if (CGRectGetWidth(textBoundingRect) <= boundingSize.width)
	{
		CGRect const textRect_withoutBounding = [self boundingRectWithSize:CGSizeZero options:options context:nil];
		if (CGRectGetWidth(textRect_withoutBounding) > CGRectGetWidth(textBoundingRect))
		{
			/**
			 We need `horizontalTolerance` because sometimes `boundingRectWithSize:options:context:` returns a different size.width based on the constraint.
			 */
			CGFloat const horizontalTolerance = 0.0001f;
			if (CGRectGetHeight(textBoundingRect) + horizontalTolerance <= CGRectGetHeight(textRect_withoutBounding))
			{
				return RUStringWithFormat(@"attributed string %@ had bounding width %f, which produced a textBoundingRect %@ which was bounded, yet textRect_withoutBounding %@ had the same height. It should be taller.",self,boundingSize.width,NSStringFromCGRect(textBoundingRect),NSStringFromCGRect(textRect_withoutBounding));
			}
		}
	}
	
	return nil;
}
#endif

@end
