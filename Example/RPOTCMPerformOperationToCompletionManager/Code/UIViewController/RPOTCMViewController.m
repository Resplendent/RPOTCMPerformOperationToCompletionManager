//
//  RPOTCMViewController.m
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Richard Reitzfeld on 06/16/2015.
//  Copyright (c) 2014 Richard Reitzfeld. All rights reserved.
//

#import "RPOTCMViewController.h"
#import "RPOTCMGetEndpointWithDelayRequest.h"
#import "RPOTCMPerformOperationToCompletionManager.h"

#import <ResplendentUtilities/UIView+RUUtility.h>
#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/RUConstants.h>

#import <RUTextSize/UILabel+RUTextSize.h>





@interface RPOTCMViewController () <RPOTCMGetEndpointWithDelayRequest_requestSuccessDelegate, RPOTCMGetEndpointWithDelayRequest_requestRetryDelegate>

#pragma mark - getEndpointWithDelayRequest
@property (nonatomic, strong, nullable) RPOTCMGetEndpointWithDelayRequest* getEndpointWithDelayRequest;

#pragma mark - retryAttemptCount
@property (nonatomic, assign) NSUInteger retryAttemptCount;

#pragma mark - sendRequestButton
@property (nonatomic, readonly, strong, nullable) UIBarButtonItem* sendRequestButton;
-(void)sendRequestButton_action_didFire;

#pragma mark - endpointTextField
@property (nonatomic, readonly, strong, nullable) UITextField* endpointTextField;
-(CGRect)endpointTextField_frame;

#pragma mark - retryAttemptCountLabel
@property (nonatomic, readonly, strong, nullable) UILabel* retryAttemptCountLabel;
-(CGRect)retryAttemptCountLabel_frame;
-(void)retryAttemptCountLabel_text_update;

#pragma mark - lastResponseLabel
@property (nonatomic, readonly, strong, nullable) UILabel* lastResponseLabel;
-(CGRect)lastResponseLabel_frame;
-(void)lastResponseLabel_text_update_with_responseString:(nullable NSString*)responseString;

@end





@implementation RPOTCMViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	[self setEdgesForExtendedLayout:UIRectEdgeNone];

	_sendRequestButton =
	[[UIBarButtonItem alloc]initWithTitle:@"Send"
									style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(sendRequestButton_action_didFire)];
	[self.navigationItem setRightBarButtonItem:self.sendRequestButton];

	_endpointTextField = [UITextField new];
	[self.endpointTextField setBackgroundColor:[UIColor clearColor]];
	[self.endpointTextField setTextColor:[UIColor darkTextColor]];
	[self.endpointTextField setFont:[UIFont systemFontOfSize:12.0f]];
	[self.endpointTextField setTextAlignment:NSTextAlignmentLeft];
	[self.endpointTextField setText:@"https://api.github.com/"];
	[self.view addSubview:self.endpointTextField];

	_retryAttemptCountLabel = [UILabel new];
	[self.retryAttemptCountLabel setBackgroundColor:[UIColor clearColor]];
	[self.retryAttemptCountLabel setTextAlignment:NSTextAlignmentLeft];
	[self.retryAttemptCountLabel setTextColor:[UIColor darkTextColor]];
	[self.retryAttemptCountLabel setFont:[UIFont systemFontOfSize:8.0f]];
	[self.view addSubview:self.retryAttemptCountLabel];
	[self retryAttemptCountLabel_text_update];

	_lastResponseLabel = [UILabel new];
	[self.lastResponseLabel setBackgroundColor:[UIColor clearColor]];
	[self.lastResponseLabel setTextAlignment:NSTextAlignmentLeft];
	[self.lastResponseLabel setTextColor:[UIColor darkTextColor]];
	[self.lastResponseLabel setFont:[UIFont systemFontOfSize:8.0f]];
	[self.lastResponseLabel setNumberOfLines:0];
	[self.view addSubview:self.lastResponseLabel];
	[self lastResponseLabel_text_update_with_responseString:nil];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	[self.endpointTextField setFrame:self.endpointTextField_frame];
	[self.retryAttemptCountLabel setFrame:self.retryAttemptCountLabel_frame];
	[self.lastResponseLabel setFrame:self.lastResponseLabel_frame];
}

#pragma mark - retryAttemptCount
-(void)setRetryAttemptCount:(NSUInteger)retryAttemptCount
{
	kRUConditionalReturn(self.retryAttemptCount == retryAttemptCount, NO);

	_retryAttemptCount = retryAttemptCount;

	[self retryAttemptCountLabel_text_update];
}

#pragma mark - sendRequestButton
-(void)sendRequestButton_action_didFire
{
	NSString* const URLString = self.endpointTextField.text;
	kRUConditionalReturn(URLString == nil, YES);

	NSURL* const URL = [NSURL URLWithString:URLString];
	if (URL == nil)
	{
		UIAlertController* const alertController =
		[UIAlertController alertControllerWithTitle:@"Oops!"
											message:RUStringWithFormat(@"URL `%@` is not valid",URL)
									 preferredStyle:UIAlertControllerStyleAlert];

		[alertController addAction:[UIAlertAction actionWithTitle:@"Okay."
															style:UIAlertActionStyleDefault
														  handler:nil]];

		[self presentViewController:alertController animated:YES completion:nil];

		return;
	}

	RPOTCMGetEndpointWithDelayRequest* const getEndpointWithDelayRequest = [[RPOTCMGetEndpointWithDelayRequest alloc]init_with_URL:URL];
	[getEndpointWithDelayRequest setRequestSuccessDelegate:self];
	[getEndpointWithDelayRequest setRequestRetryDelegate:self];
	[[RPOTCMPerformOperationToCompletionManager sharedInstance]addOperationToBePerformedToCompletion:getEndpointWithDelayRequest];
	[self setGetEndpointWithDelayRequest:getEndpointWithDelayRequest];
}

#pragma mark - getEndpointWithDelayRequest
-(void)setGetEndpointWithDelayRequest:(RPOTCMGetEndpointWithDelayRequest *)getEndpointWithDelayRequest
{
	kRUConditionalReturn(self.getEndpointWithDelayRequest == getEndpointWithDelayRequest, NO);

	_getEndpointWithDelayRequest = getEndpointWithDelayRequest;

	[self setRetryAttemptCount:0];
	[self lastResponseLabel_text_update_with_responseString:nil];
}

#pragma mark - endpointTextField
-(CGRect)endpointTextField_frame
{
	return CGRectCeilOrigin((CGRect){
		.size.width		= CGRectGetWidth(self.view.bounds),
		.size.height	= 44.0f,
	});
}

#pragma mark - retryAttemptCountLabel
-(CGRect)retryAttemptCountLabel_frame
{
	CGRect const endpointTextField_frame = self.endpointTextField_frame;

	CGSize const textSize = [self.retryAttemptCountLabel ruTextSize];

	return CGRectCeilOrigin((CGRect){
		.origin.y		= CGRectGetMaxY(endpointTextField_frame),
		.size.width		= CGRectGetWidth(self.view.bounds),
		.size.height	= textSize.height,
	});
}

-(void)retryAttemptCountLabel_text_update
{
	[self.retryAttemptCountLabel setText:RUStringWithFormat(@"Retries: %lu",(unsigned long)self.retryAttemptCount)];

	[self.view setNeedsLayout];
}

#pragma mark - lastResponseLabel
-(CGRect)lastResponseLabel_frame
{
	CGRect const retryAttemptCountLabel_frame = self.retryAttemptCountLabel_frame;

	CGSize const textSize = [self.lastResponseLabel ruTextSize];

	return CGRectCeilOrigin((CGRect){
		.origin.y		= CGRectGetMaxY(retryAttemptCountLabel_frame),
		.size.width		= CGRectGetWidth(self.view.bounds),
		.size.height	= textSize.height,
	});
}

-(void)lastResponseLabel_text_update_with_responseString:(nullable NSString*)responseString
{
	[self.lastResponseLabel setText:
	 (responseString ?
	  RUStringWithFormat(@"Response String:\n%@",responseString) :
	  nil)
	 ];

	[self.view setNeedsLayout];
}

#pragma mark - RPOTCMGetEndpointWithDelayRequest_requestSuccessDelegate
-(void)getEndpointWithDelayRequest:(nonnull RPOTCMGetEndpointWithDelayRequest*)getEndpointWithDelayRequest
requestDidSucceed_with_responseString:(nonnull NSString*)responseString
{
	[self lastResponseLabel_text_update_with_responseString:responseString];
}

#pragma mark - RPOTCMGetEndpointWithDelayRequest_requestRetryDelegate
-(void)getEndpointWithDelayRequest_didRetry:(nonnull RPOTCMGetEndpointWithDelayRequest*)getEndpointWithDelayRequest
{
	kRUConditionalReturn(self.getEndpointWithDelayRequest != getEndpointWithDelayRequest, NO);

	[self setRetryAttemptCount:self.retryAttemptCount + 1];
}

@end
