//
//  FullPlayerViewController.h
//  CarEyeClient
//
//  Created by asd on 2019/11/7.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "BaseViewController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "TerminalFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullPlayerViewController : BaseViewController

@property (nonatomic, strong) TerminalFile *file;
@property (nonatomic, copy) NSString *terminal;

@property (atomic, retain) id<IJKMediaPlayback> player;

@end

NS_ASSUME_NONNULL_END
