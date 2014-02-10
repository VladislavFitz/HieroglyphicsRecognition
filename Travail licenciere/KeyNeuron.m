//
//  keyNeuron.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 12.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "KeyNeuron.h"
#import "HyerogliphPatternHelper.h"
#import "ViewController.h"
#import "ImageProcessing.h"
#import "UIImage+UIImage_Pixels.h"

@implementation KeyNeuron
@synthesize keyNumber = _keyNumber;
@synthesize keyPosition = _keyPosition;



- (id) initWithVector:(NSArray *)inputVector ID:(NSString *)neuronID keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition
{
    if (self = [super initWithVector:inputVector ID:neuronID])
    {
        _keyNumber = keyNumber;
        _keyPosition = keyPosition;
    }
    return self;
}

-(id) initWithCharVector:(unsigned char *)inputVector ID:(NSString *)neuronID keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition
{
    if (self = [super initWithCharVector:inputVector ID:neuronID])
    {
        _keyNumber = keyNumber;
        _keyPosition = keyPosition;
    }
    return self;
}

-(id) initWithCharVector:(unsigned char *)inputVector keyNumber:(int)keyNumber keyPosition:(KeyPosition)keyPosition
{
    NSString * kID = [NSString stringWithFormat:@"[%@]%ik_0", [HyerogliphPatternHelper getStringNameOfPatternForPatternNumber:keyPosition], keyNumber];
    if (self = [super initWithCharVector:inputVector ID:kID])
    {
        _keyNumber = keyNumber;
        _keyPosition = keyPosition;
        self.trainCoefficient = DEFAULT_TRAIN_COEFFICIENT;
        NSMutableArray * regions = [NSMutableArray arrayWithArray:[ImageProcessing getRegionsForVector:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",kID] ]grayscalePixels]]];
        [super setRegions:regions];
    }
    return self;
}


-(unsigned char *)trainKeyNeuronWithClippedInputCharVector:(unsigned char *)inputVector
{
    [self trainNeuronWithInputCharVector:[HyerogliphPatternHelper clipVector:inputVector
                                                                 withPattern:_keyPosition]];
    //[super refreshRegions];
    return [self charNeuronState];
}
-(unsigned char *)trainKeyNeuronWithGradientMatrixWithInputCharVector:(unsigned char *)inputVector trainCoefficient:(double)coefficient
{
    [self trainNeuronWithInputCharVector:inputVector
                   trainMatrixForPattern:_keyPosition
                        trainCoefficient:coefficient];
    return [self charNeuronState];
}

@end
