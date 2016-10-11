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
-(void)attemptToPerformOperationsToRetry_mainThread;

-(void)notificationDidFire_FXReachability_StatusDidChange;

@end





@implementation RPOTCMPerformOperationToCompletionManager

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		[self setRetryDelay_increment_default:0.5f];
		[self setRetryDelay_max_default:10.0f];

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

		[self_weak attemptToPerformOperationsToRetry_mainThread];

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

-(void)attemptToPerformOperationsToRetry_mainThread
{
	kRUConditionalReturn([NSThread isMainThread] == false, YES);
	kRUConditionalReturn(self.canAttemptNextRetryOperation == false, NO);
	
	NSMutableArray<id<RPOTCMPerformOperationToCompletionManagerOperation>>* const operationsToRetry = self.operationsToRetry;
	NSArray<id<RPOTCMPerformOperationToCompletionManagerOperation>>* const operationsToRetry_copy =
	(operationsToRetry ?
	 [NSArray<id<RPOTCMPerformOperationToCompletionManagerOperation>> arrayWithArray:operationsToRetry] :
	 nil);
	
	[operationsToRetry removeAllObjects];
	__weak typeof(self) const self_weak = self;

	[operationsToRetry_copy enumerateObjectsUsingBlock:^(id<RPOTCMPerformOperationToCompletionManagerOperation>  _Nonnull operationToRetry, NSUInteger idx, BOOL * _Nonnull stop) {

		id<RPOTCMPerformOperationToCompletionManagerOperation_Retry> const operation_retry = kRUProtocolOrNil(operationToRetry, RPOTCMPerformOperationToCompletionManagerOperation_Retry);

		if ((operation_retry != nil) &&
			([operation_retry respondsToSelector:@selector(rpotcm_operationWillRetry)]))
		{
			[operation_retry rpotcm_operationWillRetry];
		}

		void(^actions)() = ^() {

			[self_weak addOperationToBePerformedToCompletion:operationToRetry];

			if ((operation_retry != nil) &&
				([operation_retry respondsToSelector:@selector(rpotcm_operationDidRetry)]))
			{
				[operation_retry rpotcm_operationDidRetry];
			}

		};

		id<RPOTCMPerformOperationToCompletionManagerOperation_RetryDelay> const operation_retryDelay = kRUProtocolOrNil(operationToRetry, RPOTCMPerformOperationToCompletionManagerOperation_RetryDelay);
		if (operation_retryDelay)
		{
			NSTimeInterval const currentDelay = [operation_retryDelay rpotcm_currentRetryDelay];
			NSTimeInterval const delayIncrement = ([operation_retryDelay respondsToSelector:@selector(rpotcm_retryDelay_increment)] ?
												   [operation_retryDelay rpotcm_retryDelay_increment] :
												   [self retryDelay_increment_default]);
			NSTimeInterval const delayMax =
			([operation_retryDelay respondsToSelector:@selector(rpotcm_retryDelay_max)] ?
			 [operation_retryDelay rpotcm_retryDelay_max] :
			 [self retryDelay_max_default]);
			
			NSTimeInterval const delay_final =
			MIN(currentDelay + delayIncrement, delayMax);

			[operation_retryDelay setRpotcm_currentRetryDelay:delay_final];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([operation_retryDelay rpotcm_currentRetryDelay] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				actions();
			});
		}
		else
		{
			actions();
		}
	}];
}

#pragma mark - NSNotificationCenter
-(void)notificationDidFire_FXReachability_StatusDidChange
{
	[self attemptToPerformOperationsToRetry];
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance;

@end
