//
//  RUAttributesDictionaryBuilder_attributeTypes.h
//  Pods
//
//  Created by Benjamin Maer on 4/7/16.
//
//

#ifndef RUAttributesDictionaryBuilder_attributeTypes_h
#define RUAttributesDictionaryBuilder_attributeTypes_h





typedef NS_ENUM(NSInteger, RUAttributesDictionaryBuilder_attributeType) {
	RUAttributesDictionaryBuilder_attributeType_font,
	RUAttributesDictionaryBuilder_attributeType_paragraphStyle,
	RUAttributesDictionaryBuilder_attributeType_textColor,
	RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey,
	RUAttributesDictionaryBuilder_attributeType_kerning,

	RUAttributesDictionaryBuilder_attributeType__first		= RUAttributesDictionaryBuilder_attributeType_font,
	RUAttributesDictionaryBuilder_attributeType__last		= RUAttributesDictionaryBuilder_attributeType_kerning,
};





#endif /* RUAttributesDictionaryBuilder_attributeTypes_h */
