//
//  RPOTCMPerformOperationToCompletionManagerProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>





@protocol RPOTCMPerformOperationToCompletionManagerOperation <NSObject>

-(void)rpotcm_performOperationToCompletion:(nonnull void(^)(BOOL didFinishSuccessfully))completion;

@end





@protocol RPOTCMPerformOperationToCompletionManagerOperation_Retry <NSObject>

@optional
-(void)rpotcm_operationWillRetry;
-(void)rpotcm_operationDidRetry;

@end





@protocol RPOTCMPerformOperationToCompletionManagerOperation_RetryDelay <NSObject>

@required
@property (nonatomic, assign) NSTimeInterval rpotcm_currentRetryDelay;

@optional
-(NSTimeInterval)rpotcm_retryDelay_increment;
-(NSTimeInterval)rpotcm_retryDelay_max;

@end
