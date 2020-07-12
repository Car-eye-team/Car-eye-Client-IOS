//
//  WarnViewController.m
//  CarEyeClient
//
//  Created by asd on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "WarnViewController.h"
#import "SettingViewController.h"
#import "SearchTrackViewController.h"
#import "WarnDetailViewController.h"
#import "WarnViewModel.h"
#import "WarnCell.h"
#import "RefreshGifHeader.h"
#import "RefreshGifFooter.h"
#import "PromptView.h"
#import "Masonry.h"

@interface WarnViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PromptView *promptView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WarnCell *tempCell;

@property (nonatomic, strong) WarnViewModel *vm;

@end

@implementation WarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tempCell = [[WarnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WarnCell"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    self.tableView.mj_header = [RefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    
    self.tableView.mj_footer = [RefreshGifFooter footerWithRefreshingBlock:^{
        if (self.vm.page < self.vm.totalPage) {
            [self loadData:NO];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    [self.view addSubview:self.promptView];
    [self.promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    self.promptView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"报警";
    
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
    SettingViewController *vc = [[SettingViewController alloc] initWithStoryborad];
    [self basePushViewController:vc];
}

- (void) search {
    SearchTrackViewController *vc = [[SearchTrackViewController alloc] initWithStoryborad];
    vc.navTitle = @"报警查询";
    vc.param = self.vm.param;
    [vc.subject subscribeNext:^(SearchParam *p) {
        [self showHub];
        
        self.vm.param = p;
        [self loadData:YES];
    }];
    [self basePushViewController:vc];
}

- (void) loadData:(BOOL)refresh {
    if (self.vm.param) {
        [self.vm.dataCommand execute:@(refresh)];
    } else {
        [self hideHub];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    [self.vm.msgSubject subscribeNext:^(id x) {
        [self hideHub];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
        if (self.vm.data.count == 0) {
            self.promptView.hidden = NO;
        } else {
            self.promptView.hidden = YES;
        }
    }];
}

- (WarnViewModel *) vm {
    if (!_vm) {
        _vm = [[WarnViewModel alloc] init];
    }
    
    return _vm;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.vm.data.count) {
        return;
    }
    
    Alarm *model = self.vm.data[indexPath.row];
    WarnDetailViewController *vc = [[WarnDetailViewController alloc] initWithStoryborad];
    vc.alarm = model;
    vc.nodeName = self.vm.param.car.nodeName;
    [self basePushViewController:vc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Alarm *model = self.vm.data[indexPath.row];
    if (model.height == 0) {
        model.height = [self.tempCell heightForModel:model];
    }
    
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Alarm *model = self.vm.data[indexPath.row];
    
    WarnCell *cell = [WarnCell cellWithTableView:tableView];
    [cell setModel:model carNumber:self.vm.param.car.nodeName];
    return cell;
}

- (PromptView *) promptView {
    if (!_promptView) {
        _promptView = [[PromptView alloc] initWithFrame:CGRectMake(0, 0, LQScreenWidth, LQScreenHeight)];
        [_promptView setNilDataWithImagePath:@"nochart" tint:@"暂无数据" btnTitle:@""];
    }
    
    return _promptView;
}

@end
