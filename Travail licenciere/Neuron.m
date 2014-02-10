//
//  Neuron.m
//  Travail licenciere
//  Класс нейрона для сети
//  Created by Владислав Фиц on 06.11.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import "Neuron.h"
#import "ImageProcessing.h"
#import "HyerogliphPatternHelper.h"
#import "ViewController.h"
#import "ViewController.h"
#import "Region.h"
#import "UIImage+UIImage_Pixels.h"

@implementation Neuron
@synthesize neuronState = _neuronState;
@synthesize charNeuronState = _charNeuronState;
@synthesize trainCoefficient = _trainCoefficient;
@synthesize neuronID = _neuronID;
@synthesize regions = _regions;

//Инициализация нейрона массивом
- (id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID
{
    if (self = [super init])
    {
        _neuronID = neuronID;
        _neuronState = [[NSMutableArray alloc]initWithArray:inputVector];
        _regions = [NSMutableArray new];
        self.trainCoefficient = [(AppDelegate *)[[UIApplication sharedApplication] delegate] trainCoefficient];
    }
    return self;
}

//Инициализация нейрона вектором
-(id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID
{
    if (self = [super init])
    {
        _neuronID = neuronID;
        _charNeuronState = inputVector;
        _regions = [NSMutableArray new];
        self.trainCoefficient = [(AppDelegate *)[[UIApplication sharedApplication] delegate] trainCoefficient];
    }
    return self;
}

//Обучения нейрона с коэффициентом обучения по умолчанию
-(NSArray *)trainNeuronWithInputVector:(NSArray *)inputVector
{
    int pixelCounter = 0;
    
    for (pixelCounter = 0; pixelCounter < inputVector.count; ++pixelCounter)
    {
        int currentPixelValue = [[_neuronState objectAtIndex:pixelCounter]intValue];
        int inputPixelValue = [[inputVector objectAtIndex:pixelCounter]intValue];
        int newWeight = currentPixelValue - (currentPixelValue - inputPixelValue)*_trainCoefficient;
        
        [_neuronState replaceObjectAtIndex:pixelCounter
                                withObject:[NSNumber numberWithInt:newWeight]];
    }
    //[self refreshRegions];
    return _neuronState;
}

//Обучения нейрона на массиве с заданным коэффициентом обучения
-(NSArray *)trainNeuronWithInputVector:(NSArray *)inputVector andTrainCoefficient:(double)coefficient
{
    int pixelCounter = 0;
    
    for (pixelCounter = 0; pixelCounter < inputVector.count; ++pixelCounter)
    {
        int currentPixelValue = [[_neuronState objectAtIndex:pixelCounter]intValue];
        int inputPixelValue = [[inputVector objectAtIndex:pixelCounter]intValue];
        int newWeight = currentPixelValue - (currentPixelValue - inputPixelValue)*coefficient;
        
        [_neuronState replaceObjectAtIndex:pixelCounter
                                withObject:[NSNumber numberWithInt:newWeight]];
    }
    //[self refreshRegions];
    return _neuronState;
}

//Обучение нейрона со стандартным коэффициентом обучения
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector
{
    int pixelCounter = 0;
    
    for (pixelCounter = 0; pixelCounter < VECTORLENGTH; ++pixelCounter )
    {
        int currenPixelValue = _charNeuronState[pixelCounter];
        int inputPixelValue = inputVector[pixelCounter];
        int newWeight = currenPixelValue - (currenPixelValue-inputPixelValue)*_trainCoefficient;
        
        _charNeuronState[pixelCounter] = newWeight;
    }
    //[self refreshRegions];
    return _charNeuronState;
}

//Обучение нейрона с заданными коэффициентом обучения
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector andTrainCoefficient:(double)coefficient
{
    int pixelCounter = 0;
    
    for (pixelCounter = 0; pixelCounter < VECTORLENGTH; ++pixelCounter )
    {
        int currenPixelValue = _charNeuronState[pixelCounter];
        int inputPixelValue = inputVector[pixelCounter];
        int newWeight = currenPixelValue - (currenPixelValue-inputPixelValue)*coefficient;
        
        _charNeuronState[pixelCounter] = newWeight;
    }
    //[self refreshRegions];
    return _charNeuronState;
}

//Обучение нейрона на векторе с использованием матрицы градиентного обучения и заданным коэфициентом обучения
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector trainMatrixForPattern:(KeyPosition)pattern trainCoefficient:(double)coefficient
{
    int pixelCounter = 0;
    NSArray * gradientMatrix = [HyerogliphPatternHelper getGradientMatrixForPattern:pattern withTrainCoefficient:coefficient];
    
    for (pixelCounter = 0; pixelCounter < VECTORLENGTH; ++pixelCounter )
    {
        double coefficient = [[gradientMatrix objectAtIndex:pixelCounter]doubleValue];
        int currenPixelValue = _charNeuronState[pixelCounter];
        int inputPixelValue = inputVector[pixelCounter];
        int newWeight = currenPixelValue - (currenPixelValue-inputPixelValue)*coefficient;
        
        _charNeuronState[pixelCounter] = newWeight;
    }
    
    //[self refreshRegions];
    return _charNeuronState;
}

//Получить вес для входного массива
-(double)getWeightForInputVector:(NSArray *)inputVector
{
    double weight = 0;
    int pixelCounter = 0;

    for (pixelCounter = 0; pixelCounter < inputVector.count; ++pixelCounter)
    {
        int currentPixelValue = [[_neuronState objectAtIndex:pixelCounter]intValue];
        int inputPixelValue = [[inputVector objectAtIndex:pixelCounter]intValue];
        
        if (currentPixelValue == inputPixelValue)
        {
            weight = 1;
        }
        else
        {
            weight += abs(currentPixelValue - inputPixelValue);
        }
    }
    
    return weight;
}

//Получить вес для входного вектора
-(double)getWeightForInputCharVector:(unsigned char *)inputVector
{
    double weight = 0;
    int pixelCounter = 0;
    
    for (pixelCounter = 0; pixelCounter < VECTORLENGTH; ++pixelCounter)
    {
        int currentPixelValue = _charNeuronState[pixelCounter];
        int inputPixelValue = inputVector[pixelCounter];
        
        if (currentPixelValue == inputPixelValue)
        {
            //weight = 1;
        }
        else
        {
            weight += abs(currentPixelValue - inputPixelValue);
        }
    }
    
    return weight;
}

//Обновление массива связных областей
-(void)refreshRegions
{
    [_regions removeAllObjects];
    _regions = [NSMutableArray arrayWithArray:[ImageProcessing getRegionsForVector:_charNeuronState]];
}


@end
