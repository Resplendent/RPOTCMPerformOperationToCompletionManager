//
//  NSString+RUTextSizeStrings.h
//  Pods
//
//  Created by Benjamin Maer on 3/4/16.
//
//

#import <Foundation/Foundation.h>





@interface NSString (RUTextSizeStrings)

#if (DEBUG || NSString_RUTextSizeStrings__Enable_DEBUG_Code)
#pragma mark - Unit Testing
+(nonnull instancetype)ru_exampleString_longestTest;
#endif

@end
