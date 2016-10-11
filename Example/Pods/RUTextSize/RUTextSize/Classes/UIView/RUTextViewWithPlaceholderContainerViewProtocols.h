//
//  RUTextViewWithPlaceholderContainerViewProtocols.h
//  Shimmur
//
//  Created by Benjamin Maer on 1/24/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUTextViewWithPlaceholderContainerView;





@protocol RUTextViewWithPlaceholderContainerView_textDelegate <NSObject>

-(void)textViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView
					  textViewDidChangeText:(nullable NSString*)text;

@end





@protocol RUTextViewWithPlaceholderContainerView_textShouldChangeDelegate <NSObject>

-(BOOL)textViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView
					shouldChangeTextInRange:(NSRange)range
							replacementText:(nonnull NSString*)text;

@end
