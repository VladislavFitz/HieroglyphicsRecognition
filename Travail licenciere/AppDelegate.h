//
//  AppDelegate.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property BOOL fastRecognition;
@property BOOL gradientTeaching;
@property BOOL regionsMetrics;
@property BOOL trainingWithTeacher;
@property BOOL statisticsCollection;

@property double trainCoefficient;
@property int regionSquareThresholdValue;
@property double formCoefficientAffection;

@end
