//
//  PlaybackViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "PlaybackViewController.h"
#import "SearchPlaybackViewController.h"
#import "FullPlayerViewController.h"
#import "PlaybackViewModel.h"
#import "SearchParam.h"
#import "PlaybackCell.h"
#import "Masonry.h"

@interface PlaybackViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PlaybackViewModel *viewModel;

@end

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
//        make.top.equalTo(@(LQNavHeight + LQBarHeight));
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"录像回放";

    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.parentViewController.navigationItem.leftBarButtonItem = settingBtn;
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.parentViewController.navigationItem.rightBarButtonItem = searchBtn;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHub];
}

- (void) setting {
    
}

- (void) search {
    SearchPlaybackViewController *vc = [[SearchPlaybackViewController alloc] initWithStoryborad];
    vc.param = self.viewModel.param;
    [vc.subject subscribeNext:^(SearchParam *p) {
        [self showHub];
        
        if (p.channel == 0) {
            self.viewModel.channelID = 1;
        } else {
            self.viewModel.channelID = p.channel;
        }
        self.viewModel.param = p;
        [self.viewModel.dataCommand execute:nil];
    }];
    [self basePushViewController:vc];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (PlaybackViewModel *) viewModel {
    if (!_viewModel) {
        _viewModel = [[PlaybackViewModel alloc] init];
    }
    
    return _viewModel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaybackCell *cell = [PlaybackCell cellWithTableView:tableView];
    TerminalFile *model = self.viewModel.data[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TerminalFile *model = self.viewModel.data[indexPath.row];
    
    FullPlayerViewController *vc = [[FullPlayerViewController alloc] init];
    vc.terminal = self.viewModel.param.car.terminal;
    vc.file = model;
    [self basePushViewController:vc];
}

@end
