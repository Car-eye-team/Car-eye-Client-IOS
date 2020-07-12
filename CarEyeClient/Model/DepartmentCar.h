//
//  DepartmentCar.h
//  CarEyeClient
//
//  Created by asd on 2019/10/27.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepartmentCar : BaseModel

@property (nonatomic, copy) NSString *nodeId;       // 车辆id/机构id
@property (nonatomic, copy) NSString *parentId;     // 父id  0表示根节点
@property (nonatomic, copy) NSString *nodeName;     // 车牌号/机构名称
@property (nonatomic, copy) NSString *terminal;     // 终端号
@property (nonatomic, assign) int nodetype;         // 节点类型 1组织机构 2 车辆
@property (nonatomic, assign) int carstatus;        // 车辆状态 节点是车辆才有值  车辆状态 1：长时间离线 2：离线 3：熄火 4：停车 5：行驶 6：报警 7：在线 8：未定位
@property (nonatomic, assign) int total;            // 机构车辆总数  包括子机构数量
@property (nonatomic, assign) int caroffline;       // 车辆离线总数  包括子机构数量
@property (nonatomic, assign) int longoffline;      // 车辆长离总数  包括子机构数量
@property (nonatomic, assign) int channeltotals;    // 摄像头个数
@property (nonatomic, assign) BOOL parent;          // 是否是父节点  true代表有子节点，false代表无
@property (nonatomic, assign) BOOL isExpand;        // 是否展开了 true代表展开，false代表未展开
@property (nonatomic, assign) int DISPLAY_ORDER;    // 1       //同一个级别的显示顺序
@property (nonatomic, copy) NSString *imageResource;// 展示图标

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int depth;

+ (NSString *) imageResource:(int)carstatus;

@end

NS_ASSUME_NONNULL_END
