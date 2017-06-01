//
//  MaioAdobeAirDelegate.m
//  IOSMaioExtension
//
//  Created by maio on 2017/05/31.
//  Copyright © 2017年 maio. All rights reserved.
//

#import "MaioAdobeAirDelegate.h"

@implementation MaioAdobeAirDelegate
{
    FREContext extensionContext;
}

+(instancetype)delegateWithFREContext:(FREContext)context
{
    return [[self alloc] initWithFREContext:context];
}

-(instancetype)initWithFREContext:(FREContext)context
{
    if(self = [super init])
    {
        extensionContext = context;
    }
    return self;
}

// MEMO: Only two string variables are permitted as a callback to actionscript.
//       Hence, "code" is the function name, and "level" is its contents.
//       The code portion is connected with a colon ':'.

-(void)sendCallbackToFunction:(NSString *)functionName Params:(NSString *)params
{
    if(!extensionContext) return; // extensionContext must not be null
    
    const uint8_t* code = (const uint8_t*) [functionName UTF8String];
    const uint8_t* level = (const uint8_t*) [params UTF8String];
    FREDispatchStatusEventAsync(extensionContext, code, level);
}

#pragma mark - Maio Callbacks

-(void)maioDidInitialize
{
    [self sendCallbackToFunction:@"onInitialized" Params:@""];
}

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue
{
    NSString *params = [NSString stringWithFormat:@"%@:%@", zoneId, newValue ? @"true" : @""];
    [self sendCallbackToFunction:@"onChangedCanShow" Params:params];
}

-(void)maioWillStartAd:(NSString *)zoneId
{
    [self sendCallbackToFunction:@"onStartAd" Params:zoneId];
}

-(void)maioDidFinishAd:(NSString *)zoneId
              playtime:(NSInteger)playtime
               skipped:(BOOL)skipped
           rewardParam:(NSString *)rewardParam
{
    NSArray *paramArray = @[zoneId,
                            [NSString stringWithFormat:@"%ld", (long)playtime],
                            skipped ? @"true" : @"",
                            rewardParam];
    NSString *params = [paramArray componentsJoinedByString:@":"];
    NSLog(@"TRACE: %@", params);
    [self sendCallbackToFunction:@"onFinishedAd" Params:params];
}

-(void)maioDidClickAd:(NSString *)zoneId
{
    [self sendCallbackToFunction:@"onClickedAd" Params:zoneId];
}

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason
{
    NSString *failReason;
    switch (reason) {
        case MaioFailReasonAdStockOut:          failReason = @"AdStockOut"; break;
        case MaioFailReasonNetworkConnection:   failReason = @"NetworkConnection"; break;
        case MaioFailReasonNetworkClient:       failReason = @"NetworkClient"; break;
        case MaioFailReasonNetworkServer:       failReason = @"NetworkServer"; break;
        case MaioFailReasonSdk:                 failReason = @"Sdk"; break;
        case MaioFailReasonDownloadCancelled:   failReason = @"DownloadCancelled"; break;
        case MaioFailReasonVideoPlayback:       failReason = @"VideoPlayback"; break;
        case MaioFailReasonUnknown:
        default:
            failReason = @"Unknown"; break;
    }
    [self sendCallbackToFunction:@"onFailed" Params:[NSString stringWithFormat:@"%@:%@", zoneId, failReason]];
}

@end
