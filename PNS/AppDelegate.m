//
//  AppDelegate.m
//  PNS
//
//  Created by Mateusz Zając on 24.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Notification.h"
#import <AFNetworkActivityIndicatorManager.h>

#define PNS_REGISTRATION_URL @"http://dev.uek.krakow.pl:4567/register"

@interface AppDelegate ()

@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSData *deviceToken;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Registering device to resond to remote notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    // Enable network activity manager
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
            
            Notification *notify = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
            notify.timeStamp = [NSDate date];
            notify.alert = [[dictionary valueForKeyPath:@"aps"] valueForKeyPath:@"alert"];
            
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Couldn't save to persistant store.");
            }
            
            // Clearing notification center
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
	}
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    // Showing alert view for registration device on the server
    if (![self hasEverBeenLaunched]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register" message:@"Enter your name to register device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Register", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    
    // Saving device token to property
    self.deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);

    Notification *notify = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
    notify.timeStamp = [NSDate date];
    notify.alert = [[userInfo valueForKeyPath:@"aps"] valueForKeyPath:@"alert"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save to persistant store.");
    }
    
    // Clearing notification center
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PNS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PNS.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - UIAlertView delegate

// Enabling register button only when user enter name
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (!textField.text || [textField.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 0) {
        self.ownerName = textField.text;
        NSLog(@"Owner name: %@", self.ownerName);
        
        [self registerDeviceOnServer:PNS_REGISTRATION_URL ownerName:self.ownerName token:self.deviceToken];
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - First Run Check

- (BOOL)hasEverBeenLaunched
{
    // A boolean which determines if app has eer been launched
    BOOL hasBeenLaunched;
    
    // Testig if application has launched before and if it has to show the home-login screen to login
    // to social networks (facebook, Twitter)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasAlreadyLaunched"]) {
        // Setting variable to YES because app has been launched before
        hasBeenLaunched = YES;
        // NSLog(@"App has been already launched");
    } else {
        // Setting variable to NO because app hasn't been launched before
        hasBeenLaunched = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasAlreadyLaunched"];
        if (![[NSUserDefaults standardUserDefaults] synchronize]) {
            NSLog(@"Couldn't save the information about the first run");
        }
        // NSLog(@"This is the first run ever...");
    }
    
    return hasBeenLaunched;
}

#pragma mark - Helper methods

- (void)registerDeviceOnServer:(NSString *)address ownerName:(NSString *)owner token:(NSData *)token
{
    NSDictionary *params = @{@"id": token, @"owner": owner, @"os": @"iOS"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:address parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Registration to database is successful");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
