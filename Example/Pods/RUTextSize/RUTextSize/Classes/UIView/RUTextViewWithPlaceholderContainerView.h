//
//  RUTextViewWithPlaceholderContainerView.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUTextViewWithPlaceholderContainerViewProtocols.h"





@interface RUTextViewWithPlaceholderContainerView : UIView <UITextViewDelegate>

#pragma mark - textView
/*
 If using `centerTextVertically`, `textView`'s contentInset's top and bottom are used by this class, and shouldn't be used externally.
 */
@property (nonatomic, readonly, nullable) UITextView* textView;
@property (nonatomic, assign) UIEdgeInsets textViewFrameInsets;
-(CGRect)textViewFrame;

#pragma mark - textViewPlaceholderLabel
@property (nonatomic, readonly, nullable) UILabel* textViewPlaceholderLabel;
@property (nonatomic, assign) UIEdgeInsets textViewPlaceholderLabelFrameInsets;

/**
 Used to offset textViewPlaceholderLabelFrame.
 */
@property (nonatomic, assign) UIOffset textViewPlaceholderLabel_frame_offset;

/*
 Getter method `textViewPlaceholderLabelFrame`
  - takes up the entire width of the view, before insets. Makes it ideal for centering text with native `textAlignment` property
  - ceils the origin, so that text is always on an integer value.
 */
-(CGRect)textViewPlaceholderLabelFrame;
-(void)updateTextViewPlaceholderLabelVisilibity;

#pragma mark - centerTextVertically
/*
 Applies to `textView` and `textViewPlaceholderLabel`.
 
 Uses `textView`'s contentInset's top and bottom. So, if `centerTextVertically` is set to YES, you don't want to also be using `textView`'s contentInset's top and bottom.
 */
@property (nonatomic, assign) BOOL centerTextVertically;

#pragma mark - textDelegate
@property (nonatomic, assign, nullable) id<RUTextViewWithPlaceholderContainerView_textDelegate> textDelegate;

#pragma mark - textShouldChangeDelegate
@property (nonatomic, assign, nullable) id<RUTextViewWithPlaceholderContainerView_textShouldChangeDelegate> textShouldChangeDelegate;

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(nonnull UITextView*)textView;
-(void)textViewDidEndEditing:(nonnull UITextView*)theTextView;
-(void)textViewDidChange:(nonnull UITextView*)textView;

@end
