//
//  NSAttributedString+RUTextSizeStrings.h
//  Pods
//
//  Created by Benjamin Maer on 4/11/16.
//
//

#import <Foundation/Foundation.h>





@interface NSAttributedString (RUTextSizeStrings)

#if (DEBUG || NSString_RUTextSizeStrings__Enable_DEBUG_Code)
#pragma mark - Unit Testing
+(nonnull instancetype)ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb;
#endif

@end
