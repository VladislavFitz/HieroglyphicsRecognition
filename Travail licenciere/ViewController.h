//
//  ViewController.h
//  Travail licenciere
//  Контроллер главного отображения программы
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import <UIKit/UIKit.h>

const double DEFAULT_TRAIN_COEFFICIENT;

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>


#pragma mark - Выбор иероглифа из коллекции
@property (weak, nonatomic) IBOutlet UIPickerView *hyerogliphPicker;

#pragma mark - Статистика
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

#pragma mark - Настройка порога шума
@property (weak, nonatomic) IBOutlet UILabel *formCoefficientAffectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *formCoefficientAffectionSliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *formCoefficientAffectionSlider;

#pragma mark - Настройка влияния коэффициента формы на результат распознавания
@property (weak, nonatomic) IBOutlet UILabel *regionSquareThresholdSliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *regionSquareThreshold;
@property (weak, nonatomic) IBOutlet UILabel *regionSquareThresholdLabel;

#pragma mark - Иероглиф на входе
@property (weak, nonatomic) IBOutlet UIImageView *inputHyerogliphImage;
@property (weak, nonatomic) IBOutlet UILabel *inputRegionFormCoefficientLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *regionInputSwitcher;
@property (weak, nonatomic) IBOutlet UILabel *regionInputSquareLabel;

#pragma mark - Распознанный ключ
@property (weak, nonatomic) IBOutlet UIImageView *recognizedMainKey;
@property (weak, nonatomic) IBOutlet UILabel *keyRegionFormCoefficientLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *regionKeySwitcher;
@property (weak, nonatomic) IBOutlet UILabel *regionKeySquareLabel;
@property (weak, nonatomic) IBOutlet UILabel *recognizedMainKeyLabel;

#pragma mark - Распознанный иероглиф
@property (weak, nonatomic) IBOutlet UIImageView *recognizedHyerogliphImage;
@property (weak, nonatomic) IBOutlet UILabel *recognizedHyerogliphLabel;

#pragma mark - Контролы обучения
@property (weak, nonatomic) IBOutlet UISegmentedControl *keyRecognitionChecker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hyerigliphRecognitionChecker;
@property (weak, nonatomic) IBOutlet UISlider *trainCoefficientSlider;
@property (weak, nonatomic) IBOutlet UILabel *trainCoefficientLabel;

#pragma mark - Таблицы
@property (weak, nonatomic) IBOutlet UITableView *keyWeightsTable;
@property (weak, nonatomic) IBOutlet UITableView *hyerogliphWeightsTable;

#pragma mark - Вспомогательные контролы
@property (weak, nonatomic) IBOutlet UISegmentedControl *customHyerogliphsEnumerator;
@property (weak, nonatomic) IBOutlet UIImageView *patternImage;

//Запуск распознавания
-(void)performRecognition;

@end
