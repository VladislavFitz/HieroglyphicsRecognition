//
//  hyerogliphNeuron.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 12.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "Neuron.h"

@interface HyerogliphNeuron : Neuron
@property int mainKeyNumber;
@property KeyPosition mainKeyPosition;
@property int hyerogliphNumber;

-(id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber;
-(id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber;
-(id) initWithCharVector:(unsigned char *)inputVector mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber;

//Обучение нейрона с использованием градиентной матрицы и заданным коэффициентом обучения
-(unsigned char *)trainNeuronWithGradientMatrixWithInputCharVector:(unsigned char *)inputVector andTrainCoefficient:(double)coefficient;

@end
