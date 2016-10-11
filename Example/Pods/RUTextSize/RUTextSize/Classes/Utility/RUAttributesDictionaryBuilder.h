//
//  RUAttributesDictionaryBuilder.h
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "RUAttributesDictionaryBuilder_attributeTypes.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface RUAttributesDictionaryBuilder : NSObject

#pragma mark - Properties
@property (nonatomic, strong, nullable) UIFont* font;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, strong, nullable) NSNumber* lineSpacing;
@property (nonatomic, strong, nullable) UIColor* textColor;
@property (nonatomic, assign) BOOL textColorShouldUseCoreTextKey;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong, nullable) NSNumber* kerning;

-(void)setProperty:(nullable id)propertyValue
	 attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType;

#pragma mark - Absorb
-(void)absorbPropertiesFromLabel:(nonnull UILabel*)label;
-(void)absorbPropertiesFromButton:(nonnull UIButton*)button;
-(void)absorbPropertiesFromTextField:(nonnull UITextField*)textField;
-(void)absorbPropertiesFromTextView:(nonnull UITextView*)textView;
-(void)absorbPropertiesAttributesDictionary:(nonnull NSDictionary*)attributesDictionary
						   ignoreNilEntries:(BOOL)ignoreNilEntries;

#pragma mark - Create
-(nullable NSDictionary*)createAttributesDictionary;

#pragma mark - Attribute Type
+(nonnull NSString*)attributeTypeKeyForEnum:(RUAttributesDictionaryBuilder_attributeType)attributeType;

@end
