//
//  RUPerformOperationToCompletionManager.m
//  Resplendent
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RPOTCMPerformOperationToCompletionManager.h"
#import "NSObject+RPOTCM_FXReachabilityNotifications.h"

@import ResplendentUtilities;
@import FXReachability;





@interface RPOTCMPerformOperationToCompletionManager ()

#pragma mark - canAttemptNextRetryOperation
@property (nonatomic, readonly) BOOL canAttemptNextRetryOperation;

#pragma mark - operationsToRetry
@property (nonatomic, readonly, strong, nullable) NSMutableArray<id<RPOTCMPerformOperationToCompletionManagerOperation>>* operationsToRetry;
-(void)addOperationToRetry:(nonnull id<RPOTCMPerformOperationToCompletionManagerOperation>)operation;
/**
 Method works by holding onto a copy of `operationsToRetry`, then removing all objects from `operationsToRetry`, then adding them all back one by one.
 */
-(void)attemptToPerformOperationsToRetry;

-(void)notificationDidFire_FXReachability_StatusDidChange;

@end





@implementation RPOTCMPerformOperationToCompletionManager

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		_operationsToRetry = [NSMutableArray<id<RPOTCMPerformOperationToCompletionManagerOperation>> new];

		[self setRegisteredForNotifications_RPOTCM_FXReachability_StatusDidChangeOnWithNotificationSelector:@selector(notificationDidFire_FXReachability_StatusDidChange)];
	}

	return self;
}

-(void)dealloc
{
	[self clearRegisteredForNotifications_RPOTCM_FXReachability_StatusDidChange];
}

#pragma mark - Add Operation
-(void)addOperationToBePerformedToCompletion:(nonnull id<RPOTCMPerformOperationToCompletionManagerOperation>)operation
{
	kRUConditionalReturn(operation == nil, YES);
	kRUConditionalReturn(kRUProtocolOrNil(operation, RPOTCMPerformOperationToCompletionManagerOperation) == nil, YES);

	__weak typeof(self) const self_weak = self;
	dispatch_async(dispatch_get_main_queue(), ^{

		[operation rpotcm_performOperationToCompletion:^(BOOL didFinishSuccessfully) {

			kRUConditionalReturn(self_weak == nil, YES);
			if (didFinishSuccessfully == false)
			{
				[self_weak addOperationToRetry:operation];
			}
			
		}];

	});
}

#pragma mark - Retry
-(BOOL)canAttemptNextRetryOperation
{
	return ([FXReachability isReachable]);
}

-(void)addOperationToRetry:(nonnull id<RPOTCMPerformOperationToCompletionManagerOperation>)operation
{
	kRUConditionalReturn(operation == nil, YES);

	__weak typeof(self) const self_weak = self;
	dispatch_async(dispatch_get_main_queue(), ^{

		kRUConditionalReturn(self_weak == nil, YES);

		[self_weak.operationsToRetry addObject:operation];
		[self_weak attemptToPerformOperationsToRetry];

	});
}

-(void)attemptToPerformOperationsToRetry
{
	kRUConditionalReturn(self.canAttemptNextRetryOperation == false, NO);

	__weak typeof(self) const self_weak = self;
	dispatch_async(dispatch_get_main_queue(), ^{

		kRUConditionalReturn(self_weak == nil, YES);
		kRUConditionalReturn(self_weak.canAttemptNextRetryOperation == false, NO);

		NSMutableArray<id<RPOTCMPerformOperationToCompletionManagerOperation>>* const operationsToRetry = self_weak.operationsToRetry;
		NSArray<id<RPOTCMPerformOperationToCompletionManagerOperation>>* const operationsToRetry_copy =
		(operationsToRetry ?
		 [NSArray<id<RPOTCMPerformOperationToCompletionManagerOperation>> arrayWithArray:operationsToRetry] :
		 nil);

		[operationsToRetry removeAllObjects];
		for (id<RPOTCMPerformOperationToCompletionManagerOperation> operationToRetry in operationsToRetry_copy)
		{
			[self_weak addOperationToBePerformedToCompletion:operationToRetry];
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
