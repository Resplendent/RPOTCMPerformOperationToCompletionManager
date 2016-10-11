//
//  RPOTCMGetEndpointWithDelayRequest_Protocols.h
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Benjamin Maer on 10/10/16.
//  Copyright © 2016 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RPOTCMGetEndpointWithDelayRequest;





@protocol RPOTCMGetEndpointWithDelayRequest_requestSuccessDelegate <NSObject>

-(void)getEndpointWithDelayRequest:(nonnull RPOTCMGetEndpointWithDelayRequest*)getEndpointWithDelayRequest
requestDidSucceed_with_responseString:(nonnull NSString*)responseString;

@end
