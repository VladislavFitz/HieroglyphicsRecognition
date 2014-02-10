//
//  NSArray+pixelsData.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 10.11.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import "NSArray+pixelsData.h"

@implementation NSArray (pixelsData)
+(NSArray *)withChar:(unsigned char*)vector
{
    NSMutableArray * pixelsValues = [[NSMutableArray alloc]init];
    
    for ( int i=0; i< VECTORLENGTH; ++i )
    {
        [pixelsValues addObject:[NSNumber numberWithInt:vector[i] ]];
    }
    
    return pixelsValues;
}


@end
