//
//  IOSMaioExtension.m
//  IOSMaioExtension
//
//  Created by maio on 2017/05/31.
//  Copyright © 2017年 maio. All rights reserved.
//

@import Foundation;
#import <Maio/Maio.h>
#import "FlashRuntimeExtensions.h"
#import "MaioAdobeAirDelegate.h"

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

static FREContext eventContext;
static MaioAdobeAirDelegate *delegate;

#pragma mark - Predefined functions
NSString* GetFREObjectAsNSString(FREObject obj);
BOOL GetFREObjectAsBOOL(FREObject obj);
FREObject* NewFREObjectFromNSString(NSString* string);
FREObject* NewFREObjectFromBool(BOOL value);

#pragma mark - Interface

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{

    eventContext = ctx;
    delegate = [MaioAdobeAirDelegate delegateWithFREContext:eventContext];
    
    return NULL;
}

FREObject generalFunction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *functionName = GetFREObjectAsNSString(argv[0]);
    
    if([functionName isEqualToString:@"getSdkVersion"])
    {
        return NewFREObjectFromNSString([Maio sdkVersion]);
    }
    else if ([functionName isEqualToString:@"setAdTestMode"])
    {
        [Maio setAdTestMode:GetFREObjectAsBOOL(argv[1])];
    }
    else if([functionName isEqualToString:@"start"])
    {
        [Maio startWithMediaId:GetFREObjectAsNSString(argv[1]) delegate:delegate];
    }
    else if([functionName isEqualToString:@"canShow"])
    {
        if(argc > 1)
        {
            return NewFREObjectFromBool([Maio canShowAtZoneId:GetFREObjectAsNSString(argv[1])]);
        }
        else
        {
            return NewFREObjectFromBool([Maio canShow]);
        }
    }
    else if([functionName isEqualToString:@"show"])
    {
        if(argc > 1)
        {
            [Maio showAtZoneId:GetFREObjectAsNSString(argv[1])];
        }
        else
        {
            [Maio show];
        }
    }
    else
    {
        NSLog(@"undefined function: %@", functionName);
    }
    
    return NULL;
}

#pragma mark - Utilities

NSString* GetFREObjectAsNSString(FREObject obj)
{
    uint32_t stringLength;
    const uint8_t *string;
    FREGetObjectAsUTF8(obj, &stringLength, &string);
    return [NSString stringWithUTF8String:(char*)string];
}

BOOL GetFREObjectAsBOOL(FREObject obj)
{
    uint32_t c_value;
    FREGetObjectAsBool(obj, &c_value);
    
    return c_value != 0;
}

FREObject* NewFREObjectFromNSString(NSString* string)
{
    FREObject freString;
    
    const char *c_string = [string UTF8String];
    FRENewObjectFromUTF8((uint32_t)(strlen(c_string)+1), (const uint8_t*)c_string, &freString);
    
    return freString;
}

FREObject* NewFREObjectFromBool(BOOL value)
{
    FREObject freBool;
    FRENewObjectFromBool((uint32_t)value, &freBool);
    return freBool;
}

#pragma mark - Extension Initializer

void MaioExtensionContextInitializer(void* extData,
                                     const uint8_t* ctxType,
                                     FREContext ctx,
                                     uint32_t* numFunctionsToSet,
                                     const FRENamedFunction** functionsToSet)
{
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(init, NULL),
        MAP_FUNCTION(generalFunction, NULL)
    };
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = functionMap;
}

void MaioExtensionInitializer(void** extDataToSet,
                              FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &MaioExtensionContextInitializer;
}
