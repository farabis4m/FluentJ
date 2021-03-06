//
//  FJAppDelegate.m
//  FluentJ
//
//  Created by vlad gorbenko on 09/06/2015.
//  Copyright (c) 2015 vlad gorbenko. All rights reserved.
//

#import "FJAppDelegate.h"

#import <FluentJ/FluentJ.h>

#import "User.h"
#import "Item.h"

#import "VGUser.h"
#import "VGItem.h"

#import <MagicalRecord/MagicalRecord.h>

@implementation FJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MagicalRecord setupCoreDataStack];
    
//    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filepath];
//    NSError *error = nil;
//    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    
//    NSArray *items = [User importValue:json userInfo:@{@"action" : @"index"} error:nil];
//    NSLog(@"%@", items);
//    
//    id item = [items firstObject];
//    NSDictionary *userDictionary = @{@"firstName" : @"Vlad",
//                                     @"lastName" : @"Gorbenko"};
//
//    [item updateWithValue:userDictionary context:nil userInfo:nil error:nil];
//    NSLog(@"%@", item);
//    
//    NSDictionary *jsonItem = [item exportWithUserInfo:@{@"flatten" : @YES} error:nil];
//    NSLog(@"json : %@", jsonItem);
//
//    NSDictionary *obj = [item exportWithUserInfo:nil error:&error];
//    NSLog(@"%@", obj);
//    
//    id context = [NSManagedObjectContext MR_defaultContext];
//    NSArray *dbUsers = [VGUser importValue:json context:context userInfo:@{@"action" : @"index"} error:nil];
//    NSLog(@"dbUsers count: %@", @(dbUsers.count));
//    [context MR_saveToPersistentStoreAndWait];
//    
//    id dbUser = [VGUser importValue:@{@"firstName" : @"Kelly", @"isVIP" : @NO} context:context userInfo:@{@"action" : @"index"} error:nil];
//    NSLog(@"%@", dbUser);
    
    NSDictionary *keys = [User keysWithProperties:[User properties] sneak:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
