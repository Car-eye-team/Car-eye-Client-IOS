//
//  UIExPickerView.m
//  test
//
//  Created by zhangjingfei on 17/5/2019.
//  Copyright © 2019 zhangjingfei. All rights reserved.
//

#import "UIExPickerView.h"
#import "AppDelegate.h"

@implementation UIExPickerView

- (instancetype)initWithArr:(NSArray *)arrData {
    self = [super init];
    if (self) {
        [self setBackgroundColor:UIColorFromRGBA(0x000000, 0.5)];
        self.arr = [[NSMutableArray alloc ] initWithArray:arrData];
        [self initCtrl];
    }
    
    return self;
}

-(void)initCtrl {
    CGFloat x = 35;
    CGFloat w = LQScreenWidth - x * 2;
    CGFloat btnH = 40, btnW = 80;
    CGFloat pickViewH = LQScreenHeight / 2;
    CGFloat y = (LQScreenHeight - btnH - pickViewH) / 2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, btnH)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *btnCancel = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(onButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnCancel];
    
    UIButton *btnFinish = [[UIButton alloc ] initWithFrame:CGRectMake(w-btnW, 0, btnW, btnH)];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFinish addTarget:self action:@selector(onButtonFinish) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnFinish];
    
    UIPickerView *pickerView = [[UIPickerView alloc ] initWithFrame:CGRectMake(x, y+btnH, w, pickViewH)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    [self addSubview:pickerView];
}

- (void) show {
    self.frame = CGRectMake(0, 0, LQScreenWidth, LQScreenHeight);
    [[AppDelegate sharedDelegate].window addSubview:self];
}

-(void) onButtonCancel {
    if (self) {
        [self removeFromSuperview];
    }
}

-(void) onButtonFinish {
    if ([self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:_indexSelect];
    }
    
    //点击完成后，关闭当前view
    [self onButtonCancel];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"%@",self.arr[row]);
    _indexSelect = row;
}

@end
