//
//  Notification.h
//  PNS
//
//  Created by Mateusz Zając on 24.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * alert;

@end
