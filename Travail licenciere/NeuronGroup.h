//
//  NeuronGroup.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 11.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neuron.h"
#import "HyerogliphNeuron.h"
#import "KeyNeuron.h"
#import "HyerogliphPatternHelper.h"

@interface NeuronGroup : NSObject

//Входной вектор в слой нейронов
@property unsigned char * inputVector;

//Идентификатор слоя нейронов
@property NSString * neuronGroupID;

//Массив нейронов
@property NSMutableArray * neurons;

//Результаты работы нейронов в виде пар: ID нейрона – вес
@property NSMutableDictionary * neuronsReflectionResults;

//Вероятности соответствия нейронов входному вектору в виде пар: ID нейрона – процент соответствия
@property NSMutableDictionary * neuronsMatchingMetrics;

//Нейрон-победитель: пара ID нейрона  – вес
@property Neuron * winnerNeuron;

//Инициализация массивом нейронов и ID группы
- (id) initWithNeurons:(NSArray *)neurons ID:(NSString *)groupID;
//Инициализация ID группы
- (id) initWithID:(NSString *)groupID;


//Обработка входного вектора слоем нейронов и возврат результата в виде пар ID нейрона – вес
-(NSDictionary *)getResultOfGroupReflectionOnVector:(unsigned char *)inputVector;

//Добавление нейронов в группу
-(void)addNeurons:(NSArray *)neurons;

//Добавление нейрона в группу
-(void)addNeuron:(Neuron *)neuron;

-(void)addneuronsFromGroup:(NeuronGroup *)neuronLayer;

-(Neuron *)neuronWithID:(NSString *)neuronID;


//При обучении с учителем был получены неверный результат – устанавливаем для бывшейго нейрона-победителя максимальное значение в наборе
//Пересчёт нейрона победителя и процентов совпадения
-(void)pullNeuronsReflectionsResult;


@end
