//
//  MaioAdobeAirDelegate.h
//  IOSMaioExtension
//
//  Created by maio on 2017/05/31.
//  Copyright © 2017年 maio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Maio/Maio.h>
#import "FlashRuntimeExtensions.h"

@interface MaioAdobeAirDelegate : NSObject <MaioDelegate>
+(instancetype)delegateWithFREContext:(FREContext)context;
@end
