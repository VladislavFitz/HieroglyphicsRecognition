//
//  NeuronRecognitionModule.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 26.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "NeuronRecognitionModule.h"

#import "RecognizeStructure.h"
#import "UIImage+UIImage_Pixels.h"
#import "HyerogliphPatternHelper.h"
#import "ImageProcessing.h"
#import "ViewController.h"

@implementation NeuronRecognitionModule

@synthesize keyNeuronWinner = _keyNeuronWinner;
@synthesize hyerogliphNeuronWinner = _hyerogliphNeuronWinner;

@synthesize finalResult = _finalResult;
@synthesize finalResultMatching = _finalResultMatching;

@synthesize priorResult = _priorResult;
@synthesize priorResultMatching = _priorResultMatching;

@synthesize patternsCollection = _patternsCollection;
@synthesize keysCollection = _keysCollection;
@synthesize hyerogliphsCollection = _hyerogliphsCollection;

@synthesize inputImage = _inputImage;

@synthesize delegate = _delegate;


//Структура для распознавания
RecognizeStructure * recognizeStructure;
//Первый слой нейронов с ключами
NeuronGroup * mainKeysLayer;

NeuronGroup * groupWinner;

-(id)init
{
    if (self = [super init])
    {
        _patternsCollection = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:kKAMAE],
                              [NSNumber numberWithInt:kHEN],
                              [NSNumber numberWithInt:kCUKURI],
                              [NSNumber numberWithInt:kKAMMURI],
                              [NSNumber numberWithInt:kASI],
                              [NSNumber numberWithInt:kTARE],
                              [NSNumber numberWithInt:kNE], nil];
        
        //ручное задание ключей и иероглифов
        _keysCollection = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:10],
                          [NSNumber numberWithInt:18],
                          [NSNumber numberWithInt:23],
                          [NSNumber numberWithInt:30],
                          [NSNumber numberWithInt:74],
                          [NSNumber numberWithInt:85],nil];
        
        _hyerogliphsCollection = [NSArray arrayWithObjects:
                                 [NSNumber numberWithInt:1],
                                 [NSNumber numberWithInt:2],
                                 [NSNumber numberWithInt:3],
                                 [NSNumber numberWithInt:4],
                                 [NSNumber numberWithInt:5],nil];
        
        _priorResult = [NSDictionary new];
        _finalResult = [NSDictionary new];
        
        [self createAndInitializeKeyNeuronsLayer];
        [self createAndInitializeRecognitionStructure];
        
    }
    return self;
}

-(id)initWithDelegate:(id)delegate
{
    [self setDelegate:delegate];
    return [self init];
}

#pragma mark - Init Datasource
-(void)createAndInitializeRecognitionStructure
{
    //Формируем структуру с парой ключ-значение, где ключ – k_[№сильного ключа]_[№позиции сильного ключа]
    
    int keyNumber = 0;
    int numberOfPatternsToStudy = 0;
    
    recognizeStructure = [[RecognizeStructure alloc]init];
    
    //Создаём слои нейронов для распознавания целых иероглифов и заносим их в структуру
    
    //Слой с ключом 10
    keyNumber = 10;
    numberOfPatternsToStudy = 5;
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kASI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kHEN
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kNE
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    //Слой с ключом 18
    keyNumber = 18;
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kASI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kKAMMURI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kCUKURI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    //Слой с ключом 23
    keyNumber = 23;
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kKAMAE
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    
    //Слой с ключом 30
    keyNumber = 30;
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kASI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kHEN
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kKAMMURI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    //Слой с ключом 74
    keyNumber = 74;
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kCUKURI
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kHEN
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
    //Слой с ключом 85
    keyNumber = 85;
    [recognizeStructure addNeuronLayer:[self createLayerForMainkey:keyNumber
                                                           Pattern:kHEN
                                                  NumberOfPatterns:numberOfPatternsToStudy]];
    
}

-(void)createAndInitializeKeyNeuronsLayer
{
    //Создание, инициализация и первичное обучение первого слоя нейронной сети
    
    mainKeysLayer = [[NeuronGroup alloc]initWithID:@"k_allKeys_Group"];
    
    NSArray * key10Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:10]allValues]];
    
    [mainKeysLayer addNeurons:key10Neurons];
    
    
    NSArray * key18Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:18]allValues]];
    
    [mainKeysLayer addNeurons:key18Neurons];
    
    
    NSArray * key23Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:23]allValues]];
    
    [mainKeysLayer addNeurons:key23Neurons];
    
    
    
    NSArray * key30Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:30]allValues]];
    
    [mainKeysLayer addNeurons:key30Neurons];
    
    
    
    NSArray * key74Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:74]allValues]];
    
    [mainKeysLayer addNeurons:key74Neurons];
    
    
    
    NSArray * key85Neurons = [[NSArray alloc]initWithArray:[[self createAndInitNeuronsForKey:85]allValues]];
    
    [mainKeysLayer addNeurons:key85Neurons];
}

//Создание слоя нейронной сети для иероглифов с заданным главным ключом в определённой позиции
-(NeuronGroup *)createLayerForMainkey:(int)mainKeyNumber Pattern:(KeyPosition)position NumberOfPatterns:(int)numberOfPatterns
{
    NeuronGroup * layer = [[NeuronGroup alloc]initWithID:[NSString stringWithFormat:@"k_%i_%i_Group", mainKeyNumber, position]];
    
    for (int hyerogliphNumber = 1; hyerogliphNumber <= numberOfPatterns; ++hyerogliphNumber)
    {
        HyerogliphNeuron *hNeuron = [[HyerogliphNeuron alloc]initWithCharVector:[[UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i",
                                                                                                      [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:position],
                                                                                                      mainKeyNumber,
                                                                                                      hyerogliphNumber]] grayscalePixels]
                                                                  mainKeyNumber:mainKeyNumber
                                                                mainKeyPosition:position
                                                               hyerogliphNumber:hyerogliphNumber];
        
        [[layer neurons]addObject:hNeuron];
    }
    
    return layer;
}

//Возвращает словарь со всеми возможными инициализированными нейронами для данного ключа
-(NSMutableDictionary *)createAndInitNeuronsForKey:(int)keyNumber
{
    NSMutableDictionary * neuronsForCurrentKey = [NSMutableDictionary new];
    
    //В цикле попытка создать нейроны для всех возможных шаблонов
    for (int patternNumber=0; patternNumber < NUMBER_OF_PATTERNS; ++patternNumber)
    {
        //Если существует идеальное изображение ключа для нейрона => такое положение ключа возможно и нейрон создаётся
        if ([UIImage imageNamed:[NSString stringWithFormat:@"[%@]%ik_0", [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:patternNumber], keyNumber]])
        {
            KeyNeuron * currentNeuron = [[KeyNeuron alloc] initWithCharVector:[[UIImage imageNamed:[NSString stringWithFormat:@"[%@]%ik_0",
                                                                                                    [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:patternNumber],
                                                                                                    keyNumber]] grayscalePixels]
                                                                    keyNumber:keyNumber
                                                                  keyPosition:patternNumber];
            
            //Обучение нейрона
            for (int picNum = 1; picNum <= 5; ++picNum)
            {
                //Изображение для обучения
                UIImage * inputTrainImage = [UIImage imageNamed:[NSString stringWithFormat:@"[%@]%i_%i",
                                                                 [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:patternNumber],
                                                                 keyNumber,
                                                                 picNum]];
                
                //Градиентное обучение в зависимости от настроек
                if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] gradientTeaching])
                {
                    [currentNeuron trainKeyNeuronWithGradientMatrixWithInputCharVector:[inputTrainImage grayscalePixels] trainCoefficient:[(AppDelegate *)[[UIApplication sharedApplication] delegate]  trainCoefficient]];
                }
                else
                {
                    [currentNeuron trainKeyNeuronWithClippedInputCharVector:[inputTrainImage grayscalePixels]];
                }
            }
            
            //Добавляем нейрон в коллекцию
            [neuronsForCurrentKey setObject: currentNeuron
                                     forKey:[NSString stringWithFormat:@"key%i%@Neuron", keyNumber, [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:patternNumber]]];
        }
    }
    
    //Возвращаем коллекцию
    return neuronsForCurrentKey;
}

/*
//Обработка вектора нейронами
-(void)makeNeurons:(NSArray *)neurons thinkForImage:(unsigned char *)pixelData
{
    NSMutableArray * weights = [[NSMutableArray alloc]init];
    
    for (Neuron * neuron in neurons)
    {
        int number = [neurons indexOfObject:neuron];
        //double weight = [neuron getWeightForInputVector:[NSArray withChar:pixelData]];
        double weight = [neuron getWeightForInputCharVector:pixelData];
        NSMutableDictionary *neuronsWeight = [[NSMutableDictionary alloc]init];
        
        [neuronsWeight setObject:[NSNumber numberWithInt:number] forKey:@"number"];
        [neuronsWeight setObject:[NSNumber numberWithDouble:weight] forKey:@"weight"];
        
        [weights addObject:neuronsWeight];
        NSLog(@"Вес нейрона %i = %f", number+1, weight);
    }
    
    NSArray * orderedWeights = [weights sortedArrayUsingComparator:^(id weight1, id weight2) {
        
        if ([[weight1 valueForKey:@"weight"]intValue] > [[weight2 valueForKey:@"weight"]intValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[weight1 valueForKey:@"weight"]intValue] < [[weight2 valueForKey:@"weight"]intValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSLog(@"Таким образом, Нейронная сеть решила, что это был символ под номером %i",
          [[[orderedWeights objectAtIndex:0]valueForKey:@"number"]intValue]+1);
}
*/

#pragma mark - Neuron Network Actions
//Дисквалификация текущего нейрона-победителя в слое распознавания ключей
-(void)pullKeyNeuronsReflectionsResult
{
    //Дисквалификация нейрона
    [mainKeysLayer pullNeuronsReflectionsResult];
    
    //Вывод обновлённых данных о результатах распознавания ключа
    _priorResult = [mainKeysLayer neuronsReflectionResults];
    _keyNeuronWinner = (KeyNeuron *)[mainKeysLayer winnerNeuron];
    
    //Главный ключ изменился –> перезапуск распознавания иероглифа
    [self recognizeHyerogliph];
}

//Дисквалификация текущего нейрона-победителя в слое распознавания иероглифов
-(void)pullHyerogliphNeuronsReflectionsResult
{
    //Дисквалификация нейрона
    [groupWinner pullNeuronsReflectionsResult];
    
    //Вывод обновлённых данных о результатах распознавания ключа
    _finalResult = [groupWinner neuronsReflectionResults];
    _hyerogliphNeuronWinner = (HyerogliphNeuron *)[groupWinner winnerNeuron];
    
}


//Запуск распознавания
-(void)recognitionLaunchOfHyerogliphWithImage:(UIImage *)inputImage
{
    _inputImage = inputImage;
    
    [self recognizeMainKey];
    [self recognizeHyerogliph];
}

//Распознавание ключа
-(void)recognizeMainKey
{
    if (_inputImage)
    {
        _priorResult = [mainKeysLayer getResultOfGroupReflectionOnVector:[_inputImage grayscalePixels]];
        _priorResultMatching = [mainKeysLayer neuronsMatchingMetrics];
        
        _keyNeuronWinner = (KeyNeuron *)[mainKeysLayer winnerNeuron];        
    }
}

//Распознавание иероглифа
-(void)recognizeHyerogliph
{
    if (_inputImage)
    {
        int winnerKeyPattern = [_keyNeuronWinner keyPosition];
        int winnerKeyNumber = [_keyNeuronWinner keyNumber];
        
        //Извлекаем из структуры с цельными иероглифами суженую выборку для дальнейшего распознавания
        groupWinner = [recognizeStructure objectForKey:[NSString stringWithFormat:@"k_%i_%i_Group",
                                                        winnerKeyNumber,
                                                        winnerKeyPattern]];
    
        _finalResult = [groupWinner getResultOfGroupReflectionOnVector:[_inputImage grayscalePixels]];
        _finalResultMatching = [groupWinner neuronsMatchingMetrics];
        
        _hyerogliphNeuronWinner = (HyerogliphNeuron *)[groupWinner winnerNeuron];
    }
}


//Текстовая интерпретация результата распознавания
-(void)printTextResult
{
     NSLog(@"В ходе своей работы нейронная сеть решила, что это иероглиф с ключом %i в позиции %@, номер из выборки: %i",
     [(HyerogliphNeuron *)[groupWinner winnerNeuron] mainKeyNumber],
     [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:[(HyerogliphNeuron *)[groupWinner winnerNeuron]mainKeyPosition]],
     [(HyerogliphNeuron *)[groupWinner winnerNeuron] hyerogliphNumber]);
     NSLog(@"");
     
}

-(NeuronGroup *) getMainKeysLayer
{
    return mainKeysLayer;
}

-(NeuronGroup *) getGroupWinner
{
    return groupWinner;
}
    
@end

