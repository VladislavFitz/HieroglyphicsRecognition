//
//  Neuron.h
//  Travail licenciere
//  Класс нейрона для сети
//  Created by Владислав Фиц on 06.11.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Neuron : NSObject
@property (nonatomic, copy) NSMutableArray *neuronState;
@property unsigned char * charNeuronState;
@property float trainCoefficient;
@property NSString * neuronID;
@property NSMutableArray * regions;

//Инициализация при помощи вектора в виде массива объектов и заданного ID
- (id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID;

//Инициализация при помощи вектора в виде массива символов и заданного ID
- (id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID;

//Обучить нейрон при помощи вектора в виде массива объектов
-(NSArray *)trainNeuronWithInputVector:(NSArray *)inputVector;

//Обучить нейрон при помощи вектора в виде массива объектов с заданными коэффициентом обучения
-(NSArray *)trainNeuronWithInputVector:(NSArray *)inputVector andTrainCoefficient:(double)coefficient;

//Обучить нейрон при помощи вектора в виде массива символов
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector;

//Обучить нейрон при помощи вектора в виде массива символов с заданным коэффициентом обучения
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector andTrainCoefficient:(double)coefficient;

//Обучить нейрон при помощи вектора в виде массива символов с заданной градиентной матрицей обучения
-(unsigned char *)trainNeuronWithInputCharVector:(unsigned char *)inputVector trainMatrixForPattern:(KeyPosition)pattern trainCoefficient:(double)coefficient;


//Получить оценку нейрона для вектора в виде массива объектов
-(double)getWeightForInputVector:(NSArray *)inputVector;

//Получить оценку нейрона для вектора в виде массива символов
-(double)getWeightForInputCharVector:(unsigned char *)inputVector;

//Обновить массив областей нейрона
-(void)refreshRegions;

@end
