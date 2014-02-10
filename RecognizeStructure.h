//
//  RecognizeStructure.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 16.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuronGroup.h"

@interface RecognizeStructure : NSObject
@property (nonatomic, strong) NSMutableDictionary * recognizeStructureCollection;
-(void)addNeuronLayer:(NeuronGroup *)neuronLayer;
-(id)objectForKey:(id)key;
@end
