//  Нейрон, обрабатывающий ключ
//  keyNeuron.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 12.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "Neuron.h"

@interface KeyNeuron : Neuron
@property int keyNumber;
@property KeyPosition keyPosition;

-(id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition;
-(id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition;
-(id) initWithCharVector:(unsigned char *)inputVector keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition;

//Обучить нейрон на векторе с использованием градиентной матрицы и заданным коэффициентом обучения
-(unsigned char *)trainKeyNeuronWithGradientMatrixWithInputCharVector:(unsigned char *)inputVector trainCoefficient:(double)coefficient;

//Обучить нейрона на сегментированном согласном паттерну ключа векторе
-(unsigned char *)trainKeyNeuronWithClippedInputCharVector:(unsigned char *)inputVector;


@end
