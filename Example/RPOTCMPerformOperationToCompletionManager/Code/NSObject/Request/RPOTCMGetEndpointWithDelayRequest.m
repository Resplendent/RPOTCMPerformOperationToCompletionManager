//
//  RPOTCMGetEndpointWithDelayRequest.m
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Benjamin Maer on 10/10/16.
//  Copyright © 2016 Richard Reitzfeld. All rights reserved.
//

#import "RPOTCMGetEndpointWithDelayRequest.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/RUClassOrNilUtil.h>
#import <ResplendentUtilities/RUDLog.h>





@interface RPOTCMGetEndpointWithDelayRequest ()

#pragma mark - URL
@property (nonatomic, strong, nullable) NSURL* URL;

#pragma mark - request
-(BOOL)request_handle_response_with_data:(nullable NSData*)data
								response:(nullable NSURLResponse*)response
								   error:(nullable NSError*)error;

#pragma mark - requestSuccessDelegate
-(void)requestSuccessDelegate_requestDidSucceed_with_responseString:(nonnull NSString*)responseString;

@end





@implementation RPOTCMGetEndpointWithDelayRequest

#pragma mark - NSObject
-(instancetype)init
{
	kRUConditionalReturn_ReturnValueNil(YES, YES);

	return [self init_with_URL:[NSURL URLWithString:@""]];
}

#pragma mark - init
-(nullable instancetype)init_with_URL:(nonnull NSURL*)URL
{
	if (self = [super init])
	{
		[self setURL:URL];
	}

	return self;
}

#pragma mark - requestSuccessDelegate
-(void)requestSuccessDelegate_requestDidSucceed_with_responseString:(nonnull NSString*)responseString
{
	kRUConditionalReturn(responseString == nil, YES);

	id<RPOTCMGetEndpointWithDelayRequest_requestSuccessDelegate> const requestSuccessDelegate = self.requestSuccessDelegate;
	kRUConditionalReturn(requestSuccessDelegate == nil, YES);

	[requestSuccessDelegate getEndpointWithDelayRequest:self requestDidSucceed_with_responseString:responseString];
}

#pragma mark - RPOTCMPerformOperationToCompletionManagerOperation
-(void)rpotcm_performOperationToCompletion:(nonnull void(^)(BOOL didFinishSuccessfully))completion
{
	kRUConditionalReturn(completion == nil, YES);

	if (self.requestSuccessDelegate == nil)
	{
		NSAssert(false, @"requestSuccessDelegate must be set");
		completion(YES);
	}

	NSURL* const URL = self.URL;
	if (URL == nil)
	{
		NSAssert(false, @"Must have a URL");
		completion(YES);
	}

	__weak typeof(self) const self_weak = self;
	NSURLSessionDataTask* const sessionDataTask =
	[[NSURLSession sharedSession]dataTaskWithURL:URL
							   completionHandler:
	 ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		 dispatch_async(dispatch_get_main_queue(), ^{

			 BOOL const success =
			 [self_weak request_handle_response_with_data:data
												 response:response
													error:error];
			 RUDLog(@"success: %i",success);
			 
			 completion(success);

		 });

	 }];

	RUDLog(@"Sending request to: %@",URL);
	[sessionDataTask resume];
}

#pragma mark - request
-(BOOL)request_handle_response_with_data:(nullable NSData*)data
								response:(nullable NSURLResponse*)response
								   error:(nullable NSError*)error
{
	RUDLog(@"Got response: %@",response);

	kRUConditionalReturn_ReturnValueFalse(error != nil, NO);

	NSHTTPURLResponse* const HTTPURLResponse = kRUClassOrNil(response, NSHTTPURLResponse);
	kRUConditionalReturn_ReturnValueFalse(HTTPURLResponse == nil, YES);

	NSInteger const statusCode = HTTPURLResponse.statusCode;
	kRUConditionalReturn_ReturnValueFalse(statusCode != 200, NO);

	NSString* const responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	[self requestSuccessDelegate_requestDidSucceed_with_responseString:responseString];

	return YES;
}

#pragma mark - RPOTCMPerformOperationToCompletionManagerOperation_RetryDelay
@synthesize rpotcm_currentRetryDelay;

#pragma mark - RPOTCMPerformOperationToCompletionManagerOperation_Retry
-(void)rpotcm_operationDidRetry
{
	[self.requestRetryDelegate getEndpointWithDelayRequest_didRetry:self];
}

@end
