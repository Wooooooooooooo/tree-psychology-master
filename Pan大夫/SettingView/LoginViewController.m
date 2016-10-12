//
//  LoginViewController.m
//  Pan大夫
//
//  Created by zxy on 2/21/15.
//  Copyright (c) 2015 Neil. All rights reserved.
//

#import "LoginViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "JKCountDownButton.h"
#import "RegistInformation/RegistInformationViewController.h"
#import "Singleton.h"

int navH;

@interface LoginViewController ()
{
    BOOL hasNavs;
}

@property (strong, nonatomic) UILabel *welLabel;
@property (strong, nonatomic) UITextField *telField;
@property (strong, nonatomic) UITextField *CAPTCHAField;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *userID;
@property (strong,nonatomic) NSDictionary *infoDictionary;


@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) JKCountDownButton *CAPTCHAButton;

@property (strong, nonatomic) MKNetworkOperation *op;

// CL Add
@property (atomic, copy) NSString *captcha;
@property (atomic) NSDictionary *dic;

@end

@implementation LoginViewController

@synthesize welLabel, telField,CAPTCHAField,loginButton,CAPTCHAButton;
@synthesize settingsView;
@synthesize op;
@synthesize scroll;



//创建登录界面
- (id)initWithNav:(BOOL)hasNav SettingsViewController:(SettingsViewController *)settingsViewController{
    self = [super init];
    if (self) {
        hasNavs = hasNav;
        //[self.view setFrame:CGRectMake(0, 64, userImageW, userImageH + bgH)];
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1];
        settingsView = settingsViewController;
        NSLog(@"~~~~~~~in longin ~~~~~~~%@", settingsView);
    }
    if (hasNav == YES && settingsViewController == nil) {
        navH = 0;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 64+20)];
        headerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, 200, 50)];
        titleLabel.font = [UIFont systemFontOfSize:28];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
        titleLabel.text = @"大树心理";
        [headerView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 40, 30)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:cancelButton];
        
        [self.view addSubview:headerView];
        
    }
    
    self.navigationItem.hidesBackButton = NO;
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, !settingsViewController ? 70 : 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    [self.view addSubview:scroll];
    
    //上方图像
    UIImage* userImage;
    if (FrameH > 319 && FrameH < 321) {
        userImage = [UIImage imageNamed:@"panda-4s.png"];
    }else{
        userImage = [UIImage imageNamed:@"panda.png"];
    }
    UIImageView* userImageView = [[UIImageView alloc] initWithImage:userImage];
    userImageView.frame = CGRectMake(0, 0, userImageW, userImageH);
    NSLog(@"%d",navH);
    [scroll addSubview:userImageView];
    
    //登录显示
    UILabel *userLabel= [[UILabel alloc]initWithFrame:CGRectMake((userImageW - labelW)/2, navH + userImageH - 1.8*labelH, labelW, labelH)];
    userLabel.text = @"未登录";
    userLabel.textColor = [UIColor whiteColor];
    userLabel.font = [UIFont systemFontOfSize:loginFont];
    [scroll addSubview:userLabel];
    
    //创建欢迎登录标签
    welLabel = [[UILabel alloc]initWithFrame:CGRectMake((userImageW - localLabelW)/2, navH + upLabel + userImageH, localLabelW, localLabelH)];
    welLabel.text = @"您好，登录即可享受大树心理服务";
    welLabel.textColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1];
    welLabel.font = [UIFont systemFontOfSize:(hitFont+2)];
    
    //创建电话号码输入框
    telField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + uptel + userImageH, telW, telH)];
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneIcon.png"]];
    phoneIcon.frame = CGRectMake(0, 0, telIconW, telH);
    [phoneIcon setContentMode:UIViewContentModeScaleToFill];
    telField.leftView = phoneIcon;
    telField.leftViewMode = UITextFieldViewModeAlways;
    telField.placeholder = @"请输入您的手机号码";
    telField.font = [UIFont systemFontOfSize:(hitFont+1)];
    telField.returnKeyType = UIReturnKeyDone;
    telField.clearButtonMode = UITextFieldViewModeWhileEditing;
    telField.keyboardType = UIKeyboardTypeNumberPad;
    telField.delegate = self;
    telField.borderStyle = UITextBorderStyleNone;
    telField.backgroundColor = [UIColor whiteColor];
    [telField.layer setCornerRadius:4];
    
    //创建验证码输入框
    CAPTCHAField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + upCAPTCHA + userImageH, CAPTCHAW, telH)];
    UIImageView *keyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyIcon.png"]];
    keyIcon.frame = CGRectMake(0, 0, telIconW, telH);
    [keyIcon setContentMode:UIViewContentModeScaleToFill];
    CAPTCHAField.leftView = keyIcon;
    CAPTCHAField.leftViewMode = UITextFieldViewModeAlways;
    CAPTCHAField.placeholder = @"请输入验证码";
    CAPTCHAField.font = [UIFont systemFontOfSize:(hitFont+1)];
    CAPTCHAField.returnKeyType = UIReturnKeyDone;
    CAPTCHAField.clearButtonMode = UITextFieldViewModeWhileEditing;
    CAPTCHAField.keyboardType = UIKeyboardTypeNumberPad;
    CAPTCHAField.delegate = self;
    CAPTCHAField.borderStyle = UITextBorderStyleNone;
    CAPTCHAField.backgroundColor = [UIColor whiteColor];
    [CAPTCHAField.layer setCornerRadius:4];
    
    //创建发送验证码按钮
    CAPTCHAButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [CAPTCHAButton.layer setCornerRadius:4];
    CAPTCHAButton.frame = CGRectMake(userImageW - (userImageW - telW)/2 - CAPTCHAButtonW, navH + upCAPTCHA + userImageH, CAPTCHAButtonW, telH);
    [CAPTCHAButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [CAPTCHAButton setTitleColor:[UIColor colorWithRed:134/255.0 green:94/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    [CAPTCHAButton setBackgroundColor:[UIColor colorWithRed:254/255.0 green:239/255.0 blue:206/255.0 alpha:1]];
    [CAPTCHAButton addTarget:self action:@selector(sendIdCode:) forControlEvents:UIControlEventTouchUpInside];
    CAPTCHAButton.titleLabel.font = [UIFont systemFontOfSize:hitFont];
    
    
    
    //创建登录（注册）按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton.layer setCornerRadius:4];
    loginButton.frame = CGRectMake((userImageW - telW)/2,navH + upLogin + userImageH, telW, telH);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:22/255.0 green:175/255.0 blue:170/255.0 alpha:1]];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:(hitFont+2)];
    [scroll addSubview:welLabel];
    [scroll addSubview:telField];
    [scroll addSubview:CAPTCHAField];
    [scroll addSubview:CAPTCHAButton];
    [scroll addSubview:loginButton];
    if (navH == 64) {
        [scroll setContentOffset:CGPointMake(0, 0)];
    }
    
    NSLog(@"~~~~~~~~~~ %lu", self.navigationController.viewControllers.count);
    for (UIViewController *VC in self.navigationController.viewControllers) {
        NSLog(@"~~~~~~~%@", VC);
    }
    
//    int r = arc4random() % 1000000;
//    self.captcha = [NSString stringWithFormat:@"%d", r];
    
    return self;
}

-(void)back
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        NSLog(@"back");
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击textfield开始编辑触发函数
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [scroll setContentOffset:CGPointMake(0, Offset) animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //单击屏幕时隐藏键盘
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    self.navigationItem.hidesBackButton = YES;
}

//隐藏键盘
-(void)hideKeyboard{
    [telField resignFirstResponder];
    [CAPTCHAField resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0, OffsetBack) animated:YES];
    
}

/**
 *  用户点击发送验证码时执行，检测手机号格式是否正确
 */
- (void)sendIdCode:(id)sender{
    //判断手机号码格式
    if (telField.text.length!=11)
    {
        //手机号码不正确
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil)
                                                      message:NSLocalizedString(@"手机号码格式不正确", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"好的", nil)
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
       
    //弹出提示窗口，确认是否下发短信
    NSString* str=[NSString stringWithFormat:@"%@:%@ %@",@"验证码将发送到你的手机",@"\n+86 ",telField.text];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确定发送"
                                                  message:str delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"好的", nil];
    alert.tag = 50;
    [alert show];
    
    
}

/**
 *  用户确认发送验证码时执行if 1，发送验证码给用户的手机
 *  用户确认登录成功时执行if 2，返回登录界面，显示登录用户名
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果用户选择确认
    if (50 == alertView.tag) {
        if (1==buttonIndex) {
            // TODO: 重写
            NSString *telephone = telField.text;
            if (telephone.length != 11) {
                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确长度的手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return;
            }
            [telField setUserInteractionEnabled:NO];
            NSString *getCaptchaURL = [NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/sendMessage.php?mobile=%@", telephone];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:getCaptchaURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [req setHTTPMethod:@"GET"];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                } else {
                    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"HttpResponseCode:%ld", responseCode);
                    NSLog(@"HttpResponseBody %@",responseString);
                    Singleton *instance = [Singleton getInstance];
                    instance.tel = telephone;
                    
                    self.captcha = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
                }
            }];
            [dataTask resume];
            NSLog(@"V code sent");
            
            //下发验证码
//            NSString *str1 = [[NSString alloc]initWithFormat:@"+86"];
//            NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"+" withString:@""];
//            [SMS_SDK getVerificationCodeBySMSWithPhone:telField.text
//                                                  zone:str2
//                                                result:^(SMS_SDKError *error)
//             {
//                 if (!error)
//                 {
//                     NSLog(@"%@",str2);
//                     NSLog(@"%@",telField.text);
//                 }
//                 else
//                 {
//                     UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
//                                                                   message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
//                                                                  delegate:self
//                                                         cancelButtonTitle:NSLocalizedString(@"sure", nil)
//                                                         otherButtonTitles:nil, nil];
//                     [alert show];
//                 }
//                 
//             }];
            [CAPTCHAButton startWithSecond:60];
            [CAPTCHAButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                 NSString *title = [NSString stringWithFormat:@"%d秒",second];
                 return title;
             }];
            CAPTCHAButton.enabled = NO;
            [CAPTCHAButton setBackgroundColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]];
            [CAPTCHAButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [CAPTCHAButton setTitle:@"60秒" forState:UIControlStateNormal];
            
            
                [CAPTCHAButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    [countDownButton setBackgroundColor:[UIColor colorWithRed:254/255.0 green:239/255.0 blue:206/255.0 alpha:1]];
                    [countDownButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    return @"发送验证码";
                }];
            
            
        }
    }
    
//    验证成功后
    if (100 == alertView.tag) {
        [self loginSucess];
        
        //        if (hasNavs == YES) {
        //            [settingsView userDidLogin:telField.text];
        //            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //            NSString *documentsDirectory =[paths objectAtIndex:0];
        //            NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
        //            NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
        //            [plistDictionary setObject:telField.text forKey:@"login"];
        //            [self dismissViewControllerAnimated:YES completion:^{
        //                [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogin" object:nil];
        //            }];
        //        }else{
        //            [self cancelLoginView];
        //        }
        //        settingsView = [SettingsViewController new];
    }
}

-(void)loginSucess{
    if (settingsView) {
        [settingsView userDidLogin:telField.text];
    }
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];//plist 文件
    Singleton *instance = [Singleton getInstance];
    NSMutableDictionary *dic = instance.userDictonary;
    NSLog(@"手机号  %@",instance.tel);
    //[plistDictionary setObject:instance.tel forKey:@"tel"];
    [plistDictionary setObject:[dic objectForKey:@"nickname"] forKey:@"login"];
    [plistDictionary setObject:[dic objectForKey:@"userID"] forKey:@"userID"];
    [plistDictionary writeToFile:documentPlistPath atomically:YES];//写入
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogin" object:nil];
    NSLog(@"%@", self.navigationController);
    [self performSelector:@selector(pop) withObject:nil afterDelay:0.25];//0.25s键盘动画消失后再pop
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  用户点击登录后执行，向服务器请求数据 检验验证码是否正确 正确则成功登录
 */

- (void)login:(id)sender{
    NSLog(@"login");
    [loginButton setEnabled:NO];
    
    //判断手机号码格式
    if (telField.text.length!=11) {
        //手机号码不正确
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil)
                                                      message:NSLocalizedString(@"手机号码格式不正确", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"好的", nil)
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        if (![CAPTCHAField.text isEqualToString:self.captcha]) {
            [[[UIAlertView alloc] initWithTitle:@"错误" message:@"验证码不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        // 否则成功
        NSLog(@"%@", CAPTCHAField.text);
//        [self.navigationController popViewControllerAnimated:YES];
        
        [self checkIfUserHasRecord];
        
        // TODO: 根据新的 API 重新写 [self checkIfUserHasRecord] 逻辑
        
        
//        [self.navigationController pushViewController:nextVC animated:YES];
        
        
//        [SMS_SDK commitVerifyCode:CAPTCHAField.text result:^(enum SMS_ResponseState state) {
//            if (1==state)
//            {
//                NSLog(@"验证成功");
//                [self hideKeyboard];
//
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"恭喜"
//                                                              message:@"登录成功"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"好的"
//                                                    otherButtonTitles:nil];
//                alert.tag = 100;
//                [alert show];
//            }
//            else if(0==state)
//            {
//                NSLog(@"验证失败");
//                NSLog(@"%@",CAPTCHAField.text);
//                NSLog(@"%lu",(unsigned long)CAPTCHAField.text.length);
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
//                                                              message:NSLocalizedString(@"验证码错误", nil)
//                                                             delegate:nil
//                                                    cancelButtonTitle:NSLocalizedString(@"好的", nil)
//                                                    otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];

    }
    [loginButton setEnabled:YES];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goAddPersonalInformation {
    RegistInformationViewController *nextVC = [[RegistInformationViewController alloc] init];
    nextVC.phone = telField.text;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)checkIfUserHasRecord {
    // 获取信息，是否已经有
//    if (!self.dic) {
//        NSLog(@"self.dic is nil");
//        return;
//    }
//    [self storeInformationAfterLoginSuccess];
//    [self.navigationController popViewControllerAnimated:YES];
//    return;
    
 //   NSString *checkURL = [NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/register.php?order=exist&mobile=%@", telField.text];
      NSString *checkURL = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/register.php?order=exist&mobile=%@", telField.text];
    NSMutableURLRequest *checkReq = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:checkURL]];
    [checkReq setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *checkDataTask = [session dataTaskWithRequest:checkReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
            [[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络连接异常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
//            [self.navigationController popViewControllerAnimated:YES];
            [self performSelectorOnMainThread:@selector(pop) withObject:nil waitUntilDone:NO];
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSMutableDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([responseString isEqualToString:@"0"]) {
                [self performSelectorOnMainThread:@selector(goAddPersonalInformation) withObject:nil waitUntilDone:NO];
            } else {
//                [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@[@YES] waitUntilDone:NO];
                
                Singleton *singleton = [Singleton getInstance];
                singleton.userDictonary = JSONDic;
                
           //     NSLog(@"josnjosnjsonjsonjson     %@",singleton.userDictonary);
                [self storeInformationAfterLoginSuccess];
                [self performSelectorOnMainThread:@selector(pop) withObject:nil waitUntilDone:NO];
            }
        //    NSLog(@"%@", JSONDic);
        }
    }];
    [checkDataTask resume];
}

- (void)storeInformationAfterLoginSuccess {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
    Singleton *instance = [Singleton getInstance];
    instance.userID = [instance.userDictonary objectForKey:@"userID"];
    NSMutableDictionary *dic = instance.userDictonary;
    [plistDictionary setObject:[dic objectForKey:@"nickname"] forKey:@"login"];
    [plistDictionary setObject:instance.tel forKey:@"tel"];
    [plistDictionary setObject:instance.userID forKey:@"userID"];
    //[plistDictionary setObject:self.telField.text forKey:@"login"];
    
   // NSLog(@"%@", plistDictionary);
    
    [plistDictionary writeToFile:documentPlistPath atomically:YES];
}

- (UIViewController *)settingsViewController{
    for (UIView *next = [self.view superview] ;next;next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[SettingsViewController class]]){
            NSLog(@"selfController is %@",nextResponder);
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/**
 *  用户成功登录时执行，改变成已登录状态
 */
//- (void)cancelLoginView{
//    [self.view removeFromSuperview];
//}


@end
