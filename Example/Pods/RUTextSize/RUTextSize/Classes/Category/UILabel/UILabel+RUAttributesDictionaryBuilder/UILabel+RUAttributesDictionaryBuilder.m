//
//  UILabel+RUAttributesDictionaryBuilder.m
//  Nifti
//
//  Created by Benjamin Maer on 12/12/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UILabel+RUAttributesDictionaryBuilder.h"
#import "RUAttributesDictionaryBuilder.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation UILabel (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder;
{
	kRUConditionalReturn(attributesDictionaryBuilder == nil, YES);

	[self setFont:attributesDictionaryBuilder.font];
	[self setTextColor:attributesDictionaryBuilder.textColor];
	[self setLineBreakMode:attributesDictionaryBuilder.lineBreakMode];
	[self setTextAlignment:attributesDictionaryBuilder.textAlignment];
}

#pragma mark - apply
-(void)ru_apply_to_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	kRUConditionalReturn(attributesDictionaryBuilder == nil, YES);

	[attributesDictionaryBuilder setFont:self.font];
	[attributesDictionaryBuilder setTextColor:self.textColor];
	[attributesDictionaryBuilder setLineBreakMode:self.lineBreakMode];
	[attributesDictionaryBuilder setTextAlignment:self.textAlignment];
}

@end
