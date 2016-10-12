//
//  ModifyInformationViewController.h
//  Pan大夫
//
//  Created by 刘明瑞 on 16/10/10.
//  Copyright © 2016年 Neil. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface ModifyInformationViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SettingsViewController *settingsView;

@property (strong, nonatomic) UIScrollView *scroll;
- (id)initWithNav:(BOOL)hasNav SettingsViewController:(SettingsViewController *)settingsViewController;

@end
