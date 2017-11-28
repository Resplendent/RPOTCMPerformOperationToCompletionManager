//
//  UILabel+RUAttributesDictionaryBuilder.h
//  Nifti
//
//  Created by Benjamin Maer on 12/12/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@class RUAttributesDictionaryBuilder;





@interface UILabel (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder;

#pragma mark - apply
-(void)ru_apply_to_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder;

@end
