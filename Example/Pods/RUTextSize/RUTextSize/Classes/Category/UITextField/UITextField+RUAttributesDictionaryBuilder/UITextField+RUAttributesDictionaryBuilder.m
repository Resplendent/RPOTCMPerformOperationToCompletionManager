//
//  UITextField+RUAttributesDictionaryBuilder.m
//  Pods
//
//  Created by Benjamin Maer on 5/31/17.
//
//

#import "UITextField+RUAttributesDictionaryBuilder.h"
#import "RUAttributesDictionaryBuilder.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation UITextField (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	kRUConditionalReturn(attributesDictionaryBuilder == nil, YES);

	[self setFont:attributesDictionaryBuilder.font];
	[self setTextColor:attributesDictionaryBuilder.textColor];
	[self setTextAlignment:attributesDictionaryBuilder.textAlignment];
}

#pragma mark - apply
-(void)ru_apply_to_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	kRUConditionalReturn(attributesDictionaryBuilder == nil, YES);

	[attributesDictionaryBuilder setFont:self.font];
	[attributesDictionaryBuilder setTextColor:self.textColor];
	[attributesDictionaryBuilder setTextAlignment:self.textAlignment];
}

@end
