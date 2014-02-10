//
//  AppDelegate.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#pragma mark - Настройки программы при запуске

#define FAST_RECOGNITION YES
#define GRADIENT_TEACHING NO
#define REGIONS_METRICS YES
#define TRAINING_WITH_TEACHER NO
#define STATISTICS_COLLECTION_MODE YES

@implementation AppDelegate

//Настройки
@synthesize fastRecognition = _fastRecognition;
@synthesize gradientTeaching = _gradientTeaching;
@synthesize trainingWithTeacher = _trainingWithTeacher;
@synthesize regionsMetrics = _regionsMetrics;
@synthesize statisticsCollection = _statisticsCollection;

//Значения
@synthesize regionSquareThresholdValue = _regionSquareThresholdValue;
@synthesize trainCoefficient = _trainCoefficient;
@synthesize formCoefficientAffection = _formCoefficientAffection;

const double DEFAULT_TRAIN_COEFFICIENT = 0.18;
const double DEFAULT_FORM_COEFFICIENT_AFFECTION = 0.15;
const int REGIONS_SQUARE_THRESHOLD = 100;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _fastRecognition = FAST_RECOGNITION;
    _gradientTeaching = GRADIENT_TEACHING;
    _trainingWithTeacher = TRAINING_WITH_TEACHER;
    _regionsMetrics = REGIONS_METRICS;
    _statisticsCollection = STATISTICS_COLLECTION_MODE;
    
    _regionSquareThresholdValue = REGIONS_SQUARE_THRESHOLD;
    _trainCoefficient = DEFAULT_TRAIN_COEFFICIENT;
    _formCoefficientAffection = DEFAULT_FORM_COEFFICIENT_AFFECTION;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
