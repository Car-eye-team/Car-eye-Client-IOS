//
//  FullPlayerViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/7.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "FullPlayerViewController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "FullPlayerViewModel.h"
#import "Masonry.h"

#define BottomViewHeight 128

@interface FullPlayerViewController()<UIAlertViewDelegate> {
    
}

@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) FullPlayerViewModel *vm;

@end

@implementation FullPlayerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // 得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    // 将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    _webView = [[UIWebView alloc] init];
//    [self.view addSubview:_webView];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@260);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.left.right.equalTo(@0);
//    }];
    
    _webView.scalesPageToFit = YES;//自动调整尺寸
    _webView.scrollView.scrollEnabled = NO;//禁止滚动
    _webView.backgroundColor = UIColorFromRGB(0xebebeb);
    _webView.opaque = 0;
    [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.statusBarHidden = YES;
    [self prefersStatusBarHidden];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}

#pragma mark - Notification

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        
        [self hideLoad];
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
//        [self.player stop];[self.player play];[self.mediaControl refreshMediaControl];
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            [self hideLoad];
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            [self hideLoad];
            break;
        case IJKMPMovieFinishReasonPlaybackError: {
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
//            [self play];// 断开重连
            
            [self hideLoad];

            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lost"]];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.backgroundColor = UIColorFromRGB(0xebebeb);
            [self.view addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@200);
                make.centerY.equalTo(self.view.mas_centerY);
                make.left.right.equalTo(@0);
            }];
        }
            break;
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void) hideLoad {
    _webView.hidden = YES;
}

- (void) play:(NSString *)urlStr {
    if (self.player) {
        [self.player.view removeFromSuperview];
    }
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    if (self.player) {
        self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.player.view.frame = self.view.bounds;
        self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
        self.player.shouldAutoplay = YES;
        self.view.autoresizesSubviews = YES;
        [self.view insertSubview:self.player.view atIndex:0];
    }
}

#pragma mark - StatusBar

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (FullPlayerViewModel *) vm {
    if (!_vm) {
        _vm = [[FullPlayerViewModel alloc] init];
    }
    
    return _vm;
}


@end
