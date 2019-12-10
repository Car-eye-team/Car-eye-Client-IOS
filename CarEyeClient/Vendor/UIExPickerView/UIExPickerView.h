//
//  UIExPickerView.h
//  test
//
//  Created by zhangjingfei on 17/5/2019.
//  Copyright © 2019 zhangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol pickerDelegate <NSObject>
- (void)selectIndex:(NSInteger)index;
@end


@interface UIExPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray       *arr;
@property (nonatomic, assign) NSInteger            indexSelect;
@property (nonatomic, weak) id <pickerDelegate>     delegate;


/*  初始化方法
    frame ：选择框的frame
    arrData ： 要展示的数据
*/
- (instancetype)initWithArr:(NSArray *)arrData;
- (void) show;

@end

NS_ASSUME_NONNULL_END
