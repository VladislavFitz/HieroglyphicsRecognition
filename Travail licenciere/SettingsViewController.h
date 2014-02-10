//
//  SettingsViewController.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 04.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *fastRecognitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gradientTeachingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *regionMetricsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trainingWithTeacherSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *statisticsCollection;

@property id delegate;

@end
