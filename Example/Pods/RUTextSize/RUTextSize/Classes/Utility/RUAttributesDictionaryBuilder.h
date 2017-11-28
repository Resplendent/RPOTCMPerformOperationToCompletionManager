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

@property (nonatomic, assign) NSUnderlineStyle underlineStyle;
@property (nonatomic, assign) NSUnderlineStyle strikethroughStyle;

-(void)setProperty:(nullable id)propertyValue
	 attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType;

#pragma mark - Absorb
-(void)absorbPropertiesAttributesDictionary:(nonnull NSDictionary*)attributesDictionary
						   ignoreNilEntries:(BOOL)ignoreNilEntries;

#pragma mark - attributesDictionary
-(nonnull NSDictionary<NSString*,id>*)attributesDictionary_generate;
-(nullable id)attributesDictionary_value_for_attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType;
-(nullable NSDictionary<NSString*,id>*)attributesDictionary_extraValues_for_value:(nullable id)value
																	attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType;

#pragma mark - attributeType
+(nullable NSString*)attributeType_key_for_attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType;

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__RUAttributesDictionaryBuilder_RUTextSize_kerning_unitTest;
#endif

@end
