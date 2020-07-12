//
//  VideoViewController.m
//  CarEyeClient
//
//  Created by asd on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "VideoViewController.h"
#import "SettingViewController.h"
#import "CarTreeViewController.h"
#import "VideoViewModel.h"
#import "CarLocalData.h"
#import "DepartmentCar.h"
#import "Masonry.h"
#import "PathUnit.h"

@interface VideoViewController ()

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) int space;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *recBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginBottom;

@property (nonatomic, strong) VideoViewModel *vm;

@end

@implementation VideoViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.players = [[NSMutableArray alloc] init];
    self.urls = [[NSMutableArray alloc] init];
    self.recordUrls = [[NSMutableArray alloc] init];
    self.isRecords = [[NSMutableArray alloc] init];
    self.space = 4;
    
    self.marginBottom.constant = LQTabBarHeight;
    [self.playBtn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateSelected];
    [self.audioBtn setImage:[UIImage imageNamed:@"ic_no_voice"] forState:UIControlStateNormal];
    [self.audioBtn setImage:[UIImage imageNamed:@"ic_voice"] forState:UIControlStateSelected];
    [self.videoBtn setImage:[UIImage imageNamed:@"ic_video_show"] forState:UIControlStateNormal];
    [self.videoBtn setImage:[UIImage imageNamed:@"ic_video_hide"] forState:UIControlStateSelected];
    [self.recBtn setImage:[UIImage imageNamed:@"ic_record"] forState:UIControlStateNormal];
    [self.recBtn setImage:[UIImage imageNamed:@"ic_recording"] forState:UIControlStateSelected];
    [self.fullBtn setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
    [self.fullBtn setImage:[UIImage imageNamed:@"ic_video_max"] forState:UIControlStateSelected];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"视频预览";

    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.parentViewController.navigationItem.leftBarButtonItem = settingBtn;
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.parentViewController.navigationItem.rightBarButtonItem = searchBtn;
    
    NSString *terminal = [[CarLocalData sharedInstance] gainTerminal];
    if (!self.vm.terminal || [self.vm.terminal isEqualToString:@""]
        || ![self.vm.terminal isEqualToString:terminal]) {
        self.vm.terminal = terminal;
        self.vm.totalChannels = [[CarLocalData sharedInstance] gainChannel];
        [self playUrl];
    } else {
        [self prepareToPlay];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (int i = 0; i < self.players.count; i++) {
        id<IJKMediaPlayback> p = self.players[i];
        
        IJKFFMoviePlayerController *player = p;
        [player setPlaybackVolume:0];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stop];
    [self stopUrl];
}

- (void) setting {
    SettingViewController *vc = [[SettingViewController alloc] initWithStoryborad];
    [self basePushViewController:vc];
}

- (void) search {
    CarTreeViewController *vc = [[CarTreeViewController alloc] initWithStoryborad];
    [vc.subject subscribeNext:^(DepartmentCar *car) {
        self.vm.terminal = car.terminal;
        self.vm.totalChannels = car.channeltotals;
        [self.players removeAllObjects];
        
        [self stop];
        [self stopUrl];
        
        if (car.carstatus == 1 || car.carstatus == 2) {
            [self showTextHubWithContent:@"当前车辆不在线"];
        } else {
            [self playUrl];
        }
    }];
    [self basePushViewController:vc];
}

- (void) playUrl {
    [self.contentView removeAllSubviews];
    
//    [self showHub];
    self.vm.type = @"0";
    for (int i = 0; i < self.vm.totalChannels; i++) {
        [self.vm.dataCommands[i] execute:nil];
    }
}

- (void) stopUrl {
    self.vm.type = @"1";
    for (int i = 0; i < self.vm.totalChannels; i++) {
        [self.vm.dataCommands[i] execute:nil];
    }
}

- (void) prepareToPlay {
//    [self.player1 prepareToPlay];
//    [self.player2 prepareToPlay];
//    [self.player3 prepareToPlay];
//    [self.player4 prepareToPlay];
    
    for (id<IJKMediaPlayback> p in self.players) {
        [p play];
    }
}

- (void) stop {
//    [self.player1 pause];
//    [self.player2 pause];
//    [self.player3 pause];
//    [self.player4 pause];
    
    for (int i = 0; i < self.players.count; i++) {
        id<IJKMediaPlayback> p = self.players[i];
//        [p shutdown];
//        [p stop];
        [p pause];
        
        IJKFFMoviePlayerController *player = p;
        @try {
            [player recordFilePath:NULL second:0];
            
//            // 保存视频到相册
//            if (i < self.recordUrls.count) {
//                NSString *file = self.recordUrls[i];
//                [self save:file];
//            }
        } @catch (NSException *e) {
            NSLog(@"%@", e);
        } @finally {
            
        }
    }
    
    [self.isRecords removeAllObjects];
    [self.urls removeAllObjects];
    [self.recordUrls removeAllObjects];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    [self.vm.dataSubject1 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:0];
            }
        }
    }];
    
    [self.vm.dataSubject2 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:1];
            }
        }
    }];
    
    [self.vm.dataSubject3 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:2];
            }
        }
    }];
    
    [self.vm.dataSubject4 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:3];
            }
        }
    }];
    
    [self.vm.dataSubject5 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:4];
            }
        }
    }];
    
    [self.vm.dataSubject6 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:5];
            }
        }
    }];
    
    [self.vm.dataSubject7 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:6];
            }
        }
    }];
    
    [self.vm.dataSubject8 subscribeNext:^(NSString *url) {
        if ([self.vm.type isEqualToString:@"0"]) {
            if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"rtmp"]) {
                [self.urls addObject:url];
                [self.recordUrls addObject:@""];
                [self.isRecords addObject:@(NO)];
                [self initPlayer:url current:7];
            }
        }
    }];
}

- (void) updatePlayer:(id<IJKMediaPlayback>)player {
    for (id<IJKMediaPlayback> p in self.players) {
        [p.view setHidden:YES];
    }
    
    if (self.currentPlayer == player) {
        if (self.currentPlayer.view.size.width == (self.contentView.size.width - 8)) {
            [self updateConstraints];
            
            for (id<IJKMediaPlayback> p in self.players) {
                [p.view setHidden:NO];
            }
        } else {
            [self.currentPlayer.view updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self.space);
                make.width.equalTo((self.contentView.size.width - 8));
                make.height.equalTo((self.contentView.size.height - 8));
            }];
        }
        
        [self.currentPlayer.view setHidden:NO];
        return;
    }
    
    LQViewBorderRadius(self.currentPlayer.view, 0, 0, [UIColor redColor]);
    [self.currentPlayer.view updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo((self.contentView.size.width - 12) / 2);
        make.height.equalTo((self.contentView.size.height - 12) / 2);
    }];
    
    self.currentPlayer = player;
    
    [self.currentPlayer.view setHidden:NO];
    LQViewBorderRadius(self.currentPlayer.view, 0, 2, [UIColor redColor]);
    [self.currentPlayer.view updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.space);
        make.width.equalTo((self.contentView.size.width - 8));
        make.height.equalTo((self.contentView.size.height - 8));
    }];
}

- (void) initPlayer:(NSString *)urlStr current:(int)current {
    id<IJKMediaPlayback> player = [self player:urlStr];
    [self.players addObject:player];
    player.view.backgroundColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:player.view];
    [player.view makeConstraints:^(MASConstraintMaker *make) {
        int rowCount = (self.vm.totalChannels / 2) + (self.vm.totalChannels % 2);
        float height = (float) (self.contentView.size.height - self.space * (rowCount + 1)) / (float) rowCount;
        make.height.equalTo(height);
        CGFloat width = (self.contentView.size.width - 12) / 2;
        make.width.equalTo(width);
        
        if (current % 2 == 0) {
            make.left.equalTo(self.space);
        } else {
            make.left.equalTo(self.space * 2 + width);
        }
        
        int row = current / 2;
        int top = (height + self.space) * row;
        make.top.equalTo(top);
    }];
    
    if (current == 0) {
        self.current = 0;
        self.currentPlayer = player;
        LQViewBorderRadius(player.view, 0, 2, [UIColor redColor]);
        [self.playBtn setSelected:YES];
        [self.audioBtn setSelected:NO];
        [self.videoBtn setSelected:NO];
    }
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        self.current = current;
        [self updatePlayer:player];
        [self updateBtn];
    }];
    [player.view addGestureRecognizer:tgr];
    
    [player setPlaybackVolume:0];
    [player prepareToPlay];
}

- (void) updateBtn {
    [self.playBtn setSelected:self.currentPlayer.isPlaying];
    
    if ([self.currentPlayer playbackVolume] > 0) {
        [self.audioBtn setSelected:YES];
    } else {
        [self.audioBtn setSelected:NO];
    }
    
    [self.videoBtn setSelected:[self.currentPlayer.view isHidden]];
    
    if (self.isRecords && self.isRecords.count > self.current) {
        [self.recBtn setSelected:[self.isRecords[self.current] boolValue]];
    }
}

- (id<IJKMediaPlayback>) player:(NSString *)urlStr {
    IJKFFOptions *options = [self optionsWithurl:urlStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    id<IJKMediaPlayback> player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options key:@"CarEyeClient"];
    
    if (player) {
        player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        player.scalingMode = IJKMPMovieScalingModeAspectFit;
        player.shouldAutoplay = YES;
    }
    
    return player;
}

- (IJKFFOptions *)optionsWithurl:(NSString *)urlStr {
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setFormatOptionIntValue:1000000 forKey:@"analyzeduration"]; // 21s
    [options setFormatOptionIntValue:2048 forKey:@"probesize"];// 2048或者204800
    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    [options setFormatOptionIntValue:10 forKey:@"timeout"];
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    // udp  tcp
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    
    // RTSP流对应的iformat的是rtsp,rtmp流对应的iformat的是flv,m3u8流对应的iformat的是hls
    if ([[urlStr substringToIndex:4] isEqualToString:@"rtmp"]) {
        [options setFormatOptionValue:@"flv" forKey:@"iformat"];
    } else if ([[urlStr substringToIndex:4] isEqualToString:@"m3u8"]) {
        [options setFormatOptionValue:@"hls" forKey:@"iformat"];
    } else {
        [options setFormatOptionValue:@"rtsp" forKey:@"iformat"];
    }
    
    return options;
}

- (VideoViewModel *) vm {
    if (!_vm) {
        _vm = [[VideoViewModel alloc] init];
    }
    
    return _vm;
}

#pragma mark - click

- (IBAction)play:(id)sender {
    if (self.currentPlayer.isPlaying) {
        [self.currentPlayer pause];
    } else {
        [self.currentPlayer prepareToPlay];
        [self.currentPlayer play];
    }
    
    [self.playBtn setSelected:!self.currentPlayer.isPlaying];
}

- (IBAction)audio:(id)sender {
    if ([self.currentPlayer playbackVolume] > 0) {
        [self.currentPlayer setPlaybackVolume:0];
        [self.audioBtn setSelected:NO];
    } else {
        [self.currentPlayer setPlaybackVolume:1];
        [self.audioBtn setSelected:YES];
    }
}

- (IBAction)video:(id)sender {
    if ([self.currentPlayer.view isHidden]) {
        [self.currentPlayer.view setHidden:NO];
    } else {
        [self.currentPlayer.view setHidden:YES];
    }
    
    [self.videoBtn setSelected:[self.currentPlayer.view isHidden]];
}

- (IBAction)rec:(id)sender {
    self.recBtn.selected = !self.recBtn.selected;
    [self.isRecords replaceObjectAtIndex:self.current withObject:@(self.recBtn.selected)];
    
    if ([self.currentPlayer isKindOfClass:[IJKFFMoviePlayerController class]]) {
        IJKFFMoviePlayerController *player = self.currentPlayer;
        
        @try {
            if (self.recBtn.selected) {
                NSString *str = [PathUnit recordWithURL:self.urls[self.current]];
                [self.recordUrls replaceObjectAtIndex:self.current withObject:str];
                [player recordFilePath:(char *) [str UTF8String] second:60 * 30];
            } else {
                [player recordFilePath:NULL second:0];
                
                // 保存视频到相册
                NSString *file = self.recordUrls[self.current];
                [self save:file];
            }
        } @catch (NSException *e) {
            NSLog(@"%@", e);
        } @finally {
            
        }
    }
}

- (IBAction)fullScreen:(id)sender {
    if (!self.fullBtn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, LQScreenHeight, LQScreenWidth);
            
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.statusBarHidden = YES;
            [self prefersStatusBarHidden];
            [self.tabBarController.tabBar setHidden:YES];
            [self.parentViewController.navigationController setNavigationBarHidden:YES];
            
            self.marginBottom.constant = 0;
            self.fullBtn.selected = YES;
            [self performSelector:@selector(updateConstraints) withObject:self afterDelay:0.4];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformIdentity;
            self.view.bounds = CGRectMake(0, 0, LQScreenWidth, LQScreenHeight);
            
//            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.statusBarHidden = NO;
            [self prefersStatusBarHidden];
            [self.tabBarController.tabBar setHidden:NO];
            [self.parentViewController.navigationController setNavigationBarHidden:NO];
            
            self.marginBottom.constant = LQTabBarHeight;
            self.fullBtn.selected = NO;
            [self performSelector:@selector(updateConstraints) withObject:self afterDelay:0.4];
        }];
    }
}

- (void) updateConstraints {
    for (int i = 0; i < self.players.count; i++) {
        id<IJKMediaPlayback> p = self.players[i];
        
        [p.view updateConstraints:^(MASConstraintMaker *make) {
            int rowCount = (self.vm.totalChannels / 2) + (self.vm.totalChannels % 2);
            float height = (float) (self.contentView.size.height - self.space * (rowCount + 1)) / (float) rowCount;
            make.height.equalTo(height);
            CGFloat width = (self.contentView.size.width - 12) / 2;
            make.width.equalTo(width);
            
            if (i % 2 == 0) {
                make.left.equalTo(self.space);
            } else {
                make.left.equalTo(self.space * 2 + width);
            }
            
            int row = i / 2;
            int top = (height + self.space) * row;
            make.top.equalTo(top);
        }];
    }
}

#pragma mark - StatusBar

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (void)save:(NSString *)url {
    NSString *path = [url stringByReplacingOccurrencesOfString:@".mp4" withString:@"-1.mp4"];
    
    [self showHubWithLoadText:@"保存中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            // 保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

#pragma mark -- 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf {
    [self hideHub];
    if (error) {
        [self showTextHubWithContent:@"保存视频失败"];
    } else {
        [self showTextHubWithContent:@"保存视频成功"];
    }
}

@end
