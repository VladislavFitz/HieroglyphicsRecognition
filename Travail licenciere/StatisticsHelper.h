//
//  StatisticsHelper.h
//  Travail licenciere
//  Модуль сбора статистики
//  Created by Владислав Фиц on 26.04.13.
//  Copyright (c) 2013 Владислав Фиц. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsHelper : NSObject


-(void)addSuccessAttemptCount;

-(void)addFailedAttemptCount;

-(void)resetCounter;

-(void)showStatisticsLog;

-(double)getAccuracy;

@property NSInteger successAttemptsNumber;
@property NSInteger failedAttemptsNumber;
@end
