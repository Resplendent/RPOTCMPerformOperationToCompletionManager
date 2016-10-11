//
//  NSString+RUTextSizeStrings.m
//  Pods
//
//  Created by Benjamin Maer on 3/4/16.
//
//

#import "NSString+RUTextSizeStrings.h"





@implementation NSString (RUTextSizeStrings)

#if (DEBUG || NSString_RUTextSizeStrings__Enable_DEBUG_Code)
#pragma mark - Unit Testing
+(nonnull instancetype)ru_exampleString_longestTest
{
	return @"This text has to be sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo long, it takes up many lines. Hopefully this is long enough, but honestly, you never know.";
}
#endif

@end
