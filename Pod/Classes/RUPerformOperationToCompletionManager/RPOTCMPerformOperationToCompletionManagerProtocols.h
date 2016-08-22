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
