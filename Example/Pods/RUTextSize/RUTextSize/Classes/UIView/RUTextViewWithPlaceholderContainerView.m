//
//  RUTextViewWithPlaceholderContainerView.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUTextViewWithPlaceholderContainerView.h"
#import "UILabel+RUTextSize.h"
#import "UIView+RUUtility.h"
#import "RUConditionalReturn.h"
#import "UITextView+RUTextSize.h"





static void* kRUTextViewWithPlaceholderContainerView__KVOContext = &kRUTextViewWithPlaceholderContainerView__KVOContext;





@interface RUTextViewWithPlaceholderContainerView ()

#pragma mark - tapGesture
@property (nonatomic, readonly, nullable) UITapGestureRecognizer* tapGesture;
-(void)didTap_tapGesture;

#pragma mark - textView
-(UIEdgeInsets)textViewContentInset;

#pragma mark - KVO
-(void)ru_setKVORegistered_textView:(BOOL)registered;
-(void)ru_setKVORegistered_textViewPlaceholderLabel:(BOOL)registered;

@end





@implementation RUTextViewWithPlaceholderContainerView

#pragma mark - NSObject
-(void)dealloc
{
	[self ru_setKVORegistered_textView:NO];
	[self ru_setKVORegistered_textViewPlaceholderLabel:NO];
}

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		_tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap_tapGesture)];
		[self addGestureRecognizer:self.tapGesture];
		
		_textView = [UITextView new];
		[self.textView setDelegate:self];
		[self addSubview:self.textView];

		_textViewPlaceholderLabel = [UILabel new];
		[self addSubview:self.textViewPlaceholderLabel];

		[self ru_setKVORegistered_textView:YES];
		[self ru_setKVORegistered_textViewPlaceholderLabel:YES];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.textView setFrame:self.textViewFrame];
	[self.textView setContentInset:self.textViewContentInset];

	[self.textViewPlaceholderLabel setFrame:self.textViewPlaceholderLabelFrame];
}

#pragma mark - textView
-(void)setTextViewFrameInsets:(UIEdgeInsets)textViewFrameInsets
{
	kRUConditionalReturn(UIEdgeInsetsEqualToEdgeInsets(self.textViewFrameInsets, textViewFrameInsets), NO);

	_textViewFrameInsets = textViewFrameInsets;

	[self setNeedsLayout];
}

-(CGRect)textViewFrame
{
	return UIEdgeInsetsInsetRect(self.bounds, self.textViewFrameInsets);
}

-(UIEdgeInsets)textViewContentInset
{
	UIEdgeInsets textViewContentInset = self.textView.contentInset;

	if (self.centerTextVertically)
	{
		CGFloat deadSpace = (CGRectGetHeight(self.textView.bounds) - self.textView.contentSize.height);
		CGFloat verticalInset = MAX(0, deadSpace / 2.0f);
		textViewContentInset.top = verticalInset;
		textViewContentInset.bottom = verticalInset;
	}

	return textViewContentInset;
}

#pragma mark - textViewPlaceholderLabel
-(void)setTextViewPlaceholderLabelFrameInsets:(UIEdgeInsets)textViewPlaceholderLabelFrameInsets
{
	kRUConditionalReturn(UIEdgeInsetsEqualToEdgeInsets(self.textViewPlaceholderLabelFrameInsets, textViewPlaceholderLabelFrameInsets), NO);

	_textViewPlaceholderLabelFrameInsets = textViewPlaceholderLabelFrameInsets;

	[self setNeedsLayout];
}

-(void)setTextViewPlaceholderLabel_frame_offset:(UIOffset)textViewPlaceholderLabel_frame_offset
{
	kRUConditionalReturn(UIOffsetEqualToOffset(self.textViewPlaceholderLabel_frame_offset, textViewPlaceholderLabel_frame_offset), NO);

	_textViewPlaceholderLabel_frame_offset = textViewPlaceholderLabel_frame_offset;

	[self setNeedsLayout];
}

-(CGRect)textViewPlaceholderLabelFrame
{
	CGSize textSize = [self.textViewPlaceholderLabel ruTextSize];

	CGFloat yCoord = (self.centerTextVertically ?
					  CGRectGetVerticallyAlignedYCoordForHeightOnHeight(textSize.height, CGRectGetHeight(self.bounds)) :
					  0.0f);

	UIOffset textViewPlaceholderLabel_frame_offset = self.textViewPlaceholderLabel_frame_offset;

	CGRect textViewPlaceholderLabelFrame_beforeInsets = (CGRect){
		.origin.x		= textViewPlaceholderLabel_frame_offset.horizontal,
		.origin.y		= yCoord + textViewPlaceholderLabel_frame_offset.vertical,
		.size.width		= CGRectGetWidth(self.bounds),
		.size.height	= textSize.height,
	};

	return CGRectCeilOrigin(UIEdgeInsetsInsetRect(textViewPlaceholderLabelFrame_beforeInsets, self.textViewPlaceholderLabelFrameInsets));
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(nonnull UITextView*)textView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

-(void)textViewDidEndEditing:(nonnull UITextView*)theTextView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

-(void)textViewDidChange:(nonnull UITextView*)textView
{
	[self.textDelegate textViewWithPlaceholderContainerView:self textViewDidChangeText:self.textView.text];
}

-(BOOL)textView:(nonnull UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString*)text
{
	if (self.textShouldChangeDelegate)
	{
		return [self.textShouldChangeDelegate textViewWithPlaceholderContainerView:self
														   shouldChangeTextInRange:range
																   replacementText:text];
	}

	return YES;
}

#pragma mark - Update Content
-(void)updateTextViewPlaceholderLabelVisilibity
{
	[self.textViewPlaceholderLabel setHidden:((self.textView.text.length > 0) || self.textView.isFirstResponder)];
}

#pragma mark - KVO
-(void)ru_setKVORegistered_textView:(BOOL)registered
{
	typeof(self.textView) textView = self.textView;
	kRUConditionalReturn(textView == nil, NO);
	
	NSArray* propertiesToObserve = @[
									 @"text",
									 @"contentSize",
									 ];
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[textView addObserver:self
					   forKeyPath:propertyToObserve
						  options:(NSKeyValueObservingOptionInitial)
						  context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
		else
		{
			[textView removeObserver:self
						  forKeyPath:propertyToObserve
							 context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
	}
}

-(void)ru_setKVORegistered_textViewPlaceholderLabel:(BOOL)registered
{
	typeof(self.textViewPlaceholderLabel) textViewPlaceholderLabel = self.textViewPlaceholderLabel;
	kRUConditionalReturn(textViewPlaceholderLabel == nil, NO);
	
	NSArray* propertiesToObserve = @[
									 @"text",
									 ];
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[textViewPlaceholderLabel addObserver:self
									   forKeyPath:propertyToObserve
										  options:(NSKeyValueObservingOptionInitial)
										  context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
		else
		{
			[textViewPlaceholderLabel removeObserver:self
										  forKeyPath:propertyToObserve
											 context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kRUTextViewWithPlaceholderContainerView__KVOContext)
	{
		if (object == self.textView)
		{
			if ([keyPath isEqualToString:@"text"])
			{
				[self updateTextViewPlaceholderLabelVisilibity];
			}
			else if ([keyPath isEqualToString:@"contentSize"])
			{
				[self setNeedsLayout];
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else if (object == self.textViewPlaceholderLabel)
		{
			if ([keyPath isEqualToString:@"text"])
			{
				[self setNeedsLayout];
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - textView_centerTextVertically
-(void)setCenterTextVertically:(BOOL)centerTextVertically
{
	kRUConditionalReturn(self.centerTextVertically == centerTextVertically, NO);

	_centerTextVertically = centerTextVertically;

	[self setNeedsLayout];
}

#pragma mark - Gesture Actions
-(void)didTap_tapGesture
{
	[self.textView becomeFirstResponder];
}

@end
