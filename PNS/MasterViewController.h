//
//  MasterViewController.h
//  PNS
//
//  Created by Mateusz Zając on 24.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <AFHTTPRequestOperationManager.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)register:(UIBarButtonItem *)sender;

@end
