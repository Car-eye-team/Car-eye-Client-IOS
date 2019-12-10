//
//  VideoViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "VideoViewController.h"
#import "CarTreeViewController.h"
#import "VideoViewModel.h"
#import "CarLocalData.h"
#import "DepartmentCar.h"
#import "Masonry.h"

@interface VideoViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
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
    
    self.marginBottom.constant = LQTabBarHeight;
    [self.playBtn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateSelected];
    [self.audioBtn setImage:[UIImage imageNamed:@"ic_no_voice"] forState:UIControlStateNormal];
    [self.audioBtn setImage:[UIImage imageNamed:@"ic_voice"] forState:UIControlStateSelected];
    [self.videoBtn setImage:[UIImage imageNamed:@"ic_video_show"] forState:UIControlStateNormal];
    [self.videoBtn setImage:[UIImage imageNamed:@"ic_video_hide"] forState:UIControlStateSelected];
    [self.fullBtn setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
    [self.fullBtn setImage:[UIImage imageNamed:@"ic_video_max"] forState:UIControlStateSelected];
    
    NSString *terminal = [[CarLocalData sharedInstance] gainTerminal];
    if (terminal && ![terminal isEqualToString:@""]) {
        self.vm.terminal = terminal;
        [self playUrl];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"视频预览";

    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.parentViewController.navigationItem.leftBarButtonItem = settingBtn;
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.parentViewController.navigationItem.rightBarButtonItem = searchBtn;
    
    [self prepareToPlay];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stop];
    [self stopUrl];
}

- (void) setting {
    
}

- (void) search {
    CarTreeViewController *vc = [[CarTreeViewController alloc] initWithStoryborad];
    [vc.subject subscribeNext:^(DepartmentCar *car) {
        self.vm.terminal = car.terminal;
        self.vm.type = @"0";
        
        [self stop];
        
        if (car.carstatus == 1 || car.carstatus == 2) {
            [self showTextHubWithContent:@"当前车辆不在线"];
        } else {
            [self playUrl];
        }
    }];
    [self basePushViewController:vc];
}

- (void) playUrl {
    self.vm.type = @"0";
    
    [self.vm.dataCommand1 execute:nil];
    [self.vm.dataCommand2 execute:nil];
    [self.vm.dataCommand3 execute:nil];
    [self.vm.dataCommand4 execute:nil];
}

- (void) stopUrl {
    self.vm.type = @"1";
    
    [self.vm.dataCommand1 execute:nil];
    [self.vm.dataCommand2 execute:nil];
    [self.vm.dataCommand3 execute:nil];
    [self.vm.dataCommand4 execute:nil];
}

- (void) prepareToPlay {
    [self.player1 prepareToPlay];
    [self.player2 prepareToPlay];
    [self.player3 prepareToPlay];
    [self.player4 prepareToPlay];
}

- (void) stop {
    [self.player1 shutdown];
    [self.player2 shutdown];
    [self.player3 shutdown];
    [self.player4 shutdown];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (void) updatePlayer:(id<IJKMediaPlayback>)player {
    [self.player1.view setHidden:YES];
    [self.player2.view setHidden:YES];
    [self.player3.view setHidden:YES];
    [self.player4.view setHidden:YES];
    
    if (self.currentPlayer == player) {
        if (self.currentPlayer.view.size.height == (self.contentView.size.height - 8)) {
            [self.currentPlayer.view updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo((self.contentView.size.width - 12) / 2);
                make.height.equalTo((self.contentView.size.height - 12) / 2);
            }];
            
            [self.player1.view setHidden:NO];
            [self.player2.view setHidden:NO];
            [self.player3.view setHidden:NO];
            [self.player4.view setHidden:NO];
        } else {
            [self.currentPlayer.view updateConstraints:^(MASConstraintMaker *make) {
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
        make.width.equalTo((self.contentView.size.width - 8));
        make.height.equalTo((self.contentView.size.height - 8));
    }];
}

- (void) player1:(NSString *)urlStr {
    
}

- (void) player2:(NSString *)urlStr {
    if (self.player2) {
        [self.player2.view removeFromSuperview];
    }
    
    self.player2 = [self player:urlStr];
    self.player2.view.backgroundColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.player2.view];
    [self.player2.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.right.equalTo(@(-4));
        make.width.equalTo((self.contentView.size.width - 12) / 2);
        make.height.equalTo((self.contentView.size.height - 12) / 2);
    }];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self updatePlayer:self.player2];
        
        [self.playBtn setSelected:!self.player1.isPlaying];
//        self.audioBtn setSelected:<#(BOOL)#>
        [self.videoBtn setSelected:!self.player1.isPlaying];
    }];
    [self.player2.view addGestureRecognizer:tgr];
}

- (void) player3:(NSString *)urlStr {
    
}

- (void) player4:(NSString *)urlStr {
    if (self.player4) {
        [self.player4.view removeFromSuperview];
    }
    
    self.player4 = [self player:urlStr];
    self.player4.view.backgroundColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.player4.view];
    [self.player4.view makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@(-4));
        make.width.equalTo((self.contentView.size.width - 12) / 2);
        make.height.equalTo((self.contentView.size.height - 12) / 2);
    }];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self updatePlayer:self.player4];
        
        [self.playBtn setSelected:!self.player1.isPlaying];
//        self.audioBtn setSelected:<#(BOOL)#>
        [self.videoBtn setSelected:!self.player1.isPlaying];
    }];
    [self.player4.view addGestureRecognizer:tgr];
}

- (id<IJKMediaPlayback>) player:(NSString *)urlStr {
    IJKFFOptions *options = [self optionsWithurl:urlStr];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    id<IJKMediaPlayback> player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    if (player) {
        player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        player.scalingMode = IJKMPMovieScalingModeAspectFill;
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
        [self.currentPlayer shutdown];
    } else {
        [self.currentPlayer prepareToPlay];
    }
    
    [self.playBtn setSelected:!self.currentPlayer.isPlaying];
}

- (IBAction)audio:(id)sender {
    // TODO
}

- (IBAction)video:(id)sender {
    if (self.currentPlayer.isPlaying) {
        [self.currentPlayer pause];
    } else {
        [self.currentPlayer play];
    }
    
    [self.videoBtn setSelected:!self.currentPlayer.isPlaying];
}

- (IBAction)fullScreen:(id)sender {
    if (!self.fullBtn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, LQScreenHeight, LQScreenWidth);
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            self.statusBarHidden = NO;
            [self prefersStatusBarHidden];
            
//            self.backBtn.frame = CGRectMake(EasyBarHeight, self.backBtn.frame.origin.y, 44, 44);
//
//            self.bottomViewFrame = CGRectMake(0, EasyScreenWidth - BottomViewHeight, EasyScreenHeight, BottomViewHeight);
//            self.bottomView.frame = self.bottomViewFrame;
//            self.bottomView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
            
            self.fullBtn.selected = YES;
//            [self updateConstraints];
//            [self btnNormalImage2];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformIdentity;
            self.view.bounds = CGRectMake(0, 0, LQScreenWidth, LQScreenHeight);
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
//            self.statusBarHidden = YES;
            [self prefersStatusBarHidden];
            
//            self.backBtn.frame = CGRectMake(0, self.backBtn.frame.origin.y, 44, 44);
//
//            self.bottomViewFrame = CGRectMake(0, EasyScreenHeight - BottomViewHeight, EasyScreenWidth, BottomViewHeight);
//            self.bottomView.frame = self.bottomViewFrame;
//            self.bottomView.backgroundColor = [UIColor blackColor];
            
            self.fullBtn.selected = NO;
//            [self updateConstraints];
//            [self btnNormalImage];
        }];
    }
    
//    [self restartToolbarTimer];
}

@end
