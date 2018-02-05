//
//  DGEventCell.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGEventCell.h"

@implementation DGEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithEvent:(DGCalendarEvent *)event
{
    [self.eventTitleLabel setText:event.title];
    [self.eventSubtitleLabel setText:[event eventFromToDescription]];
    [self.eventImageView setImage:[self circleImageWithColor:[event eventColor]]];
}

- (UIImage *)circleImageWithColor:(UIColor *)color
{
    CGFloat width = CGRectGetWidth(self.eventImageView.frame);
    CGFloat height = CGRectGetWidth(self.eventImageView.frame);
    
    
    UIImage *coloredCircle = [UIImage new];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width/2, height/2), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGRect rect = CGRectMake(0, 0, width/2.5, height/2.5);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    coloredCircle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredCircle;
}

@end
