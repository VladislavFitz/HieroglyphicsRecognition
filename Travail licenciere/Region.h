//
//  Region.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 24.05.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

//Массив с пикселями области
@property unsigned char * regionPixels;

//Массив с пикселями контура области
@property unsigned char * regionFrontier;

//Площадь области
-(int)square;

//Периметр области
-(int)perimeter;

//Коэффициент формы области
-(double)formCoefficient;

@end
