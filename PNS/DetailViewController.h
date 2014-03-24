//
//  DetailViewController.h
//  PNS
//
//  Created by Mateusz Zając on 24.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
