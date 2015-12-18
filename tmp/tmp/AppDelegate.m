//
//  AppDelegate.m
//  tmp
//
//  Created by Bourbon on 15/11/10.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "AppDelegate.h"
#import <FLEX/FLEXManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.ns
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *midString = [formatter stringFromDate:[NSDate date]];
//    
//    NSString *firstString = [midString substringToIndex:11];
//    firstString = [firstString stringByAppendingString:@"16:00"];
//    NSDate *dat = [formatter dateFromString:firstString];
//    
//    NSComparisonResult result =  [dat compare:[NSDate date]];
//    
//    
//    NSString *tmp = @"hi,您的宝贝今天已观看00:00:00";
//    tmp = [tmp substringWithRange:NSMakeRange(12, 8)];
//    
//    [[FLEXManager sharedManager] showExplorer];
    
        return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
