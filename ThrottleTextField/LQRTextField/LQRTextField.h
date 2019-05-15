//
//  YJTextField.h
//  TestUITestField
//
//  Created by 吕其瑞 on 2019/5/13.
//  Copyright © 2019年 吕其瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//函数节流: 指定时间间隔内只会执行一次任务；

//函数防抖: 任务频繁触发的情况下，只有任务触发的间隔超过指定间隔的时


@interface LQRTextField : UITextField

//获得焦点，输入框背景色
@property (nonatomic,strong) UIColor *selectBgColor;
//失去焦点，输入框背景色
@property (nonatomic,strong) UIColor *normalBgColor;

//节流间隔---单位(秒)
@property (nonatomic,assign) NSTimeInterval throttleTime;

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
节流功能---回调函数
 */
@property (nonatomic,copy) void(^changeCharacters)(UITextField *textField);

@end

NS_ASSUME_NONNULL_END
