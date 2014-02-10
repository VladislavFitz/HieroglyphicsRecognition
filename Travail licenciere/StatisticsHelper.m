//
//  StatisticsHelper.m
//  Travail licenciere
//  Модуль сбора статистики
//  Created by Владислав Фиц on 26.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import "StatisticsHelper.h"

@implementation StatisticsHelper
@synthesize successAttemptsNumber = _successAttemptsNumber;
@synthesize failedAttemptsNumber =
    _failedAttemptsNumber;

-(id)init
{
    if (self = [super init])
    {
        _successAttemptsNumber = 0;
        _failedAttemptsNumber = 0;
    }
    return self;
}

-(void)addSuccessAttemptCount
{
    ++_successAttemptsNumber;
}

-(void)addFailedAttemptCount
{
    ++_failedAttemptsNumber;
}

-(double)getAccuracy
{
    if (_failedAttemptsNumber + _successAttemptsNumber != 0)
        return 100*_successAttemptsNumber/(_failedAttemptsNumber + _successAttemptsNumber);
    else
        return 0;
}

-(void)resetCounter
{
    _successAttemptsNumber = 0;
    _failedAttemptsNumber = 0;
}

-(void)showStatisticsLog
{
    NSLog(@"Количество попыток распознавания: %i", _successAttemptsNumber+_failedAttemptsNumber);
    NSLog(@"Удачных попыток: %i", _successAttemptsNumber);
    NSLog(@"Неудачных попыток: %i", _failedAttemptsNumber);
    NSLog(@"Точность распознавания составляет %2.f%%", [self getAccuracy]);
}
@end
