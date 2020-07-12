//
//  VideoViewController.h
//  CarEyeClient
//
//  Created by asd on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "BaseViewController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : BaseViewController

@property (atomic, retain) id<IJKMediaPlayback> currentPlayer;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray *recordUrls;
@property (nonatomic, strong) NSMutableArray *isRecords;
@property (nonatomic, assign) int current;

- (instancetype) initWithStoryborad;

@end

NS_ASSUME_NONNULL_END
