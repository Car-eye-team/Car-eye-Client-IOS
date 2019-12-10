//
//  FullPlayerViewModel.h
//  CarEyeClient
//
//  Created by liyy on 2019/11/7.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"
#import "TerminalFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullPlayerViewModel : BaseViewModel

@property (nonatomic, copy) NSString *playUrl;

@property (nonatomic, strong) TerminalFile *file;
@property (nonatomic, copy) NSString *terminal;

@property (nonatomic, strong) RACSubject *dataSubject;
@property (nonatomic, strong) RACCommand *dataCommand;

@end

NS_ASSUME_NONNULL_END
