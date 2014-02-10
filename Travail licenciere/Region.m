//
//  Region.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 24.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "Region.h"

@implementation Region
@synthesize regionPixels = _regionPixels;
@synthesize regionFrontier = _regionFrontier;

-(id)init
{
    if (self = [super init]) {

    }
    
    return self;
}

-(int)square
{
    int square = 0;
    for (int i = 0; i<VECTORLENGTH; ++i) {
        if (_regionPixels[i] == 0) {
            ++square;
        }
    }
    return square;
}

-(int)perimeter
{
    int perimeter = 0;
    for (int i = 0; i<VECTORLENGTH; ++i) {
        if (_regionFrontier[i] == 0) {
            ++perimeter;
        }
    }
    return perimeter;
}

-(double)formCoefficient
{
    return [self perimeter]^2 / [self square];
}

@end
