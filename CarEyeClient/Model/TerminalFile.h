//
//  TerminalFile.h
//  CarEyeClient
//
//  Created by liyy on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TerminalFile : BaseModel

/**
 * 从本位置开始为一个资源列表的开始
 */
@property (nonatomic, copy) NSString *logicChannel;
/**
 * 开始时间
 */
@property (nonatomic, copy) NSString *startTime;
/**
 * 结束时间
 */
@property (nonatomic, copy) NSString *endTime;
/**
 * 大小
 */
@property (nonatomic, assign) long size;
/**
 * 数据类型        0：音视频 1：音频 2：视频 3视频或音视频
 */
@property (nonatomic, assign) int mediaType;
/**
 * 码流类型        0：所有码流 1：主码流 2 子码流
 */
@property (nonatomic, assign) int streamType;
/**
 * 存储类型        0：所有存储器 1：主存储器 2：灾备服务器
 */
@property (nonatomic, assign) int memoryType;

- (NSString *) startTime2;
- (NSString *) endTime2;

@end

NS_ASSUME_NONNULL_END
