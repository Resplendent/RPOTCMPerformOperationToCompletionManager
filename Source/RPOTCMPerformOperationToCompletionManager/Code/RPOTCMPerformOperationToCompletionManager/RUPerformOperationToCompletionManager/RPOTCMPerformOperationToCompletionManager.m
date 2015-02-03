//
//  RUPerformOperationToCompletionManager.m
//  Resplendent
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RPOTCMPerformOperationToCompletionManager.h"
#import "NSObject+RPOTCM_FXReachabilityNotifications.h"

#import "RUSingleton.h"
#import "RUConditionalReturn.h"
#import "RUProtocolOrNil.h"
#import <FXReachability.h>





@interface RPOTCMPerformOperationToCompletionManager ()

@property (nonatomic, readonly) BOOL canAttemptNextRetryOperation;

@property (nonatomic, readonly) NSMutableArray* operationsToRetry;
-(void)addOperationToRetry:(id<RPOTCMPerformOperationToCompletionManagerOperation>)operation;
-(void)attemptToPerformOperationsToRetry;

-(void)notificationDidFire_FXReachability_StatusDidChange;

@end





@implementation RPOTCMPerformOperationToCompletionManager

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		_operationsToRetry = [NSMutableArray new];

		[self setRegisteredForNotifications_RPOTCM_FXReachability_StatusDidChangeOnWithNotificationSelector:@selector(notificationDidFire_FXReachability_StatusDidChange)];
	}

	return self;
}

-(void)dealloc
{
	[self clearRegisteredForNotifications_RPOTCM_FXReachability_StatusDidChange];
}

#pragma mark - Add Operation
-(void)addOperationToBePerformedToCompletion:(id<RPOTCMPerformOperationToCompletionManagerOperation>)operation
{
	kRUConditionalReturn(operation == nil, YES);
	kRUConditionalReturn(kRUProtocolOrNil(operation, RPOTCMPerformOperationToCompletionManagerOperation) == nil, YES);

	dispatch_async(dispatch_get_main_queue(), ^{

		[operation rpotcm_performOperationToCompletion:^(BOOL didFinishSuccessfully) {
			
			if (didFinishSuccessfully == false)
			{
				[self addOperationToRetry:operation];
			}
			
		}];

	});
}

#pragma mark - Retry
-(BOOL)canAttemptNextRetryOperation
{
	return ([FXReachability isReachable]);
}

-(void)addOperationToRetry:(id<RPOTCMPerformOperationToCompletionManagerOperation>)operation
{
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.operationsToRetry addObject:operation];

		[self attemptToPerformOperationsToRetry];
	});
}

-(void)attemptToPerformOperationsToRetry
{
	kRUConditionalReturn(self.canAttemptNextRetryOperation == false, NO);

	dispatch_async(dispatch_get_main_queue(), ^{

		kRUConditionalReturn(self.canAttemptNextRetryOperation == false, NO);

		NSArray* operationsToRetry = [self.operationsToRetry copy];
		[self.operationsToRetry removeAllObjects];

		for (id<RPOTCMPerformOperationToCompletionManagerOperation> operationToRetry in operationsToRetry)
		{
			[self addOperationToBePerformedToCompletion:operationToRetry];
		}
		
	});
}

#pragma mark - NSNotificationCenter
-(void)notificationDidFire_FXReachability_StatusDidChange
{
	[self attemptToPerformOperationsToRetry];
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance;

@end
