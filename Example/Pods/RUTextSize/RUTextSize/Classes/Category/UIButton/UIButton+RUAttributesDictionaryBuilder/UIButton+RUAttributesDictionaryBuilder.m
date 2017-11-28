//
//  UIButton+RUAttributesDictionaryBuilder.m
//  Pods
//
//  Created by Benjamin Maer on 5/31/17.
//
//

#import "UIButton+RUAttributesDictionaryBuilder.h"
#import "UILabel+RUAttributesDictionaryBuilder.h"





@implementation UIButton (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	[self.titleLabel ru_absorb_attributesDictionaryBuilder:attributesDictionaryBuilder];
}

#pragma mark - apply
-(void)ru_apply_to_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	[self.titleLabel ru_apply_to_attributesDictionaryBuilder:attributesDictionaryBuilder];
}

@end
