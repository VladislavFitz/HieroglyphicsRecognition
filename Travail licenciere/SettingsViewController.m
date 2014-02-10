//
//  SettingsViewController.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 04.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"

#define SWITCH_FAST_RECOGNITION 0
#define SWITCH_GRADIENT_TEACHING 1
#define SWITCH_REGIONS_METRICS 2
#define SWITCH_TRAINING_WITH_TEACHER 3
#define SWITCH_STATISTICS_COLLECTION 4

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize fastRecognitionSwitch = _fastRecognitionSwitch;
@synthesize regionMetricsSwitch = _regionMetricsSwitch;
@synthesize gradientTeachingSwitch = _gradientTeachingSwitch;
@synthesize statisticsCollection = _statisticsCollection;

@synthesize delegate = _parentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [_fastRecognitionSwitch setOn:[delegate fastRecognition]];
    [_regionMetricsSwitch setOn:[delegate regionsMetrics]];
    [_gradientTeachingSwitch setOn:[delegate gradientTeaching]];
    [_trainingWithTeacherSwitch setOn:[delegate trainingWithTeacher]];
    [_statisticsCollection setOn:[delegate statisticsCollection]];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchValueChanged:(id)sender
{
    BOOL on = [(UISwitch *)sender isOn];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    switch ([sender tag])
    {
        case SWITCH_FAST_RECOGNITION:
        {
            [delegate setFastRecognition:on];
            
            if (on)
            {
                [(ViewController *)_parentView performSelector:@selector(performRecognition)];
            }

        }
            break;
            
        case SWITCH_GRADIENT_TEACHING:
        {
            [delegate setGradientTeaching:on];
            
            [(ViewController *)_parentView performSelector:@selector(performRecognition)];
        }
            break;
            
        case SWITCH_REGIONS_METRICS:
        {
            [delegate setRegionsMetrics:on];
            
            [[(ViewController *)_parentView regionSquareThresholdLabel] setHidden:!on];
            [[(ViewController *)_parentView regionSquareThreshold] setHidden:!on];
            [[(ViewController *)_parentView regionSquareThresholdSliderLabel] setHidden:!on];


            
            [[(ViewController *)_parentView formCoefficientAffectionSlider] setHidden:!on];
            [[(ViewController *)_parentView formCoefficientAffectionLabel] setHidden:!on];
            [[(ViewController *)_parentView formCoefficientAffectionSliderLabel]setHidden:!on];
            
            [[(ViewController *)_parentView regionInputSwitcher] setHidden:!on];
            [[(ViewController *)_parentView regionKeySwitcher] setHidden:!on];
            
            [(ViewController *)_parentView performSelector:@selector(performRecognition)];
        }
            break;
            
        case SWITCH_TRAINING_WITH_TEACHER:
        {
            [delegate setTrainingWithTeacher:[(UISwitch *)sender isOn]];

            
            [[(ViewController *)_parentView keyRecognitionChecker] setHidden:!on];
            [[(ViewController *)_parentView hyerigliphRecognitionChecker] setHidden:!on];
            [[(ViewController *)_parentView trainCoefficientLabel] setHidden:!on && ![delegate statisticsCollection]];
            [[(ViewController *)_parentView trainCoefficientSlider] setHidden:!on && ![delegate statisticsCollection]];
            
            [(ViewController *)_parentView performSelector:@selector(performRecognition)];

        }
            break;
            
        case SWITCH_STATISTICS_COLLECTION:
        {
            [delegate setStatisticsCollection:on];
            
            [[(ViewController *)_parentView accuracyLabel] setHidden:!on];
            [[(ViewController *)_parentView keyRecognitionChecker] setHidden:!on && ![delegate trainingWithTeacher]];
            [[(ViewController *)_parentView hyerigliphRecognitionChecker] setHidden:!on && ![delegate trainingWithTeacher]];
        }
            
        default:
        {
            
        }
            break;
    }
}

- (IBAction)closeSettingsView:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}


@end
