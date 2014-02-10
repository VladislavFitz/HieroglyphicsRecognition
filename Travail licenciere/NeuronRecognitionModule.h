//
//  NeuronRecognitionModule.h
//  Travail licenciere
//  Логика распознавания иероглифа
//  Created by Владислав Фиц on 26.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyNeuron.h"
#import "HyerogliphNeuron.h"
#import "NeuronGroup.h"
#import "ViewController.h"

@interface NeuronRecognitionModule : NSObject
-(void)recognitionLaunchOfHyerogliphWithImage:(UIImage *)inputHyerogliph;

//Нейрон-победитель при распознавании ключа
@property KeyNeuron * keyNeuronWinner;

//Нейрон-победитель при распознавании иероглифа
@property HyerogliphNeuron * hyerogliphNeuronWinner;

//Результат распознавания иероглифа
@property NSDictionary * finalResult;
//Статистика по результату распознавания иероглифа
@property NSDictionary * finalResultMatching;

//Результат распознавания ключа
@property NSDictionary * priorResult;
//Статистика по результату распознавания ключа
@property NSDictionary * priorResultMatching;

//Массив с паттернами для главных ключей
@property NSArray * patternsCollection;

//Массив с номерами ключей
@property NSMutableArray * keysCollection;

//Массив с количеством иероглифов в подборке
@property NSMutableArray * hyerogliphsCollection;

//Изображение, подающееся на вход
@property UIImage * inputImage;

//Делегат, породивший логику
@property ViewController * delegate;

-(NeuronGroup *) getMainKeysLayer;
-(NeuronGroup *) getGroupWinner;

-(void)pullKeyNeuronsReflectionsResult;

-(void)pullHyerogliphNeuronsReflectionsResult;
-(id)initWithDelegate:(id)delegate;

@end
