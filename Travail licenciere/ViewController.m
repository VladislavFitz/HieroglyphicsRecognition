//
//  ViewController.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "UIImage+UIImage_Pixels.h"
#import "Neuron.h"
#import "NeuronGroup.h"
#import "KeyNeuron.h"
#import "HyerogliphNeuron.h"
#import "NSArray+pixelsData.h"
#import "HyerogliphPatternHelper.h"
#import "RecognizeStructure.h"
#import "ImageProcessing.h"
#import <CoreImage/CoreImage.h>
#import "StatisticsHelper.h"
#import "NeuronRecognitionModule.h"
#import "ImagePickerViewController.h"
#import "SettingsViewController.h"
#import "Region.h"



#pragma mark - UI Components Tags

#define KEYS_ROW 0
#define PATTERNS_ROW 1
#define HYEROGLIPHS_ROW 2

#define KEY_WEIGHTS_TABLE_TAG 1
#define HYEROGLIPH_WEIGHTS_TABLE_TAG 2

#define NUMBER_OF_COMPONENTS 3

#define SEGMENTED_KEY_CHECKER 0
#define SEGMENTED_HYEROGLIPH_CHECKER 1

#define TEACHER_VERDICT_CORRECT 0
#define TEACHER_VERDICT_INCORRECT 1

#define TAB_BAR_RECOGNITION 0
#define TAB_BAR_TAKEPHOTO 1
#define TAB_BAR_SETTINGS 2

#define CUSTOM_ENUMERATOR_PREVIOUS 0
#define CUSTOM_ENUMERATOR_APPLY 1
#define CUSTOM_ENUMERATOR_NEXT 2

#define TRAIN_COEFFICIENT_SLIDER 0
#define REGIONS_SQUARE_THRESHOLD_SLIDER 1
#define FORM_COEFFICIENT_AFFECTION_SLIDER 2

#define INPUT_REGIONS_SWITCHER 15
#define KEY_REGIONS_SWITCHER 20

#pragma mark - Initial Settings

#define STARTING_HYEROGLIPH 1
#define STARTING_KEY 10
#define STARTING_PATTERN @"ASI"
#define NUMBEROFIMAGESFORSTUDY 9
#define NO_HYEROGLIPH_IMAGE_NAME @"no_hyerogliph"

@interface ViewController ()

@end
//int weight1 = 0, weight2 = 0;

//Текущий паттерн
KeyPosition pattern;

//Текущий номер ключа
NSInteger numberOfKey;

//Текущий номер иероглифа в подборке
NSInteger numberOfHyerogliph;

StatisticsHelper * statisticsManager;

NeuronRecognitionModule *recognizer;

NSArray * inputRegions;

AppDelegate * delegate;

BOOL keyImagePatternView = NO;
BOOL hyerogliphImagePatternView = NO;
BOOL showClippedInputImage = NO;

const int countOfCustomHyerogliphs = 50;

@implementation ViewController

#pragma mark - Выбор иероглифа из коллекции
@synthesize hyerogliphPicker = _hyerogliphPicker;

#pragma mark - Статистика
@synthesize accuracyLabel = _accuracyLabel;

#pragma mark - Настройка порога шума
@synthesize regionSquareThreshold = _regionSquareThreshold;
@synthesize regionSquareThresholdLabel = _regionSquareThresholdLabel;
@synthesize regionSquareThresholdSliderLabel = _regionSquareThresholdSliderLabel;

#pragma mark - Настройка влияния коэффициента формы на результат распознавания
@synthesize formCoefficientAffectionLabel = _formCoefficientAffectionLabel;
@synthesize formCoefficientAffectionSlider = _formCoefficientAffectionSlider;
@synthesize formCoefficientAffectionSliderLabel = _formCoefficientAffectionSliderLabel;

#pragma mark - Иероглиф на входе
@synthesize inputHyerogliphImage = _inputHyerogliphImage;
@synthesize regionInputSwitcher = _regionInputSwitcher;
@synthesize inputRegionFormCoefficientLabel = _inputRegionFormCoefficientLabel;
@synthesize regionInputSquareLabel = _regionInputSquareLabel;

#pragma mark - Распознанный ключ
@synthesize recognizedMainKey = _recognizedMainKey;
@synthesize recognizedMainKeyLabel = _recognizedMainKeyLabel;
@synthesize regionKeySwitcher = _regionKeySwitcher;
@synthesize keyRegionFormCoefficientLabel = _keyRegionFormCoefficientLabel;
@synthesize regionKeySquareLabel = _regionKeySquareLabel;

#pragma mark - Распознанный иероглиф
@synthesize recognizedHyerogliphImage = _recognizedHyerogliphImage;
@synthesize recognizedHyerogliphLabel = _recognizedHyerogliphLabel;

#pragma mark - Контролы обучения
@synthesize trainCoefficientLabel = _trainCoefficientLabel;

#pragma mark - Таблицы
@synthesize keyWeightsTable = _keyWeightsTable;
@synthesize hyerogliphWeightsTable = _hyerogliphWeightsTable;

#pragma mark - Вспомогательные контролы
@synthesize patternImage = _patternImage;
@synthesize customHyerogliphsEnumerator = _customHyerogliphsEnumerator;


#pragma mark - TableView Delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:AutoCompleteRowIdentifier];
    }

    switch ([tableView tag])
    {
        case KEY_WEIGHTS_TABLE_TAG:
        {
            NSString * kNeuronID = [[[recognizer priorResult] allKeys] objectAtIndex:indexPath.row];
            double matchingValue = [[[recognizer priorResultMatching] valueForKey:kNeuronID]doubleValue];
            
            [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ : %.2f%%", kNeuronID , matchingValue ]];
            
            [cell.textLabel setText:[NSString stringWithFormat:@"%i", [[[[recognizer priorResult] allValues] objectAtIndex:indexPath.row]intValue]]];
            
            [[cell imageView] setImage:[UIImage imageNamed:kNeuronID]];
            
            [cell setBackgroundColor:[UIColor colorWithRed:1 - matchingValue
                                                     green:matchingValue
                                                      blue:0
                                                     alpha:1]];
        }
        break;
            
        case HYEROGLIPH_WEIGHTS_TABLE_TAG:
        {
            NSString * hNeuronID = [[[recognizer finalResult] allKeys] objectAtIndex:indexPath.row];
            double matchingValue = [[[recognizer finalResultMatching] valueForKey:hNeuronID]doubleValue];
            
            
            [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ : %.2f%%", hNeuronID, matchingValue ]];
            
            [cell.textLabel setText:[NSString stringWithFormat:@"%i", [[[[recognizer finalResult] allValues] objectAtIndex:indexPath.row]intValue]]];
            
            [[cell imageView] setImage:[UIImage imageNamed:hNeuronID]];
            
            [cell setBackgroundColor:[UIColor colorWithRed:1 - matchingValue
                                                     green:matchingValue
                                                      blue:0
                                                     alpha:1]];
            
        }
        break;
    default:
        break;
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ([tableView tag])
    {
        case KEY_WEIGHTS_TABLE_TAG:
            return [[[recognizer priorResult] allValues]count];
            break;
        case HYEROGLIPH_WEIGHTS_TABLE_TAG:
            return [[[recognizer finalResult] allValues] count];
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([tableView tag])
    {
        case KEY_WEIGHTS_TABLE_TAG:
        {
            NSString * selectedKeyID = [[[recognizer priorResult] allKeys] objectAtIndex:indexPath.row];
            [_patternImage setImage:[UIImage getImageWithGrayScalePixels:
                                    [[[recognizer getMainKeysLayer] neuronWithID:selectedKeyID] charNeuronState]
                                                                  width:100
                                                                  height:100]];
        }
            break;
            
        case HYEROGLIPH_WEIGHTS_TABLE_TAG:
        {
            NSString * selectedHyerogliphID = [[[recognizer finalResult] allKeys] objectAtIndex:indexPath.row];
            
            [_patternImage setImage:[UIImage getImageWithGrayScalePixels:[[[recognizer getGroupWinner] neuronWithID:selectedHyerogliphID] charNeuronState]
                                                                   width:100
                                                                  height:100]];
        }
            break;
        default:
            break;
    }


}

#pragma mark - PickerView Delegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return NUMBER_OF_COMPONENTS;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case KEYS_ROW:
            return [[recognizer keysCollection] count];
            break;
        case PATTERNS_ROW:
            return [[recognizer patternsCollection] count];
            break;
        case HYEROGLIPHS_ROW:
            return [[recognizer hyerogliphsCollection] count];
            break;
        default:
            return 0;
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (![_customHyerogliphsEnumerator isEnabledForSegmentAtIndex:CUSTOM_ENUMERATOR_APPLY])
    {
        [_customHyerogliphsEnumerator setEnabled:YES
                               forSegmentAtIndex:CUSTOM_ENUMERATOR_APPLY];
        
        numberOfKey = [_hyerogliphPicker selectedRowInComponent:KEYS_ROW];
        pattern = [_hyerogliphPicker selectedRowInComponent:PATTERNS_ROW];
        numberOfHyerogliph = [_hyerogliphPicker selectedRowInComponent:HYEROGLIPHS_ROW];
    }
    
    switch (component)
    {
        case KEYS_ROW:
            numberOfKey = [[[recognizer keysCollection] objectAtIndex:row] intValue];
            break;
        case PATTERNS_ROW:
            pattern = [[[recognizer patternsCollection] objectAtIndex:row]intValue] ;
            break;
        case HYEROGLIPHS_ROW:
            numberOfHyerogliph = [[[recognizer hyerogliphsCollection] objectAtIndex:row]intValue];
            break;
        default:
            break;
    }
    
    if ([self refreshInputHyerogliphImage] && [delegate fastRecognition])
    {
        [self performRecognition];
    };
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case KEYS_ROW:
            return [NSString stringWithFormat:@"%i", [[[recognizer keysCollection] objectAtIndex:row]intValue] ];
            break;
        case PATTERNS_ROW:
            return [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber: [[[recognizer patternsCollection] objectAtIndex:row]intValue]];
            break;
        case HYEROGLIPHS_ROW:
            return [NSString stringWithFormat:@"%i", [[[recognizer hyerogliphsCollection] objectAtIndex:row]intValue]];
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - ViewController lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    recognizer = [[NeuronRecognitionModule alloc]initWithDelegate:self];
    
    numberOfHyerogliph = STARTING_HYEROGLIPH;
    numberOfKey = STARTING_KEY;
    pattern = [HyerogliphPatternHelper getNumberOfPatternForPatternName:STARTING_PATTERN];
    
    [_hyerogliphPicker setDataSource:self];
    [_hyerogliphPicker setDelegate:self];
    
    [_keyWeightsTable setDelegate:self];
    [_keyWeightsTable setDataSource:self];
    
    [_hyerogliphWeightsTable setDelegate:self];
    [_hyerogliphWeightsTable setDataSource:self];
    
    statisticsManager = [StatisticsHelper new];
    [_accuracyLabel setText:[NSString stringWithFormat:@"Точность: %3.f%%", [statisticsManager getAccuracy]]];
    [_accuracyLabel setHidden:![delegate statisticsCollection]];
    
    [_keyRecognitionChecker setHidden:![delegate trainingWithTeacher] && ![delegate statisticsCollection]];
    [_hyerigliphRecognitionChecker setHidden:![delegate trainingWithTeacher] && ![delegate statisticsCollection]];
    [_trainCoefficientLabel setHidden:![delegate trainingWithTeacher]];
    [_trainCoefficientSlider setHidden:![delegate trainingWithTeacher]];
    [_trainCoefficientSlider setValue:[delegate trainCoefficient]];
    [_trainCoefficientLabel setText:[NSString stringWithFormat:@"%.2f", [delegate trainCoefficient]]];
    
    [_regionSquareThresholdLabel setHidden:![delegate regionsMetrics]];
    [_regionSquareThreshold setHidden:![delegate regionsMetrics]];
    [_regionSquareThresholdSliderLabel setHidden:![delegate regionsMetrics]];
    [_regionSquareThreshold setValue:[delegate regionSquareThresholdValue]];
    [_regionSquareThresholdLabel setText:[NSString stringWithFormat:@"%i", [delegate regionSquareThresholdValue]]];
    
    [_regionInputSwitcher setHidden:![delegate regionsMetrics]];
    [_regionKeySwitcher setHidden:![delegate regionsMetrics]];
    
    
    [_formCoefficientAffectionLabel setHidden:![delegate regionsMetrics]];
    [_formCoefficientAffectionSlider setHidden:![delegate regionsMetrics]];
    [_formCoefficientAffectionSliderLabel setHidden:![delegate regionsMetrics]];
    [_formCoefficientAffectionSlider setValue:[delegate formCoefficientAffection]];
    [_formCoefficientAffectionLabel setText:[NSString stringWithFormat:@"%.2f", [delegate formCoefficientAffection]]];
    
    
    [_inputRegionFormCoefficientLabel setText:@""];
    [_keyRegionFormCoefficientLabel setText:@""];
    [_recognizedHyerogliphLabel setText:@""];
    [_recognizedMainKeyLabel setText:@""];
    [_regionInputSquareLabel setText:@""];
    [_regionKeySquareLabel setText:@""];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(swipeLeft:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_customHyerogliphsEnumerator addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(swipeRight:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_customHyerogliphsEnumerator addGestureRecognizer:swipeRight];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshInputHyerogliphImage];
    [self performSelector:@selector(performRecognition)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Gesture Recognizers
-(IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender
{
    if (numberOfHyerogliph > 1)
    {
        --numberOfHyerogliph;
        
        if ([self refreshInputHyerogliphImage] && [delegate fastRecognition])
        {
            [self performRecognition];
        };
    }
}

-(IBAction)swipeRight:(UISwipeGestureRecognizer *)sender
{
    if (numberOfHyerogliph <= [[recognizer hyerogliphsCollection] count])
    {
        ++numberOfHyerogliph;
        
        if ([self refreshInputHyerogliphImage] && [delegate fastRecognition])
        {
            [self performRecognition];
        };
    }
}
#pragma mark - Button actions

- (IBAction)recognizeButton:(id)sender
{
    if ([self refreshInputHyerogliphImage] && [delegate fastRecognition])
        [self performRecognition];
}


- (IBAction)customHyerogliphControl:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case CUSTOM_ENUMERATOR_APPLY:
        {
            numberOfHyerogliph = 1;
            numberOfKey = 0;
            pattern = kASI;
            
            [_customHyerogliphsEnumerator setEnabled:YES
                                   forSegmentAtIndex:CUSTOM_ENUMERATOR_NEXT];
            
            [_customHyerogliphsEnumerator setEnabled:NO
                                   forSegmentAtIndex:CUSTOM_ENUMERATOR_PREVIOUS];
            
            [_customHyerogliphsEnumerator setEnabled:NO
                                   forSegmentAtIndex:CUSTOM_ENUMERATOR_APPLY];
        
        }
            break;
            
        case CUSTOM_ENUMERATOR_NEXT:
        {
            numberOfHyerogliph = ++numberOfHyerogliph;
            numberOfKey = 0;
            pattern = kASI;

            if (numberOfHyerogliph == countOfCustomHyerogliphs)
            {
                [_customHyerogliphsEnumerator setEnabled:NO
                                       forSegmentAtIndex:CUSTOM_ENUMERATOR_NEXT];
            }
            
            [_customHyerogliphsEnumerator setEnabled:YES
                                   forSegmentAtIndex:CUSTOM_ENUMERATOR_PREVIOUS];
        }
            break;
            
        case CUSTOM_ENUMERATOR_PREVIOUS:
        {
            numberOfHyerogliph = --numberOfHyerogliph;
            numberOfKey = 0;
            pattern = kASI;
            
            if (numberOfHyerogliph == 1)
            {
                [_customHyerogliphsEnumerator setEnabled:NO
                                       forSegmentAtIndex:CUSTOM_ENUMERATOR_PREVIOUS];
            }
            
            [_customHyerogliphsEnumerator setEnabled:YES
                                   forSegmentAtIndex:CUSTOM_ENUMERATOR_NEXT];
        }
            break;
            
            default:
            break;
    }
    
    if ([self refreshInputHyerogliphImage] && [delegate fastRecognition])
    {
        [self performRecognition];
    }
}

- (IBAction)getTeacherCorrection:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case TEACHER_VERDICT_CORRECT:
        {
            if ([delegate statisticsCollection])
            {
                [statisticsManager addSuccessAttemptCount];
                [_accuracyLabel setText:[NSString stringWithFormat:@"Точность: %3.f%%", [statisticsManager getAccuracy]]];
            }
            
            if([delegate trainingWithTeacher])
            {
                int winnerKeyPattern = [[recognizer keyNeuronWinner] keyPosition];

                //Обучить нейрон на векторе

                if ([delegate gradientTeaching])
                {
                    switch ([sender tag]) {
                        case SEGMENTED_KEY_CHECKER:
                        {
                            [[recognizer keyNeuronWinner]trainKeyNeuronWithGradientMatrixWithInputCharVector:[[_inputHyerogliphImage image]grayscalePixels]
                                                                                            trainCoefficient:[delegate trainCoefficient]];
                        }
                            break;
                        case SEGMENTED_HYEROGLIPH_CHECKER:
                        {
                            [[recognizer hyerogliphNeuronWinner] trainNeuronWithGradientMatrixWithInputCharVector:[[_inputHyerogliphImage image]grayscalePixels]
                                                                                              andTrainCoefficient:[delegate trainCoefficient]];
                        }
                            break;
                        default:
                            break;
                    }
                }
                else
                {
                    switch ([sender tag])
                    {
                        case SEGMENTED_KEY_CHECKER:
                        {
                            [ImageProcessing printTextInterpretationOfImage:[[recognizer keyNeuronWinner] charNeuronState]];
                            [ImageProcessing printTextInterpretationOfImage:[[_recognizedMainKey image] grayscalePixels]];
                            
                            [[recognizer keyNeuronWinner] trainNeuronWithInputCharVector:[HyerogliphPatternHelper clipVector:[[_inputHyerogliphImage image]grayscalePixels]
                                                                                                                 withPattern:winnerKeyPattern] andTrainCoefficient:[delegate trainCoefficient]];
                        }
                            break;
                        case SEGMENTED_HYEROGLIPH_CHECKER:
                        {
                            [[recognizer hyerogliphNeuronWinner] trainNeuronWithInputCharVector:[[_inputHyerogliphImage image]grayscalePixels]
                                                                            andTrainCoefficient:[delegate trainCoefficient]];
                        }
                            break;
                        default:
                            break;
                    }
                }
                [self refreshRecognizedKeyImage];
                [self refreshRecognizedHyerogliphImage];
            }
        }
        break;
            
        case TEACHER_VERDICT_INCORRECT:
        {
            if ([delegate statisticsCollection])
            {
                [statisticsManager addFailedAttemptCount];
                [_accuracyLabel setText:[NSString stringWithFormat:@"Точность: %3.f%%", [statisticsManager getAccuracy]]];
            }
                        
            if([delegate trainingWithTeacher])
            {
                //Дисквалифицировать нейрон победитель
                switch ([sender tag])
                {
                    case SEGMENTED_KEY_CHECKER:
                    {
                        [recognizer pullKeyNeuronsReflectionsResult];
                    }
                        break;
                    
                    case SEGMENTED_HYEROGLIPH_CHECKER:
                    {
                        [recognizer pullHyerogliphNeuronsReflectionsResult];
                    }
                        break;
            
                    default:
                    {
                    
                    }
                        break;
                }
            
                [_keyWeightsTable reloadData];
                [_hyerogliphWeightsTable reloadData];
                [self refreshRecognizedKeyImage];
                [self refreshRecognizedHyerogliphImage];
            }
        }
        break;
    }
    
    [statisticsManager showStatisticsLog];
}
- (IBAction)settingsButtonClicked:(id)sender
{
    SettingsViewController*  settings = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController"
                                                                                bundle:nil];
    [settings setModalPresentationStyle:UIModalPresentationFormSheet];
    [settings setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [settings setDelegate:self];
    [self presentViewController:settings
                       animated:YES
                     completion:nil];
}

- (IBAction)cameraButtonClicked:(id)sender {
    ImagePickerViewController * cameraPicker= [[ImagePickerViewController alloc]initWithNibName:@"ImagePickerViewController"
                                                                                         bundle:nil];
    [cameraPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [cameraPicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:cameraPicker
                       animated:YES
                     completion:nil];
}
- (IBAction)resetStatistics:(id)sender
{
    [statisticsManager resetCounter];
    [_accuracyLabel setText:[NSString stringWithFormat:@"Точность: %3.f%%", [statisticsManager getAccuracy]]];
}


- (IBAction)changeKeyView:(id)sender
{
    keyImagePatternView = !keyImagePatternView;
    [self refreshRecognizedKeyImage];
}
- (IBAction)changeHyerogliphView:(id)sender
{
    hyerogliphImagePatternView = !hyerogliphImagePatternView;
    [self refreshRecognizedHyerogliphImage];
}

- (IBAction)changeInputImageView:(id)sender
{
    showClippedInputImage = !showClippedInputImage;
    [self refreshInputHyerogliphImage];
}


#pragma mark - Slider actions
- (IBAction)sliderValueChanged:(id)sender
{
    switch ([sender tag])
    {
        case TRAIN_COEFFICIENT_SLIDER:
        {
            [delegate setTrainCoefficient:[(UISlider *)sender value]];
            [_trainCoefficientLabel setText:[NSString stringWithFormat:@"%.2f",[delegate trainCoefficient]]];
        }
            break;
            
        case REGIONS_SQUARE_THRESHOLD_SLIDER:
        {
            [delegate setRegionSquareThresholdValue:[(UISlider *)sender value]];
            [_regionSquareThresholdLabel setText:[NSString stringWithFormat:@"%i", [delegate regionSquareThresholdValue]]];
        }
            break;
            
        case FORM_COEFFICIENT_AFFECTION_SLIDER:
        {
            [delegate setFormCoefficientAffection:[(UISlider *)sender value]];
            [_formCoefficientAffectionLabel setText:[NSString stringWithFormat:@"%.2f", [delegate formCoefficientAffection]]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Page Controller Actions
- (IBAction)regionChanged:(id)sender
{
    switch ([sender tag]) {
        case INPUT_REGIONS_SWITCHER:
        {
            Region * reg = [inputRegions objectAtIndex:[(UIPageControl*)sender currentPage]];

            [_inputHyerogliphImage setImage:[UIImage getImageWithGrayScalePixels:[reg regionPixels]
                                                                           width:100
                                                                          height:100]];
            
            [_inputRegionFormCoefficientLabel setText:[NSString stringWithFormat:@"%.3f", reg.formCoefficient]];
            [_regionInputSquareLabel setText:[NSString stringWithFormat:@"%i", reg.square]];
            


            
        }
            break;
        case KEY_REGIONS_SWITCHER:
        {
            Region * reg = (Region *)[[[recognizer keyNeuronWinner] regions]objectAtIndex:[(UIPageControl*)sender currentPage]];
            
            [_recognizedMainKey setImage:[UIImage getImageWithGrayScalePixels:[reg regionPixels]
                                                                        width:100
                                                                       height:100]];
            
            [_keyRegionFormCoefficientLabel setText:[NSString stringWithFormat:@"%.3f", reg.formCoefficient]];
            [_regionKeySquareLabel setText:[NSString stringWithFormat:@"%i", reg.square]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Hyerogliphs & Keys Images
-(BOOL)refreshInputHyerogliphImage
{
    [_inputRegionFormCoefficientLabel setText:@""];
    [_regionInputSquareLabel setText:@""];


    //Установка изображения входного иероглифа
    if (![UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i", [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:pattern], (int)numberOfKey, (int)numberOfHyerogliph]])
    {
        [_inputHyerogliphImage setImage:[UIImage imageNamed:NO_HYEROGLIPH_IMAGE_NAME]];
        
        [_recognizedHyerogliphImage setImage:nil];
        [_recognizedHyerogliphLabel setText:@""];

        [_recognizedMainKey setImage:nil];
        [_recognizedMainKeyLabel setText:@""];
        
        return NO;
    }
    else
    {
        UIImage * inputImage = [UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i", [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:pattern], (int)numberOfKey, (int)numberOfHyerogliph]];

        if (showClippedInputImage && [[recognizer getMainKeysLayer] winnerNeuron])
        {
            KeyPosition pos = [(KeyNeuron *)[[recognizer getMainKeysLayer] winnerNeuron] keyPosition];

            UIImage * clippedInputImage = [UIImage getImageWithGrayScalePixels:[HyerogliphPatternHelper clipVector:[inputImage grayscalePixels]
                                                                                                       withPattern:pattern]
                                                                         width:100
                                                                        height:100];
            [_inputHyerogliphImage setImage:clippedInputImage];
        }
        else
        {
            [_inputHyerogliphImage setImage:inputImage];
        }

        if (![delegate fastRecognition])
        {
            [_recognizedHyerogliphImage setImage:nil];
            [_recognizedHyerogliphLabel setText:@""];
            
            [_recognizedMainKey setImage:nil];
            [_recognizedMainKeyLabel setText:@""];
            
        }
        
        //[self refreshInputImageRegions];

        return YES;
    }
    
 
}


-(void)refreshRecognizedKeyImage
{
    [_keyRegionFormCoefficientLabel setText:@""];
    [_regionKeySquareLabel setText:@""];
    
    //Обновление информации о распознанном ключе
    
    UIImage * imgKey = [[UIImage alloc]init];
    
    int winnerKeyPattern = [[recognizer keyNeuronWinner] keyPosition];
    int winnerKeyNumber = [[recognizer keyNeuronWinner] keyNumber];
    
    imgKey = [UIImage imageNamed:[NSString stringWithFormat:@"[%@]%ik_%i",
                                  [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:winnerKeyPattern],
                                  winnerKeyNumber,
                                  0]];
    
    if (!imgKey)
    {
        [_recognizedMainKey setImage:[UIImage imageNamed:NO_HYEROGLIPH_IMAGE_NAME]];
        [_recognizedMainKeyLabel setText:@""];
    }
    else
    {
        [_recognizedMainKeyLabel setText:[NSString stringWithFormat:@"%i", winnerKeyNumber]];
        if(keyImagePatternView)
        {
            [_recognizedMainKey setImage:[UIImage getImageWithGrayScalePixels:[[recognizer keyNeuronWinner] charNeuronState]
                                                                      width:100
                                                                     height:100]];
        }
        else
        {
            [_recognizedMainKey setImage:imgKey];
        }
    }
    
    [_keyWeightsTable reloadData];
    if(showClippedInputImage)
    {
        [self refreshInputHyerogliphImage];
    }
    
    [_keyRegionFormCoefficientLabel setText:@""];
    [_regionKeySquareLabel setText:@""];
    //[self refreshKeyRegions];



}

-(void)refreshRecognizedHyerogliphImage
{
    //Обновление информации о распознанном иероглифе
    
    UIImage * imgHyerogliph = [[UIImage alloc]init];
    
    int winnerHyerogliphKeyPosition  = [[recognizer hyerogliphNeuronWinner]mainKeyPosition];
    int winnerHyerogliphKeyNumber = [[recognizer hyerogliphNeuronWinner]mainKeyNumber];
    int winnerHyerogliphNumber = [[recognizer hyerogliphNeuronWinner] hyerogliphNumber];
    
    imgHyerogliph = [UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i",
                                         [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:winnerHyerogliphKeyPosition],
                                         winnerHyerogliphKeyNumber,
                                         winnerHyerogliphNumber]];
    
    
    if (!imgHyerogliph)
    {
        [_recognizedHyerogliphImage setImage:[UIImage imageNamed:NO_HYEROGLIPH_IMAGE_NAME]];
        [_recognizedHyerogliphLabel setText:@""];
    }
    else
    {
        [_recognizedHyerogliphLabel setText:[NSString stringWithFormat:@"%i", winnerHyerogliphNumber]];
        if(hyerogliphImagePatternView)
        {
             [_recognizedHyerogliphImage setImage:[UIImage getImageWithGrayScalePixels:[[recognizer hyerogliphNeuronWinner] charNeuronState]
                                                                                 width:100
                                                                                height:100]];
        }
        else
        {
            [_recognizedHyerogliphImage setImage:imgHyerogliph];
        }

    }
    
    [_hyerogliphWeightsTable reloadData];
}

#pragma mark - Regions refreshing
-(void)refreshKeyRegions
{
    if ([delegate regionsMetrics] && [[recognizer getMainKeysLayer] winnerNeuron])
    {
        int regCount = [[[recognizer keyNeuronWinner] regions]count];
        [_regionKeySwitcher setNumberOfPages:regCount];
    }
}

-(void)refreshInputImageRegions
{
    
    if ([delegate regionsMetrics] && [[recognizer getMainKeysLayer] winnerNeuron])
    {
        KeyPosition pos = [(KeyNeuron *)[[recognizer getMainKeysLayer] winnerNeuron] keyPosition];
        
        inputRegions = [ImageProcessing getRegionsForVector:[HyerogliphPatternHelper clipVector:[[_inputHyerogliphImage image] grayscalePixels]
                                                                                    withPattern:pattern]];
        
        inputRegions = [ImageProcessing filteredRegions:inputRegions
                                    withSquareThreshold:[delegate regionSquareThresholdValue]];
        
        [_regionInputSwitcher setNumberOfPages:inputRegions.count];
        
    }
}


#pragma mark -

//Запуск распознавания
-(void)performRecognition
{
    UIImage * test = [[UIImage alloc]init];
    test = [UIImage imageNamed:@"black"];
    
    NSString * position =  [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:pattern];
    
    test = [UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i", position, (int)numberOfKey, (int)numberOfHyerogliph]];
    
    [recognizer recognitionLaunchOfHyerogliphWithImage:test];
    
    [self refreshRecognizedKeyImage];
    [self refreshRecognizedHyerogliphImage];
    
    if ([delegate regionsMetrics])
    {
        [self refreshInputImageRegions];
        [self refreshKeyRegions];
    }

}

-(NSArray *)getPatternsForKeyWithNumber:(int)number
{
    NSMutableArray * patterns = [NSMutableArray new];
    
    for (NSNumber * pattern in [recognizer patternsCollection])
    {        
        if ([UIImage imageNamed:[NSString stringWithFormat:@"[%@]%ik_%i",
                                 [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:[pattern intValue]],
                                 number,
                                 1]])
        {
            [patterns addObject:pattern];
        }
    }

    return [NSArray arrayWithArray:patterns];

}

//Проверялка паттернов и резалок
/*
 for (NSNumber * pattern in patterns)
 {
 unsigned char * vector = [test grayscalePixels];
 for (int i = 0; i<VECTORLENGTH; ++i) {
 vector[i]=1;
 }
 [ViewController printTextInterpretationOfImage:[HyerogliphPatternHelper clipVector:vector withPattern:[pattern intValue]]];
 
 NSArray * pt = [ImageProcessing applyGradientMatrix:[HyerogliphPatternHelper getGradientMatrixForPattern:[pattern intValue]] onVector:vector];
 
 for (int i = 0; i < VECTORLENGTH; ++i)
 {
 printf("%.2f\t", [[pt objectAtIndex:i] doubleValue]);
 if (i-(i/100)*100 == 99)
 printf("\n");
 }
 }
 */



@end
