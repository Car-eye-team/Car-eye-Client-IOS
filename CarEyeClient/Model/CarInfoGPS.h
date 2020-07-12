//
//  CarInfoGPS.h
//  CarEyeClient
//
//  Created by asd on 2019/11/4.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarInfoGPS : BaseModel

@property (nonatomic, copy) NSString *terminal;        // 设备号
@property (nonatomic, copy) NSString *carnumber;       // 产品号
@property (nonatomic, assign) int carstatus;           // 车辆状态
@property (nonatomic, copy) NSString *devicetype;      // 设备类型
@property (nonatomic, copy) NSString *typeName;        // 设备类型名称
@property (nonatomic, copy) NSString *disktype;        // 硬盘类型

@property (nonatomic, copy) NSString *audioCodec;      // 音频编码
@property (nonatomic, copy) NSString *leftRotation;    //

@property (nonatomic, copy) NSString *stopStatus;      // 刹车状态
@property (nonatomic, copy) NSString *foreward;        // 正转状态
@property (nonatomic, copy) NSString *overturn;        // 反转状态
@property (nonatomic, copy) NSString *antenna;         // gps 线状态
@property (nonatomic, copy) NSString *disk;            // 硬盘状态
@property (nonatomic, copy) NSString *network;         // 3g/4g模块状态
@property (nonatomic, copy) NSString *staticStatus;    // 静止状态
@property (nonatomic, copy) NSString *replenish;       // 补传状态
@property (nonatomic, copy) NSString *nightStatus;     // 夜间状态
@property (nonatomic, copy) NSString *overload;        // 超载状态
@property (nonatomic, copy) NSString *aacGps;          // 停车acc状态
@property (nonatomic, copy) NSString *areaAlarm;       // 出区域报警（终端产生
@property (nonatomic, copy) NSString *overRoute;       // 出线路报警（终端产生）
@property (nonatomic, copy) NSString *areaAlarmStatus; // 区域报警状态
@property (nonatomic, copy) NSString *flowAlarm;       // 流量使用报警
@property (nonatomic, copy) NSString *backupBattery;   // 主机掉电由后备电池供电
@property (nonatomic, copy) NSString *carDefences;     // 车辆设防
@property (nonatomic, copy) NSString *leaveArea;       // 出区域报警（终端产生）
@property (nonatomic, copy) NSString *vollower;        // 电池电压过低
@property (nonatomic, copy) NSString *motor;           // 发动机
@property (nonatomic, copy) NSString *loaded;          // 车载状态
@property (nonatomic, copy) NSString *working;         // 作业状态
@property (nonatomic, copy) NSString *operation;       // 运营状态
@property (nonatomic, copy) NSString *oilway;          // 油路正常
@property (nonatomic, copy) NSString *circuit;         // 电路正常
@property (nonatomic, copy) NSString *doorlock;        // 门解锁
@property (nonatomic, copy) NSString *overspeedAlarm;  // 区域超速报警(平台产生)
@property (nonatomic, copy) NSString *overtimeAlarm;   // 时间段超速报警(平台产生)
@property (nonatomic, copy) NSString *lowerspeedAlarm; // 时间段低速报警(平台产生)
@property (nonatomic, copy) NSString *tiredAlarm;      // 疲劳驾驶(平台产生)

@property (nonatomic, copy) NSString *channel1;        // 通道1视频丢失
@property (nonatomic, copy) NSString *channel2;        // 通道2视频丢失
@property (nonatomic, copy) NSString *channel3;        // 通道3视频丢失
@property (nonatomic, copy) NSString *channel4;        // 通道4视频丢失
@property (nonatomic, copy) NSString *channe5;         // 通道5视频丢失
@property (nonatomic, copy) NSString *channel6;        // 通道6视频丢失
@property (nonatomic, copy) NSString *channel7;        // 通道7视频丢失
@property (nonatomic, copy) NSString *channel8;        // 通道8视频丢失

@property (nonatomic, copy) NSString *urgentAlarm;     // 紧急报警
@property (nonatomic, copy) NSString *gnssFault;       // gnss模块故障
@property (nonatomic, copy) NSString *gnssDisconnected;// gnss;//    天线未接或者剪断
@property (nonatomic, copy) NSString *lcdFault;        // 终端lcd或者显示器故障)

@property (nonatomic, copy) NSString *channel1Fault;   // 摄像头通道1故障
@property (nonatomic, copy) NSString *channel2Fault;   // 摄像头通道2故障
@property (nonatomic, copy) NSString *channel3Fault;   // 摄像头通道3故障
@property (nonatomic, copy) NSString *channel4Fault;   // 摄像头通道4故障
@property (nonatomic, copy) NSString *channel5Fault;   // 摄像头通道5故障
@property (nonatomic, copy) NSString *channel6Fault;   // 摄像头通道6故障
@property (nonatomic, copy) NSString *channel7Fault;   // 摄像头通道7故障
@property (nonatomic, copy) NSString *channel8Fault;   // 摄像头通道8故障

@property (nonatomic, copy) NSString *deviate;         // 路线偏离报警
@property (nonatomic, copy) NSString *driveOvertime;   // 当天累计驾驶超时
@property (nonatomic, copy) NSString *stolen;          // 车辆被盗
@property (nonatomic, copy) NSString *ignition;        // 车辆非法点火
@property (nonatomic, copy) NSString *oilAbnormal;     // 车辆油量异常
@property (nonatomic, copy) NSString *bump;            // 碰撞侧翻报警
@property (nonatomic, copy) NSString *unusualDrive1;   // 异常行驶状态
@property (nonatomic, copy) NSString *unusualDrive2;   // 异常行驶状态
@property (nonatomic, copy) NSString *enterErea;       // 进区域
@property (nonatomic, copy) NSString *enterRoute;      // 进路线
@property (nonatomic, copy) NSString *ptz;             //

@property (nonatomic, copy) NSString *lng;             // 经度
@property (nonatomic, copy) NSString *lat;             // 纬度
//@property (nonatomic, copy) NSString *blng;            // 百度经度
//@property (nonatomic, copy) NSString *blat;            // 百度纬度
//@property (nonatomic, copy) NSString *glng;            // 高德经度
//@property (nonatomic, copy) NSString *glat;            // 高德纬度
@property (nonatomic, copy) NSString *gaddress;        // 高德地址
@property (nonatomic, copy) NSString *altitude;        // 高度
@property (nonatomic, copy) NSString *speed;           // 速度
@property (nonatomic, copy) NSString *direction;       // 方向
@property (nonatomic, copy) NSString *address;         // 地址
@property (nonatomic, copy) NSString *mileage;         // 里程
@property (nonatomic, copy) NSString *summileage;      // 总里程
@property (nonatomic, copy) NSString *gpstime;         // gps时间
@property (nonatomic, copy) NSString *gpsflag;         // gps是否有效
@property (nonatomic, copy) NSString *acc;             // acc状态
@property (nonatomic, copy) NSString *createtime;

- (NSString *) gpstimeDesc;
- (NSString *) parseDirection:(NSString *)direction;
- (double) bLatitude;
- (double) bLongitude;

@end

NS_ASSUME_NONNULL_END
