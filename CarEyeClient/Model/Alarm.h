//
//  Alarm.h
//  CarEyeClient
//
//  Created by liyy on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Alarm : BaseModel

@property (nonatomic, copy) NSString *alarmId;
@property (nonatomic, copy) NSString *alarmDesc;
@property (nonatomic, copy) NSString *alarmDuration;
@property (nonatomic, copy) NSString *alarmInfo;
@property (nonatomic, copy) NSString *alarmLevel;
@property (nonatomic, copy) NSString *alarmNumber;
@property (nonatomic, copy) NSString *alarmSource;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *endExtraInfo;
@property (nonatomic, copy) NSString *endLat;
@property (nonatomic, copy) NSString *endLon;
@property (nonatomic, copy) NSString *endSpeed;
@property (nonatomic, copy) NSString *endLocation;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *endStatusList;
@property (nonatomic, copy) NSString *endAlarmList;
@property (nonatomic, copy) NSString *handleBy;
@property (nonatomic, copy) NSString *handleContent;
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *isDelete;
@property (nonatomic, copy) NSString *isHandle;
@property (nonatomic, copy) NSString *modifyDate;
@property (nonatomic, copy) NSString *startAlarmList;
@property (nonatomic, copy) NSString *startStatusList;
@property (nonatomic, copy) NSString *startExtraInfo;
@property (nonatomic, copy) NSString *startLat;
@property (nonatomic, copy) NSString *startLon;
@property (nonatomic, copy) NSString *startLocation;
@property (nonatomic, copy) NSString *startSpeed;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *startTimestamp;
@property (nonatomic, copy) NSString *terminalId;
@property (nonatomic, copy) NSString *stime;
@property (nonatomic, copy) NSString *etime;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *carNumber;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
