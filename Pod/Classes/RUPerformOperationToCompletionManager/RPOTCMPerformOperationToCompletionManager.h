//
//  RUPerformOperationToCompletionManager.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPOTCMPerformOperationToCompletionManagerProtocols.h"





/*
 Operations will be dispatched to main thread and executed when added. If on completion they are not successful, they will be retried if reachability is present, otherwise when reachability is regained.
 */
@interface RPOTCMPerformOperationToCompletionManager : NSObject

#pragma mark - operationsToRetry
-(void)addOperationToBePerformedToCompletion:(nonnull id<RPOTCMPerformOperationToCompletionManagerOperation>)operation;

#pragma mark - Singleton
+(nonnull instancetype)sharedInstance;

@end
