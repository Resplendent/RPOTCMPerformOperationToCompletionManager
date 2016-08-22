//
//  NSObject+RPOTCM_FXReachabilityNotifications.m
//  RPOTCMPerformOperationToCompletionManager
//
//  Created by Benjamin Maer on 1/13/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import "NSObject+RPOTCM_FXReachabilityNotifications.h"

@import FXReachability;





kRUDefineNSStringConstant(kRPOTCM_FXReachabilityNotifications_StatusDidChange)





@implementation NSObject (RPOTCM_FXReachabilityNotifications)

kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation(r, R, egisteredForNotifications_RPOTCM_FXReachability_StatusDidChange, &kRPOTCM_FXReachabilityNotifications_StatusDidChange, FXReachabilityStatusDidChangeNotification, nil);

@end
