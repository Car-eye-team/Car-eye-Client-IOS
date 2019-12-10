//
//  SearchPlaybackViewController.h
//  CarEyeClient
//
//  Created by liyy on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPlaybackViewController : BaseViewController

@property (nonatomic, strong) RACSubject *subject;
@property (nonatomic, strong) SearchParam *param;

- (instancetype) initWithStoryborad;

@end

NS_ASSUME_NONNULL_END
