//
//  DGMainViewController.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGMainViewControllerDM.h"

@interface DGMainViewController : UIViewController

@property (nonatomic, strong) DGMainViewControllerDM* dataModel;

@property (nonatomic, strong) UIColor* toolbarButtonTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor* controllerBackgroundColor UI_APPEARANCE_SELECTOR;

@end
