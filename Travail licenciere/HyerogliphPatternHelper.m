//
//  hyerogliphPatternClip.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 03.03.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

//В классе методы, использующиеся для отсечения от векторов с иероглифами частей согласно шаблонам
//Отсечение реализуется обнулением пикселя

#import "HyerogliphPatternHelper.h"
#import "UIImage+UIImage_Pixels.h"
#import "ImageProcessing.h"

@implementation HyerogliphPatternHelper

#pragma mark - Модификация вектора, согласно шаблону

+(unsigned char *)clipVector:(unsigned char *)inputVector withPattern:(KeyPosition)pattern
{
    switch (pattern) {
        case kHEN:
            return [HyerogliphPatternHelper henPattern:inputVector];
            break;
        case kASI:
            return [HyerogliphPatternHelper asiPattern:inputVector];
            break;
        case kCUKURI:
            return [HyerogliphPatternHelper cukuriPattern:inputVector];
            break;
        case kKAMAE:
            return [HyerogliphPatternHelper kamaePattern:inputVector];
            break;
        case kKAMMURI:
            return [HyerogliphPatternHelper kammuriPattern:inputVector];
            break;
        case kNE:
            return [HyerogliphPatternHelper nePattern:inputVector];
            break;
        case kTARE:
            return [HyerogliphPatternHelper tarePattern:inputVector];
            break;
        default:
            return nil;
            break;
    }
}
+(unsigned char *)henPattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= FIRST_PIXEL_OF_SECOND_HALFROW )
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    return outputVector;
}

+(unsigned char *)cukuriPattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW <= FIRST_PIXEL_OF_SECOND_HALFROW )
        {
            outputVector[i] = WHITE_PIXEL;
        }
        
    }
    
    return (unsigned char *)outputVector;
}


+(unsigned char *)kammuriPattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if (i > FIRST_PIXEL_OF_SECOND_HORIZONTAL_HALF)
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    return (unsigned char *)outputVector;
}

+(unsigned char *)asiPattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if (i < FIRST_PIXEL_OF_SECOND_HORIZONTAL_HALF)
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    return (unsigned char *)outputVector;
}

+(unsigned char *)tarePattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if ((i > FIRST_PIXEL_OF_SECOND_HORIZONTAL_THIRD) &&
            (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= LAST_PIXEL_OF_FIRST_THIRDROW))
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    return (unsigned char *)outputVector;
}

+(unsigned char *)nePattern:(unsigned char *)inputVector
{
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if ((i <= FIRST_PIXEL_OF_THIRD_HORIZONTAL_THIRD) &&
            (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= LAST_PIXEL_OF_FIRST_THIRDROW))
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    return (unsigned char *)outputVector;
}

+(unsigned char *)kamaePattern:(unsigned char *)inputVector
{
    //[ImageProcessing printTextInterpretationOfImage:inputVector];
    unsigned char * outputVector = [HyerogliphPatternHelper getNewChar];
    [HyerogliphPatternHelper copyVector:inputVector toVector:outputVector withLength:VECTORLENGTH];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if ((i > FIRST_PIXEL_OF_SECOND_HORIZONTAL_THIRD) &&
            (i < FIRST_PIXEL_OF_THIRD_HORIZONTAL_THIRD) &&
            (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= FIRST_PIXEL_OF_SECOND_THIRDROW) &&
            (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW <= LAST_PIXEL_OF_SECOND_THIRDROW))
        {
            outputVector[i] = WHITE_PIXEL;
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImage:outputVector];
    return (unsigned char *)outputVector;
}



double _trainCoefficient;

#pragma mark - Получение градиентных матриц, согласно шаблону
+(NSArray *)getGradientMatrixForPattern:(KeyPosition)pattern withTrainCoefficient:(double)coefficient;
{
    _trainCoefficient = coefficient;
    switch (pattern) {
        case kHEN:
            return [HyerogliphPatternHelper henGradientMatrix];
            break;
        case kASI:
            return [HyerogliphPatternHelper asiGradientMatrix];
            break;
        case kCUKURI:
            return [HyerogliphPatternHelper cukuriGradientMatrix];
            break;
        case kKAMAE:
            return [HyerogliphPatternHelper kamaeGradientMatrix];
            break;
        case kKAMMURI:
            return [HyerogliphPatternHelper kammuriGradientMatrix];
            break;
        case kNE:
            return [HyerogliphPatternHelper neGradientMatrix];
            break;
        case kTARE:
            return [HyerogliphPatternHelper tareGradientMatrix];
            break;
        default:
            return nil;
            break;
    }
}

#define ZERO_COEFFICIENT 0

+(NSArray *)henGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= FIRST_PIXEL_OF_SECOND_HALFROW )
        {   //правая половина изображения
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else
        {
            //Сила пикселя в левой половине ряда (убывает при приближении к середине ряда)
            double pixCoeff = 1 - (getPixelNumberInRow(i)/PIXELS_IN_HALFROW);
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];

    return [NSArray arrayWithArray:outputMatrix];
}



+(NSArray *)cukuriGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];
    
    for (int i = FIRST_PIXEL_OF_ROW; i < VECTORLENGTH; ++i)
    {
        if (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW <= PIXELS_IN_HALFROW )
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else
        {
            //Сила пикселя в правой половине ряда (усиливается при удалении от середины ряда)
            double pixCoeff = 1 -  (PIXELS_IN_ROW - getPixelNumberInRow(i)) / PIXELS_IN_HALFROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];

    return [NSArray arrayWithArray:outputMatrix];
}



+(NSArray *)kammuriGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];

    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (i > FIRST_PIXEL_OF_SECOND_HORIZONTAL_HALF)
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else
        {
            //Сила пикселя в верхней половине изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getRowNumberOfPixel(i) / PIXELS_IN_HALFCOLUMN;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];
    
    return [NSArray arrayWithArray:outputMatrix];
}



+(NSArray *)asiGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];

    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (i < FIRST_PIXEL_OF_SECOND_HORIZONTAL_HALF)
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else
        {
            //Сила пикселя в нижней половине изображения (усиливается при удалении от центра)
            double pixCoeff = 1 - (PIXELS_IN_COLUMN - getRowNumberOfPixel(i)) / PIXELS_IN_HALFROW ;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];
    
    return [NSArray arrayWithArray:outputMatrix];
}


+(NSArray *)tareGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];

    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if ((i > FIRST_PIXEL_OF_SECOND_HORIZONTAL_THIRD) &&
            (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW >= LAST_PIXEL_OF_FIRST_THIRDROW))
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else if (i < FIRST_PIXEL_OF_SECOND_HORIZONTAL_THIRD)
        {
            //Сила пикселя в верхней трети изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getRowNumberOfPixel(i) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
        else if (i - getRowNumberOfPixel(i)*PIXELS_IN_ROW <= LAST_PIXEL_OF_FIRST_THIRDROW)
        {
            //Сила пикселя в левой трети изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getPixelNumberInRow(i) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    [ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];
    
    return [NSArray arrayWithArray:outputMatrix];
}



+(NSArray *)neGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];

    for (int i=0; i < VECTORLENGTH; ++i)
    {
        if (getRowNumberOfPixel(i) < FIRST_PIXEL_OF_THIRD_THIRDROW && getPixelNumberInRow(i) > PIXELS_IN_THIRDROW)
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else if(getRowNumberOfPixel(i) >= FIRST_PIXEL_OF_THIRD_THIRDROW)
        {
            //Сила пикселя в нижней трети изображения (усиливается при отдалении от центра)
            double pixCoeff = 1 - (LAST_PIXEL_OF_ROW - getRowNumberOfPixel(i)) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
        else if(getPixelNumberInRow(i) <= PIXELS_IN_THIRDROW)
        {
            //Сила пикселя в левой трети изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getPixelNumberInRow(i) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];
    
    return [NSArray arrayWithArray:outputMatrix];
}

+(NSArray *)kamaeGradientMatrix
{
    NSMutableArray * outputMatrix = [[NSMutableArray alloc]init];
    
    for (int i=0; i < VECTORLENGTH; ++i)
    {
        
        if (getPixelNumberInRow(i) > LAST_PIXEL_OF_FIRST_THIRDROW &&
            getPixelNumberInRow(i) < FIRST_PIXEL_OF_THIRD_THIRDROW &&
            getRowNumberOfPixel(i) > LAST_PIXEL_OF_FIRST_THIRDROW &&
            getRowNumberOfPixel(i) < FIRST_PIXEL_OF_THIRD_THIRDROW)
        {
            [outputMatrix addObject:[NSNumber numberWithDouble:ZERO_COEFFICIENT]];
        }
        else if(getRowNumberOfPixel(i) <= LAST_PIXEL_OF_FIRST_THIRDROW)
        {
            //Сила пикселя в верхней трети изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getRowNumberOfPixel(i) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
        else if(getRowNumberOfPixel(i) >= FIRST_PIXEL_OF_THIRD_THIRDROW)
        {
            //Сила пикселя в нижней трети изображения (усиливается при отдалении от центра)
            double pixCoeff = 1 - (LAST_PIXEL_OF_ROW - getRowNumberOfPixel(i)) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
        else if(getPixelNumberInRow(i) <= LAST_PIXEL_OF_FIRST_THIRDROW)
        {
            //Сила пикселя в левой трети изображения (ослабляется при приближении к центру)
            double pixCoeff = 1 - getPixelNumberInRow(i) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
        else if(getPixelNumberInRow(i) >= FIRST_PIXEL_OF_THIRD_THIRDROW)
        {
            //Сила пикселя в правой трети изображения (усиливается при удалении от центра)
            double pixCoeff = 1 - (LAST_PIXEL_OF_ROW - getPixelNumberInRow(i)) / PIXELS_IN_THIRDROW;
            [outputMatrix addObject:[NSNumber numberWithDouble:pixCoeff * _trainCoefficient]];
        }
    }
    
    //[ImageProcessing printTextInterpretationOfImageFromArray:outputMatrix];

    return [NSArray arrayWithArray:outputMatrix];
}


+(NSString *)getStringNameOfPatternForPatternNumber:(KeyPosition)position
{
    switch (position)
    {
        case kASI:
            return ASI;
            break;
        case kCUKURI:
            return CUKURI;
            break;
        case kHEN:
            return HEN;
            break;
        case kKAMMURI:
            return KAMMURI;
            break;
        case kKAMAE:
            return KAMAE;
            break;
        case kNE:
            return NE;
            break;
        case kTARE:
            return TARE;
            break;
        default:
            return @"Pattern not exists";
            break;
    }
}

+(KeyPosition)getNumberOfPatternForPatternName:(NSString *)patternName
{
    if ([patternName isEqualToString:ASI])
        return kASI;
    if ([patternName isEqualToString:CUKURI])
        return kCUKURI;
    if ([patternName isEqualToString:HEN])
        return kHEN;
    if ([patternName isEqualToString:KAMMURI])
        return kKAMMURI;
    if ([patternName isEqualToString:KAMAE])
        return kKAMAE;
    if ([patternName isEqualToString:NE])
        return kNE;
    if ([patternName isEqualToString:TARE])
        return kTARE;
    
    return @"FAIL";
}

//Вернуть указатель Unsigned char *
+(unsigned char *)getNewChar
{
    UIImage * image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"black"];
    return [image grayscalePixels];
}


+(void)copyVector:(unsigned char *)source toVector:(unsigned char *)destination withLength:(int)length
{
    for (int i=0; i<length; ++i)
    {
        destination[i] = source[i];
    }
}

//Номеря ряда пикселя
double getRowNumberOfPixel(int i)
{
    return (double)(i / PIXELS_IN_ROW);
}
//Позиция пикселя в ряду
double getPixelNumberInRow(int i)
{
    return i - getRowNumberOfPixel(i) * PIXELS_IN_ROW;
}




@end
