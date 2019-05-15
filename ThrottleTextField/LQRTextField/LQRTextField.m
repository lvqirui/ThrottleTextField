//
//  YJTextField.m
//  TestUITestField
//
//  Created by 吕其瑞 on 2019/5/13.
//  Copyright © 2019年 吕其瑞. All rights reserved.
//

#import "LQRTextField.h"

/*
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 
LQRTextFieldManager
 
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 */

@interface LQRTextFieldManager : NSObject<UITextFieldDelegate>

@property (nonatomic,weak) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic,strong) UIColor *selectBgColor;
@property (nonatomic,strong) UIColor *normalBgColor;

@property (nonatomic,assign) NSTimeInterval throttleTime;

@property (nonatomic,copy) void(^changeCharacters)(UITextField *textField);

@property (nonatomic,assign) BOOL throttling;
@end

@implementation LQRTextFieldManager

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.selectBgColor) {
        textField.backgroundColor = self.selectBgColor;
    }
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.normalBgColor) {
        textField.backgroundColor = self.normalBgColor;
    }
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.textFieldDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
         [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.textFieldDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [self.textFieldDelegate textFieldDidEndEditing:textField reason:reason];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (self.throttleTime >= 0) {
        if (!self.throttling) {
            self.throttling = YES;
            [self performSelector:@selector(performDelegate:) withObject:textField afterDelay:self.throttleTime];
        }
    }
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.textFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }

    return YES;
    
}


-(void)performDelegate:(UITextField *)textField
{
    self.throttling = NO;
    if (self.changeCharacters) {
        self.changeCharacters(textField);
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.textFieldDelegate textFieldShouldClear:textField];
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.textFieldDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

@end


/*
 * * * * * * * * * * * * * * * * * * * * * * * * * *

 LQRTextField
 
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 */

@interface LQRTextField()

@property (nonatomic,strong) LQRTextFieldManager *manager;

@end

@implementation LQRTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.manager = [[LQRTextFieldManager alloc] init];
        self.delegate = nil;
    }
    return self;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    NSAssert(self.manager, @"manager属性必须先被初始化，然后再调用delegate的set方法");
    self.manager.textFieldDelegate = delegate;
    super.delegate = self.manager;
}

-(void)setSelectBgColor:(UIColor *)selectBgColor
{
    _selectBgColor = selectBgColor;
    self.manager.selectBgColor = _selectBgColor;
}

-(void)setNormalBgColor:(UIColor *)normalBgColor
{
    _normalBgColor = normalBgColor;
    self.manager.normalBgColor = _normalBgColor;
}

-(void)setThrottleTime:(NSTimeInterval)throttleTime
{
    _throttleTime = throttleTime;
    self.manager.throttleTime = throttleTime;
}

-(void)setChangeCharacters:(void (^)(UITextField * _Nonnull))changeCharacters
{
    self.manager.changeCharacters = changeCharacters;
}

@end
