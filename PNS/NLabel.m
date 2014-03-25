//
//  NLabel.m
//  PNS
//
//  Created by Mateusz Zając on 25.03.2014.
//  Copyright (c) 2014 Mateusz Zając. All rights reserved.
//

#import "NLabel.h"

@implementation NLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {10, 10, 10, 10};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
