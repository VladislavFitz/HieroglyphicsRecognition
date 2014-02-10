//
//  ImageProcessing.m
//  Travail licenciere
//
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import "ImageProcessing.h"
#import "HyerogliphPatternHelper.h"
#import "Region.h"
#import "UIImage+UIImage_Pixels.h"
#import "NSArray+pixelsData.h"

@implementation ImageProcessing

+(NSArray *)applyGradientMatrix:(NSArray *)matrix onVector:(unsigned char *)vector
{
    NSMutableArray * outputVector = [NSMutableArray new];
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        [outputVector addObject:[NSNumber numberWithDouble:[[matrix objectAtIndex:i] doubleValue] * vector[i]]];
    }
    
    return [NSArray arrayWithArray:outputVector];
}


+ (void)printTextInterpretationOfImage:(unsigned char*)pixelData
{
    NSLog(@"\n");
    NSLog(@"==========================================================================================");
    NSLog(@"\n");
    int perRow = sqrt((double)VECTORLENGTH);
    int rowCount=0;
    printf("%i\t", 1);
    for (int i=0; i<VECTORLENGTH; ++i)
    {
        if(pixelData[i]<100)
        {
            printf("%i", 1);
            ++rowCount;
        }
        else
        {
            printf(" ");
            ++rowCount;
        }
        if (rowCount == perRow /*&& i/perRow+2<=perRow*/)
        {
            rowCount=0;
            printf("\n");
            if (i/perRow+1!=perRow)
            {
                printf("%i\t", i/100+2);
            }
            
        }
    }
    
}

+ (void)printTextInterpretationOfImageFromArray:(NSArray *)pixelData
{
    NSLog(@"\n");
    NSLog(@"==========================================================================================");
    NSLog(@"\n");
    int perRow = sqrt((double)VECTORLENGTH);
    int rowCount = 0;
    printf("%i\t", 1);
    for (int i=0; i<VECTORLENGTH; ++i)
    {
        if([[pixelData objectAtIndex:i]intValue] <100)
        {
            printf("%.1f ", [[pixelData objectAtIndex:i]doubleValue]);
            ++rowCount;
        }
        else
        {
            printf("%.1f ", [[pixelData objectAtIndex:i]doubleValue]);
            ++rowCount;
        }
        if (rowCount == perRow)
        {
            rowCount=0;
            printf("\n");
            if (i/perRow+1!=perRow)
            {
                printf("%i\t", i/100+2);
            }
            
        }
    }
}

+(void)printRegionsFromArray:(NSArray *)regions
{
    NSLog(@"\n");
    
    int perRow = 100;
    int rowCount = 0;
    
    printf("%i\t", 1);
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        printf("%i", [[regions objectAtIndex:i]intValue]);
        ++rowCount;
        
        if (rowCount == perRow)
        {
            rowCount=0;
            
            printf("\n");
            
            if (i/perRow+1 != perRow)
            {
                printf("%i\t", i/100+2);
            }
            
        }
    }

}

+(void)printRegionsFromIntArray:(NSInteger[])regions
{
    NSLog(@"\n");
    
    int perRow = 100;
    int rowCount = 0;
    
    printf("%i\t", 1);
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (regions[i] == 0) {
            printf(" ");
        }
        else
        {
            printf("%i", regions[i]);
        }
        ++rowCount;
        
        if (rowCount == perRow)
        {
            rowCount=0;
            
            printf("\n");
            
            if (i/perRow+1 != perRow)
            {
                printf("%i\t", i/100+2);
            }
            
        }
    }
}

//Бинаризация изображения с заданным порогом бинаризации
+(NSArray *)binarizeVector:(unsigned char *)vector withThreshold:(int)treshold
{
    NSMutableArray * binarized = [NSMutableArray new];
    
    //Бинаризация изображения и запись его в массив Regions
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        //если пиксель чёрный, то помечаем его, как закрашенный
        if (vector[i] <= treshold)
        {
            [binarized addObject:[NSNumber numberWithInt:1]];
        }
        else
        {
            [binarized addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    return binarized;
}

//Удаление областей меньше заданной пороговой площади
+(NSMutableArray *)filteredRegions:(NSArray *)regions withSquareThreshold:(int)threshold
{
    NSMutableArray * sortedRegions = [NSMutableArray new];
    for (Region *reg in regions)
    {
        if (reg.square >= threshold)
        {
            [sortedRegions addObject:reg];
        }
    }
    
    return sortedRegions;
}

//Массив размеченных областей
+(NSMutableArray *)markedRegions:(unsigned char *)vector
{
    //Подсчёт количества связных областей
    //При помощи маски:
    //
    // С|D|E
    // B|A
    
    //Массив коллизий (пары связных областей с разными пометками)
    NSMutableArray * divergencies = [NSMutableArray new];
    
    //Массив с областями
    NSMutableArray * regions = [[NSMutableArray alloc]initWithCapacity:VECTORLENGTH];
    
    regions = [NSMutableArray arrayWithArray:[ImageProcessing binarizeVector:vector
                                                               withThreshold:200]];
    
    //Переменные маски
    NSInteger B = 0, C = 0, D = 0, E = 0;
    
    //Пометка области
    NSInteger mark = 1;
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if ([[regions objectAtIndex:i]intValue] == 1)
        {
            //Получение значений маски ABCDE
            if (i - 1 > 0)
            {
                B = [[regions objectAtIndex:i-1]integerValue];
            }
            
            if (i - PIXELS_IN_ROW - 1 > 0)
            {
                C = [[regions objectAtIndex:i - 100 - 1]integerValue];
            }
            
            if (i - PIXELS_IN_ROW > 0)
            {
                D = [[regions objectAtIndex:i - PIXELS_IN_ROW]integerValue];
            }
            
            if (i - PIXELS_IN_ROW + 1 > 0)
            {
                E = [[regions objectAtIndex:i - PIXELS_IN_ROW + 1]integerValue];
            }
            
            //Если пиксель закрашен, а значения маски пустые – записываем в пиксель новую пометку
            if (B == 0 && C == 0 && D == 0 && E == 0)
            {
                [regions setObject:[NSNumber numberWithInt:++mark] atIndexedSubscript:i];
            }
            //Иначе присваиваем пометку области, с которой связан пиксель
            else
            {
                if(B)
                    [regions setObject:[NSNumber numberWithInt:B] atIndexedSubscript:i];
                if(C)
                    [regions setObject:[NSNumber numberWithInt:C] atIndexedSubscript:i];
                if(D)
                    [regions setObject:[NSNumber numberWithInt:D] atIndexedSubscript:i];
                if(E)
                    [regions setObject:[NSNumber numberWithInt:E] atIndexedSubscript:i];
            }
            
            //Проверяем коллизии, при необходимости заносим их в структуру для хранения коллизий
            if ((B && C) && B!=C) {
                [divergencies addObject:[NSNumber numberWithInt:B]];
                [divergencies addObject:[NSNumber numberWithInt:C]];
            }
            
            if ((B && D)  && B!=D) {
                [divergencies addObject:[NSNumber numberWithInt:B]];
                [divergencies addObject:[NSNumber numberWithInt:D]];
            }
            
            if ((B && E)  && B!=E) {
                [divergencies addObject:[NSNumber numberWithInt:B]];
                [divergencies addObject:[NSNumber numberWithInt:E]];
            }
            
            if ((C && D)  && C!=D) {
                [divergencies addObject:[NSNumber numberWithInt:C]];
                [divergencies addObject:[NSNumber numberWithInt:D]];
            }
            
            if ((C && E)  && C!=E) {
                [divergencies addObject:[NSNumber numberWithInt:C]];
                [divergencies addObject:[NSNumber numberWithInt:E]];
            }
            
            if ((D && E)  && D!=E) {
                [divergencies addObject:[NSNumber numberWithInt:D]];
                [divergencies addObject:[NSNumber numberWithInt:E]];
            }
            
            //Очистка значений маски
            B = C = D = E = 0;
        }
        else
        {
            continue;
        }
        
    }
    
    //Делаем из массива объектов коллизий массив Integer
    NSInteger divergenciesArray[[divergencies count]];
    
    for (int i = 0; i<[divergencies count]; ++i)
    {
        divergenciesArray[i] = [[divergencies objectAtIndex:i]integerValue];
    }
    
    //Делаем из массива пикселей массив Integer
    NSInteger regionsArray[[regions count]];
    
    for (int i = 0; i < [regions count]; ++i)
    {
        regionsArray[i] = [[regions objectAtIndex:i]integerValue];
    }
    
    
    //Разрешение коллизий
    for (int i = 0; i < [divergencies count]; i+=2)
    {
        int a = divergenciesArray[i];
        int b = divergenciesArray[i+1];
        if (a == b)
            continue;
        
        int resMark = (a > b)?b:a;
        int redundantMark = (a > b)?a:b;
        
        for (int i=0; i<[divergencies count]; ++i)
        {
            if (divergenciesArray[i] == redundantMark)
            {
                divergenciesArray[i] = resMark;
            }
        }
        
        for (int i=0; i<[regions count]; ++i)
        {
            if (regionsArray[i] == redundantMark)
            {
                regionsArray[i] = resMark;
            }
        }
    }
    
    [regions removeAllObjects];
    for (int i=0; i<VECTORLENGTH; ++i) {
        [regions addObject:[NSNumber numberWithInt:regionsArray[i]]];
    }
    
    return regions;
}

//Множество меток областей для массива размеченных областей
+(NSSet *)regionMarksForMarkedRegions:(NSMutableArray *)regions
{
    //Подсчёт числа связных областей
    NSMutableSet * differentRegions = [NSMutableSet new];
    
    //Делаем из массива пикселей массив Integer
    NSInteger regionsArray[[regions count]];
    
    for (int i = 0; i < [regions count]; ++i)
    {
        regionsArray[i] = [[regions objectAtIndex:i]integerValue];
    }
    
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (regionsArray[i] != 0 && ![differentRegions containsObject:[NSNumber numberWithInt:regionsArray[i]]])
        {
            [differentRegions addObject:[NSNumber numberWithInt:regionsArray[i]]];
        }
    }
    
    return differentRegions;
}

//Массив размеченных границ для массива размеченных областей
+(NSMutableArray *)markedFrontiersForMarkedRegions:(NSArray *)inputRegions
{
    
    //Делаем из массива пикселей массив Integer
    NSInteger regionsArray[[inputRegions count]];
    
    for (int i = 0; i < [inputRegions count]; ++i)
    {
        regionsArray[i] = [[inputRegions objectAtIndex:i]integerValue];
    }
    
    NSInteger frontiers[VECTORLENGTH];
    
    for (int i=0; i<VECTORLENGTH; ++i)
    {
        frontiers[i] = regionsArray[i];
    }
    
    //Выделение контуров
    for (int i = 0; i < VECTORLENGTH; ++i)
    {
        if (regionsArray[i] != 0
            && regionsArray[i+1] != 0
            && regionsArray[i-1] != 0
            && regionsArray[i-PIXELS_IN_ROW] != 0
            && regionsArray[i+PIXELS_IN_ROW] != 0
            )
        {
            frontiers[i] = 0;
        }
    }
    
    NSMutableArray * markedFrontiers = [NSMutableArray new];
    for(int i=0; i<VECTORLENGTH; ++i)
    {
        [markedFrontiers addObject:[NSNumber numberWithInt:frontiers[i]]];
    }

    return markedFrontiers;
}


+(int)countOfCoherentRegionsForVector:(unsigned char *)vector
{
    NSMutableArray * regions = [self markedRegions:vector];
    
    //Делаем из массива пикселей массив Integer
    NSInteger regionsArray[[regions count]];
    
    for (int i = 0; i < [regions count]; ++i)
    {
        regionsArray[i] = [[regions objectAtIndex:i]integerValue];
    }
        
    //Для проверки выводим результат разбиения в консоль
    //[ImageProcessing printRegionsFromIntArray:regionsArray];
    
    //[ImageProcessing printRegionsFromIntArray:frontiers];
    
    return [[self regionMarksForMarkedRegions:[self markedRegions:vector]] count];
}

+(NSArray *)getRegionsForVector:(unsigned char*)inputVector
{
    NSMutableArray * regions = [NSMutableArray new];
    NSMutableArray * markedRegions =  [ImageProcessing markedRegions:inputVector];
    NSMutableArray * markedFrontiers = [ImageProcessing markedFrontiersForMarkedRegions:markedRegions];
    NSSet * marks = [ImageProcessing regionMarksForMarkedRegions:markedRegions];

    for (NSNumber * mark in marks)
    {
        Region * reg = [Region new];
        unsigned char * pixels = [[UIImage imageNamed:@"black.png"] grayscalePixels];
        unsigned char * frontiers = [[UIImage imageNamed:@"black.png"] grayscalePixels];
    
        for (int i = 0; i<VECTORLENGTH; ++i)
        {
            if ([[markedRegions objectAtIndex:i]intValue] != [mark intValue])
            {
                pixels[i] = 255;
            }
            if ([[markedFrontiers objectAtIndex:i]intValue] != [mark intValue])
            {
                frontiers[i] = 255;
            }
        }
    
        [reg setRegionFrontier:frontiers];
        [reg setRegionPixels:pixels];
    
        [regions addObject:reg];
    }
    return regions;
}
@end
