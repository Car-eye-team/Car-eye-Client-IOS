//
//  CarTreeViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "CarTreeViewController.h"
#import "CarTreeViewModel.h"
#import "AppDelegate.h"
#import "CarTreeCell.h"
#import "CarLocalData.h"

@interface CarTreeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CarTreeViewModel *vm;

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, strong) NSMutableArray *resultCars;
@property (nonatomic, strong) NSMutableArray *showCars;

@end

@implementation CarTreeViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarTreeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleView];
    LQViewBorderRadius(_tfView, 18, 1, UIColorFromRGB(0xD8D8D8));
    
    self.tf.delegate = self;
    self.showCars = [[NSMutableArray alloc] init];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIView *) titleView {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[ @"所有", @"在线"]];
    [seg setSelectedSegmentIndex:0];
    seg.frame = CGRectMake(0, 0, 180, 32);
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    [seg setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    return seg;
}

- (void) segClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self uploadDataWithAll:YES];
    } else {
        [self uploadDataWithAll:NO];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tf resignFirstResponder];//取消第一相应者
    [self search:nil];
    
    return YES;
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (void) uploadDataWithAll:(BOOL)isAll {
    [self.showCars removeAllObjects];
    
    _isAll = isAll;
    
    if (_isAll) {
        self.resultCars = [AppDelegate sharedDelegate].allCars;
    } else {
        self.resultCars = [AppDelegate sharedDelegate].onlineCars;
    }
    
    [self.showCars removeAllObjects];
    
    [self.tableView reloadData];
}

- (void) closeOrg:(DepartmentCar *)model {
    if ([model.parentId isEqualToString:@"0"]) {
        DepartmentCar *car = self.resultCars.firstObject;
        car.isExpand = NO;
        car.isShow = YES;
        
        return;
    }
    
    NSMutableArray *parentIds = [[NSMutableArray alloc] init];
    
    for (int i = model.index; i < self.resultCars.count; i++) {
        DepartmentCar *car = self.resultCars[i];
        
        if ([car.parentId isEqualToString:model.nodeId]) {
            car.isShow = NO;
            
        } else {
            for (NSString *pid in parentIds) {
                if ([pid isEqualToString:car.parentId]) {
                    car.isShow = NO;
                    
                }
            }
        }
    }
    
    for (DepartmentCar *car in self.resultCars) {
        if (car.isShow) {
            [self.showCars addObject:car];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showCars.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarTreeCell *cell = [CarTreeCell cellWithTableView:tableView];
    DepartmentCar *model = self.showCars[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row >= self.showCars.count) {
        return;
    }
    
    DepartmentCar *model = self.showCars[indexPath.row];
    if (model.nodetype == 2) {
        // 直接选中车辆，则返回
        [AppDelegate sharedDelegate].car = model;
        [[CarLocalData sharedInstance] saveTerminal:model.terminal];
        
        [self.subject sendNext:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - click

- (IBAction)search:(id)sender {
    
}

- (CarTreeViewModel *) vm {
    if (!_vm) {
        _vm = [[CarTreeViewModel alloc] init];
    }
    
    return _vm;
}

- (RACSubject *) subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    
    return _subject;
}

@end
