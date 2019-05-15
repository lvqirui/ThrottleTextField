//
//  ViewController.m
//  ThrottleTextField
//
//  Created by 吕其瑞 on 2019/5/14.
//  Copyright © 2019年 吕其瑞. All rights reserved.
//

#import "ViewController.h"
#import "LQRTextField.h"
@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *textDic;

@end

@implementation ViewController

-(NSMutableDictionary *)textDic
{
    if (!_textDic) {
        _textDic = [NSMutableDictionary dictionary];
    }
    return _textDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    LQRTextField *topText = [[LQRTextField alloc] initWithFrame:CGRectMake(20, 100, 300, 50)];
    topText.text = @"";
    topText.placeholder = @"PlaceHolder";
    topText.borderStyle = UITextBorderStyleRoundedRect;
    topText.leftViewMode = UITextFieldViewModeUnlessEditing;
    topText.rightViewMode = UITextFieldViewModeUnlessEditing;
    topText.selectBgColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    topText.normalBgColor = [UIColor whiteColor];
    topText.throttleTime = 2;
    topText.keyboardType = UIKeyboardTypeASCIICapable;
    topText.delegate = self;
    [self.view addSubview:topText];
    
    
    // shouldChangeCharactersInRange协议函数节流执行的block
    topText.changeCharacters = ^(UITextField * _Nonnull textField) {
        NSLog(@"当前的textField====%@",textField.text);
        [self.textDic setValue:textField.text forKey:@"changeCharactersBlock"];
        [self.tableView reloadData];
    };
    
    LQRTextField *bottomText = [[LQRTextField alloc] initWithFrame:CGRectMake(20, 200, 300, 50)];
    bottomText.text = @"";
    bottomText.borderStyle = UITextBorderStyleRoundedRect;
    bottomText.leftViewMode = UITextFieldViewModeUnlessEditing;
    bottomText.rightViewMode = UITextFieldViewModeUnlessEditing;
    bottomText.selectBgColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    bottomText.normalBgColor = [UIColor whiteColor];
    bottomText.delegate = self;
    [self.view addSubview:bottomText];
    
    // shouldChangeCharactersInRange协议函数节流执行的block
    bottomText.changeCharacters = ^(UITextField * _Nonnull textField) {
        NSLog(@"当前的textField====%@",textField.text);
        [self.tableView reloadData];
    };
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放大镜.png"]];
    imageView.frame = CGRectMake(10, 10, 30, 30);
    topText.leftView = imageView;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    topText.rightView = rightBtn;
    
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)rightBtnClick:(UIButton *)btn
{
    NSLog(@"查找");
}

#pragma mark----代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
    if (reason == UITextFieldDidEndEditingReasonCommitted) {
        NSLog(@"textFieldDidEndEditing,reason=====UITextFieldDidEndEditingReasonCommitted");
    } else {
        NSLog(@"textFieldDidEndEditing,reason=====UITextFieldDidEndEditingReasonCancelled");
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.textDic setValue:text forKey:@"changeCharactersDelegate"];
    [self.tableView reloadData];

    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"textFieldShouldClear");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    return YES;
}



#pragma mark-------tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [self.textDic objectForKey:@"changeCharactersBlock"];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = [self.textDic objectForKey:@"changeCharactersDelegate"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textDic.allKeys.count;
}


@end
