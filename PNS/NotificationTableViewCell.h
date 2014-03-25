//
//  NotificationTableViewCell.h
//  PNS
//
//  Created by Mateusz Zając on 25.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;

@end
