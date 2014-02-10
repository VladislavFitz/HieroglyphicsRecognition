//
//  RecognizeStructure.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 16.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "RecognizeStructure.h"
@implementation RecognizeStructure
@synthesize recognizeStructureCollection = _recognizeStructureCollection;

-(id)init
{
    if (self = [super init])
    {
        _recognizeStructureCollection = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)addNeuronLayer:(NeuronGroup *)neuronLayer
{
    [_recognizeStructureCollection setObject:neuronLayer forKey:[neuronLayer neuronGroupID]];
}

-(id)objectForKey:(id)key
{
    return [_recognizeStructureCollection objectForKey:key];
}

@end
