//
//  NeuronGroup.m
//  Travail licenciere
//  
//  Created by Владислав Фиц on 11.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "NeuronGroup.h"
#import "Neuron.h"
#import "ImageProcessing.h"
#import "Region.h"

#define REGIONS_COUNT_MATCHING_MULTIPLY 1

@implementation NeuronGroup
@synthesize inputVector = _inputVector;
@synthesize neuronGroupID = _neuronGroupID;
@synthesize neurons = _neurons;
@synthesize neuronsReflectionResults = _neuronsReflectionResults;
@synthesize neuronsMatchingMetrics = _neuronsMatchingMetrics;
@synthesize winnerNeuron = _winnerNeuron;


-(id)init
{
    if (self = [super init])
    {
        _neuronGroupID = [NSString new];
        _neurons = [NSMutableArray new];
        _neuronsReflectionResults = [NSMutableDictionary new];
        _neuronsMatchingMetrics = [NSMutableDictionary new];
        _winnerNeuron = [Neuron new];
    }
    return self;
}

- (id) initWithNeurons:(NSArray *)neurons ID:(NSString *)groupID
{
    if (self = [super init])
    {
        _neuronGroupID = groupID;
        _neurons = [NSMutableArray arrayWithArray:neurons];
        _neuronsReflectionResults = [[NSMutableDictionary alloc] init];
        _neuronsMatchingMetrics = [NSMutableDictionary new];
        _winnerNeuron = [Neuron new];
    }
    return self;
}

- (id) initWithID:(NSString *)groupID
{
    if (self = [super init])
    {
        _neuronGroupID = groupID;
        _neurons = [NSMutableArray new];
        _neuronsReflectionResults = [[NSMutableDictionary alloc] init];
        _neuronsMatchingMetrics = [NSMutableDictionary new];
        _winnerNeuron = [Neuron new];
    }
    return self;
}

-(void)addNeurons:(NSArray *)neurons
{
    [_neurons addObjectsFromArray:neurons];
}

-(void)addNeuron:(Neuron *)neuron
{
    [_neurons addObject:neuron];
}

-(void)addneuronsFromGroup:(NeuronGroup *)neuronLayer;
{
    [_neurons addObjectsFromArray:[neuronLayer neurons]];
}

//Обработка входного вектора слоем нейронов и возврат результата в виде пар ID нейрона – вес
-(NSDictionary *)getResultOfGroupReflectionOnVector:(unsigned char *)inputVector
{
    //[ImageProcessing countOfCoherentRegionsForVector:inputVector];
    
    id neuron = [[[_neurons lastObject]class]new];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Получаем результаты прохождения вектора через слой нейронов
    for (neuron in _neurons)
    {
        //Коэффициент умножения весов
        double multiCoefficient = 1;
        //Расположение ключа в данном нейроне
        KeyPosition keyPosition;
        
        if ([neuron isKindOfClass:[KeyNeuron class]])
        {
            keyPosition = [(KeyNeuron *)neuron keyPosition];
        }
        if ([neuron isKindOfClass:[HyerogliphNeuron class]])
        {
            keyPosition = [(HyerogliphNeuron *)neuron mainKeyPosition];
        }
        
        //Получаем вес при обработке вектора на данном нейроне
        double weight = [neuron getWeightForInputCharVector:[HyerogliphPatternHelper clipVector:inputVector
                                                                                    withPattern:keyPosition]];
        


        //Метрики областей учитываются только при распознавания ключа (пока)
        if([delegate regionsMetrics] && [neuron isKindOfClass:[KeyNeuron class]])
        {            
            //Массив связных областей для входного иероглифа,
            //сегментированного согласно положению ключа в текущем нейроне
            NSMutableArray * inputRegions = [NSMutableArray arrayWithArray:[ImageProcessing getRegionsForVector:[HyerogliphPatternHelper clipVector:inputVector
                                        withPattern:keyPosition]]];
            
            //Отфильтрованный массив связных областей для входного иероглифа
            inputRegions = [ImageProcessing filteredRegions:inputRegions
                                        withSquareThreshold:[delegate regionSquareThresholdValue]];
            
            //Количество связных областей в сравниваемых изображениях
            int inputCoherentRegionsCount = [inputRegions count];
            int neuronCoherentRegionsCount = [[neuron regions] count];
            
            //относительная погрешность коэффициента формы обрабатываемого изображения
            float formRelativeMistake = 0;
            
            //Если количество связных областей на входном изображении и в ключе
            //сопадают, то задаём коэффициент, на который делится отклонение при шаблонном распознавании
            if (inputCoherentRegionsCount == neuronCoherentRegionsCount)
            {
                multiCoefficient = 1 - [delegate formCoefficientAffection];
            }
            
            //Блок, сортирующий регионы по коэффициентам формы
            NSComparisonResult (^compareFormCoefficients)(Region* a, Region* b);
            compareFormCoefficients = ^(Region* a, Region* b){
                double first = [(Region*)a formCoefficient];
                double second = [(Region*)b formCoefficient];
                return (second>first?NSOrderedAscending:NSOrderedDescending);
            };
            
            //Сортировка регионов по метрике формы
            [[neuron regions]sortUsingComparator:compareFormCoefficients];
            [inputRegions sortUsingComparator:compareFormCoefficients];
            
            //Формируем массивы для составления пар областей
            //Массив, для которого подбираем пары – тот, в котором меньше областей
            NSArray * arr1 = neuronCoherentRegionsCount < inputCoherentRegionsCount ? [neuron regions]:inputRegions;
            NSArray * arr2 = neuronCoherentRegionsCount < inputCoherentRegionsCount ? inputRegions:[neuron regions];
            
            NSArray * matchingRegions = [self getPairsForArray:arr1
                                                     fromArray:arr2];
            
            //TODO:возможно исключить сравнение метрик формы при условии, что число распознанных областей не совпадает?
            //С алгоритмом подбора пар это может не иметь смысла. Попробуем.
            
            //Определяем, в каком изображении областей меньше, чтобы можно было сравнивать области в цикле
            int regionsToCompare = neuronCoherentRegionsCount < inputCoherentRegionsCount ? neuronCoherentRegionsCount:inputCoherentRegionsCount;
            
            for (int regIndex = 0; regIndex < regionsToCompare; ++regIndex)
            {
                float neuronRegionFormCoefficient = [[arr1 objectAtIndex:regIndex] formCoefficient];
                float inputRegionFormCoefficient = [[matchingRegions objectAtIndex:regIndex] formCoefficient];
                
                //Текущее отклонение коэффициентов формы
                double currentDivergence =  neuronRegionFormCoefficient - inputRegionFormCoefficient;
                
                //Получение абсолютного значения отклонения коэффициента формы
                if (currentDivergence < 0)
                    currentDivergence *= -1;
                
                //Относительная погрешность коэффициента формы
                float relDivergence = currentDivergence/neuronRegionFormCoefficient;
                
                //Суммарная погрешность коэффициента формы для всех областей
                formRelativeMistake += relDivergence;
            }
            //Среднее значение отклонения коэффициента формы для всех областей в распознаваемом изображении
            formRelativeMistake = formRelativeMistake / regionsToCompare;
            
            //умножение веса (отклонение) на величину погрешности – чем больше погрешность
            //тем больше останется величина отклонения
            //погрешность делится на коэффициент воздействия метрик связных областей
            //на результат распознавания
            //weight *= formRelativeMistake * (1 - [delegate formCoefficientAffection]);
            
            //деление веса на коэффициент умножения при совпадении числа связных областей
            //коэффициент <1, поэтому при совпадении отклонение будет уменьшаться
            weight *= multiCoefficient;
        }
        
        if ([_neuronsReflectionResults valueForKey:[neuron neuronID]])
        {
            //если уже имеется вес для данного нейрона – обновляем значение
            [_neuronsReflectionResults setValue:[NSNumber numberWithDouble:weight]
                                         forKey:[neuron neuronID]];
        }
        else
        {
            //если не найдено пары ID-вес для нейрона – создаём её
            [_neuronsReflectionResults setObject:[NSNumber numberWithDouble:weight]
                                          forKey:[neuron neuronID]];
        }
    }
    
    [self winnerNeuronSetting];
    [self countMatching];
    
    return _neuronsReflectionResults;
}

-(NSArray *)getPairsForArray:(NSArray *)arr1 fromArray:(NSArray *)arr2
{
    //Перебирает области из массива областей arr1
    //и подбирает им соответствующие пары элементы из массива arr2
    //на основе значения метрики формы (минимальное отклонение)
    
    NSMutableArray * arrayOfPairs = [NSMutableArray new];
    
    for (Region * regA in arr1)
    {
        int minDivIndex = 0;
        int minDiv = INT32_MAX;
        
        for (Region * reg in arr2)
        {
            int div = abs(regA.formCoefficient - reg.formCoefficient);
            if (div < minDiv)
            {
                minDiv = div;
                minDivIndex = [arr2 indexOfObject:reg];
            }
        }
        
        [arrayOfPairs addObject:[arr2 objectAtIndex:minDivIndex]];
    }
    
    return arrayOfPairs;
}

//Запись информации о нейроне победителе
-(void)winnerNeuronSetting
{
    //Записываем информацию о нейроне-победителе
    _winnerNeuron = [[_neurons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"neuronID = %@",
                                                            [[_neuronsReflectionResults allKeysForObject:[[_neuronsReflectionResults allValues] valueForKeyPath:@"@min.doubleValue"]]lastObject]]] lastObject];
}

//Расчёт процентов совпадения с оригиналом
-(void)countMatching
{
    int maxDivergence = [[[_neuronsReflectionResults allValues] valueForKeyPath:@"@max.doubleValue"]intValue];
    int minDivergence = [[[_neuronsReflectionResults allValues] valueForKeyPath:@"@min.doubleValue"]intValue];
    
    int divergenceDifference = maxDivergence - minDivergence;
    
    //Заполняем структуру со степенями соответствия нейронов входному вектору
    for (NSString * neuronID in [_neuronsReflectionResults allKeys])
    {
        double matching = (maxDivergence - [[_neuronsReflectionResults valueForKey:neuronID] doubleValue])/divergenceDifference;
        [_neuronsMatchingMetrics setValue:[NSNumber numberWithDouble:matching]
                                   forKey:neuronID];
    }
}


-(void)pullNeuronsReflectionsResult
{
    int maxWeight = [[[_neuronsReflectionResults allValues] valueForKeyPath:@"@max.doubleValue"]intValue];
    
    [_neuronsReflectionResults setValue:[NSNumber numberWithInt:maxWeight]
                                 forKey:[_winnerNeuron neuronID]];
    
    [self winnerNeuronSetting];
    [self countMatching];
}

-(Neuron *)neuronWithID:(NSString *)neuronID
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"neuronID = %@", neuronID];
    return [[_neurons filteredArrayUsingPredicate:pred]lastObject];
}


@end
