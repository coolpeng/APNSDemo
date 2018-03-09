//
//  AppDelegate.m
//  RemoteNotificationDemo
//
//  Created by Edward on 2018/3/8.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "RNGlobalDefine.h"
#import "ShiJiazhuangViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic,strong) UITabBarController *mainTabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setWindowRootViewController];
    
    [self registerRemoteNotificationsForApplication:application];
    return YES;
}

//  设置Window的rootViewController
- (void)setWindowRootViewController {
    
    self.mainTabBarController = [[UITabBarController alloc] init];
    self.mainTabBarController.tabBar.translucent = NO;
    self.mainTabBarController.tabBar.tintColor = [UIColor blackColor];
    
    //  类名
    NSArray *classNames = @[
                            @"ViewController",
                            @"ShandongViewController",
                            ];
    //  标题名
    NSArray *titles = @[
                        @"河北省",
                        @"山东省",
                        ];
    
    //  分别实例化并添加到nav中
    for (int i = 0 ; i<classNames.count; i++) {
        Class class = NSClassFromString(classNames[i]);
        UIViewController *oneVC = [[class alloc] init];
        oneVC.title = titles[i];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:oneVC];
        navVC.navigationBar.translucent = NO;
        navVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:nil tag:i];
        [self.mainTabBarController addChildViewController:navVC];
    }
    
    self.window.rootViewController = self.mainTabBarController;
    [self.window makeKeyAndVisible];
}

#pragma mark Remote Notification
- (void)registerRemoteNotificationsForApplication:(UIApplication *)application {
    
    if (IOS10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"UNUserNotificationCenter requestAuthorization successfully");
            }else{
                NSLog(@"UNUserNotificationCenter requestAuthorization failed");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (IOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken===========%@",deviceString);
    
    //TODO: 将token传送给服务器
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"FailToRegisterForRemoteNotification: %@\n",error.description);
}

#pragma mark UNUserNotificationCenterDelegate
//app 处于前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"will prsent the remote notification:%@",userInfo);
        
        
        
    }else {
        NSLog(@"will prsent the local notification:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"received the remote notification:%@",userInfo);
        
        [self jump];
    }else {
        NSLog(@"received the local notification:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();
}

- (void)didReceiveRemoteNotificationResponseWithOptions:(NSDictionary *)launchOptions {
    
}

- (void)jump {
    [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:[[ShiJiazhuangViewController alloc] init] animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
