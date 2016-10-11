//
//  RPOTCMGetEndpointWithDelayRequest.m
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Benjamin Maer on 10/10/16.
//  Copyright © 2016 Richard Reitzfeld. All rights reserved.
//

#import "RPOTCMGetEndpointWithDelayRequest.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@interface RPOTCMGetEndpointWithDelayRequest ()

#pragma mark - URL
@property (nonatomic, strong, nullable) NSURL* URL;

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

		 if (error == nil)
		 {
			 NSString* const responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			 [self_weak requestSuccessDelegate_requestDidSucceed_with_responseString:responseString];
			 completion(YES);
		 }
		 else
		 {
			 completion(NO);
		 }

	 }];

	[sessionDataTask resume];

//	[[SMNetworkManager sharedInstance] loadAllColorsWithPage:[SMPageContainer_Number page_minimum] success:
//	 ^(RKObjectRequestOperation * _Nonnull operation, NSArray<SMUserColorTheme *> * _Nullable userColorThemes) {
//		 
//		 [self_weak requestSuccessDelegate_notify_with_userColorThemes:userColorThemes];
//		 
//		 if (completion)
//		 {
//			 completion(YES);
//		 }
//		 
//	 }
//													 failure:
//	 ^(RKObjectRequestOperation *operation, NSError *error, BOOL handledError) {
//		 
//		 if (completion)
//		 {
//			 BOOL const completed = (operation.isCancelled || handledError);
//			 SMLogVerbose(@"completed: %i",completed);
//			 
//#warning !!Warning!! Need to implement delay at the library level
//			 NSTimeInterval const delay =
//			 (completed == false ?
//			  self_weak.getCurrentDelayAndIncrement :
//			  0.0f);
//			 
//			 if (delay > 0.0f)
//			 {
//				 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//					 completion(completed);
//				 });
//			 }
//			 else
//			 {
//				 completion(completed);
//			 }
//		 }
//		 
//	 }];
}

@end
