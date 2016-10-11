//
//  RPOTCMGetEndpointWithDelayRequest.h
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Benjamin Maer on 10/10/16.
//  Copyright © 2016 Richard Reitzfeld. All rights reserved.
//

#import "RPOTCMGetEndpointWithDelayRequest_Protocols.h"

#import <Foundation/Foundation.h>

#import <RPOTCMPerformOperationToCompletionManager/RPOTCMPerformOperationToCompletionManagerProtocols.h>





@interface RPOTCMGetEndpointWithDelayRequest : NSObject <RPOTCMPerformOperationToCompletionManagerOperation, RPOTCMPerformOperationToCompletionManagerOperation_RetryDelay, RPOTCMPerformOperationToCompletionManagerOperation_Retry>

#pragma mark - requestSuccessDelegate
@property (nonatomic, assign, nullable) id<RPOTCMGetEndpointWithDelayRequest_requestSuccessDelegate> requestSuccessDelegate;

#pragma mark - requestRetryDelegate
@property (nonatomic, assign, nullable) id<RPOTCMGetEndpointWithDelayRequest_requestRetryDelegate> requestRetryDelegate;

#pragma mark - URL
@property (nonatomic, readonly, strong, nullable) NSURL* URL;

#pragma mark - init
-(nullable instancetype)init_with_URL:(nonnull NSURL*)URL NS_DESIGNATED_INITIALIZER;

@end
