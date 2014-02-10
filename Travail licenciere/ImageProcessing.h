//
//  ImageProcessing.h
//  Travail licenciere
//  Методы, связанные с обработкой и выводом изображений
//  Created by Владислав Фиц on 11.10.12.
//  Copyright (c) 2012 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessing : NSObject

//Применение градиентной матрицы на векторе
+(NSArray *)applyGradientMatrix:(NSArray *)matrix onVector:(unsigned char *)vector;

//Вывод в консоль текстовой интерпретации изображения из различных источников
+(void)printTextInterpretationOfImage:(unsigned char*)pixelData;
+(void)printTextInterpretationOfImageFromArray:(NSArray *)pixelData;
+(void)printRegionsFromArray:(NSArray *)regions;
+(void)printRegionsFromIntArray:(NSInteger[])regions;


+(NSMutableArray *)markedRegions:(unsigned char *)vector;
+(NSMutableArray *)markedFrontiersForMarkedRegions:(NSArray *)inputRegions;
+(NSSet *)regionMarksForMarkedRegions:(NSMutableArray *)regions;


//Подсчёт количества связных областей
+(int)countOfCoherentRegionsForVector:(unsigned char *)vector;

//Получить массив связных областей для входного вектора
+(NSArray *)getRegionsForVector:(unsigned char*)inputVector;

//Удалить регионы, не удов. пороговому значению площади
+(NSMutableArray *)filteredRegions:(NSArray *)regions withSquareThreshold:(int)threshold;
@end
