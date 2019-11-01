//
//  AppDelegate.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//https://restapi.amap.com/v3/geocode/regeo?location=40.0541,116.2894&key=371061749b4a21aac86e0ee0bb16e8f1
//https://restapi.amap.com/v3/geocode/regeo?key=371061749b4a21aac86e0ee0bb16e8f1&location=40.0541,116.2894

#import "AppDelegate.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#define AMapAK @"4dd153f1cb6fd348780990126deb4876"
#define BaiduAK @"PKaeHlteY3utO2vwyG0ysNBiDqPjYVGU"
@interface AppDelegate ()<BMKLocationAuthDelegate>

@end

@implementation AppDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    NSLog(@"iErooor %d",iError);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduAK authDelegate:self];
    [AMapServices sharedServices].apiKey = AMapAK;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
