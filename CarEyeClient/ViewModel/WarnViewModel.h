//
//  WarnViewModel.h
//  CarEyeClient
//
//  Created by asd on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"
#import "SearchParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface WarnViewModel : BaseViewModel

@property (nonatomic, strong) SearchParam *param;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) int totalPage;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) RACSubject *msgSubject;
@property (nonatomic, strong) RACCommand *dataCommand;

@end

NS_ASSUME_NONNULL_END
