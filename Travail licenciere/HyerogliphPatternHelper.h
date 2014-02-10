//
//  hyerogliphPatternClip.h
//  Travail licenciere
//
//  Created by Владислав Фиц on 03.03.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HyerogliphPatternHelper : NSObject

+(unsigned char *)clipVector:(unsigned char *)inputVector withPattern:(KeyPosition)pattern;
+(unsigned char *)henPattern:(unsigned char *)inputVector;
+(unsigned char *)cukuriPattern:(unsigned char *)inputVector;
+(unsigned char *)kammuriPattern:(unsigned char *)inputVector;
+(unsigned char *)asiPattern:(unsigned char *)inputVector;
+(unsigned char *)tarePattern:(unsigned char *)inputVector;
+(unsigned char *)nePattern:(unsigned char *)inputVector;
+(unsigned char *)kamaePattern:(unsigned char *)inputVector;

+(NSArray *)getGradientMatrixForPattern:(KeyPosition)pattern withTrainCoefficient:(double)coefficient;
+(NSArray *)henGradientMatrix;
+(NSArray *)cukuriGradientMatrix;
+(NSArray *)kammuriGradientMatrix;
+(NSArray *)asiGradientMatrix;
+(NSArray *)tareGradientMatrix;
+(NSArray *)neGradientMatrix;
+(NSArray *)kamaeGradientMatrix;


+(NSString *)getStringNameOfPatternForPatternNumber:(KeyPosition)position;
+(KeyPosition)getNumberOfPatternForPatternName:(NSString *)patternName;

+(unsigned char *)getNewChar;
@end
