//
//  VideoViewController.h
//  CarEyeClient
//
//  Created by liyy on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "BaseViewController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : BaseViewController

@property (atomic, retain) id<IJKMediaPlayback> currentPlayer;
@property (atomic, retain) id<IJKMediaPlayback> player1;
@property (atomic, retain) id<IJKMediaPlayback> player2;
@property (atomic, retain) id<IJKMediaPlayback> player3;
@property (atomic, retain) id<IJKMediaPlayback> player4;

- (instancetype) initWithStoryborad;

@end

NS_ASSUME_NONNULL_END
