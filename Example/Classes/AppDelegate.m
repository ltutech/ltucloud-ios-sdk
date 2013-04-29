//
//  AppDelegate.m
//  LTUMobileiOSExample
//
//  Created by Adam Bednarek on 4/3/13.
//  Copyright (c) 2013 LTU technologies. All rights reserved.
//

#import <LTUSDK/LTUManager.h>

#import "AppDelegate.h"

// Replace with your username / password
static NSString *const kLTUUsername = @"";
static NSString *const kLTUPassword = @"";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [LTUManager initializeSharedLTUManagerWithUsername:kLTUUsername
                                         andPassword:kLTUPassword];
  return YES;
}


@end
