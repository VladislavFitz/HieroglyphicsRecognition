//  Нейрон, обрабатывающий целый иероглиф
//  hyerogliphNeuron.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 12.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "HyerogliphNeuron.h"
#import "HyerogliphPatternHelper.h"
#import "ViewController.h"


@implementation HyerogliphNeuron
@synthesize mainKeyNumber = _mainKeyNumber;
@synthesize mainKeyPosition = _mainKeyPosition;
@synthesize hyerogliphNumber = _hyerogliphNumber;


- (id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber
{
    if (self = [super initWithVector:inputVector ID:neuronID])
    {
        _mainKeyNumber = keyNumber;
        _mainKeyPosition = keyPosition;
        _hyerogliphNumber = hyerogliphNumber;
        self.trainCoefficient = DEFAULT_TRAIN_COEFFICIENT;
    }
    return self;
}

-(id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber
{
    if (self = [super initWithCharVector:inputVector ID:neuronID])
    {
        _mainKeyNumber = keyNumber;
        _mainKeyPosition = keyPosition;
        _hyerogliphNumber = hyerogliphNumber;
        self.trainCoefficient = DEFAULT_TRAIN_COEFFICIENT;
    }
    return self;
}

-(id) initWithCharVector:(unsigned char *)inputVector mainKeyNumber:(int)keyNumber mainKeyPosition:(KeyPosition)keyPosition hyerogliphNumber:(int)hyerogliphNumber
{
    if (self = [super initWithCharVector:inputVector ID:[NSString stringWithFormat:@"[%@]%i_%i", [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:keyPosition], keyNumber, hyerogliphNumber]])
    {
        _mainKeyNumber = keyNumber;
        _mainKeyPosition = keyPosition;
        _hyerogliphNumber = hyerogliphNumber;
        self.trainCoefficient = DEFAULT_TRAIN_COEFFICIENT;
    }
    return self;
}

-(unsigned char *)trainNeuronWithGradientMatrixWithInputCharVector:(unsigned char *)inputVector andTrainCoefficient:(double)coefficient
{
    [self trainNeuronWithInputCharVector:inputVector
                   trainMatrixForPattern:_mainKeyPosition
                        trainCoefficient:coefficient];
    //[super refreshRegions];
    return [self charNeuronState];
}

@end
