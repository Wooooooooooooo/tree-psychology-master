//
//  PDValidatePhoneNumberViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 03/10/2016.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "PDValidatePhoneNumberViewController.h"
#import "RegistInformationViewController.h"
#import "Singleton.h"
#import "Masonry.h"

@interface PDValidatePhoneNumberViewController ()

@property (nonatomic) BOOL isRoot;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *requestPhoneNumberLabel;
@property (strong, nonatomic) UITextField *phoneNumberField;
@property (strong, nonatomic) UIView *underscoreLineView;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIImageView *bottomImageView;

@end

@implementation PDValidatePhoneNumberViewController

- (instancetype)initWithRootPriority:(BOOL)isRoot {
    self = [super init];
    if (self) {
        self.isRoot = isRoot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"使用手机号登录";
    _titleLabel.textColor = [UIColor colorWithRed:25.0/255 green:189.0/255 blue:154.0/255 alpha:1];
    [_titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    _requestPhoneNumberLabel = [[UILabel alloc] init];
    _requestPhoneNumberLabel.text = @"手机号: ";
    
    _phoneNumberField = [[UITextField alloc] init];
    _phoneNumberField.placeholder = @"你的手机号码";
    
    _underscoreLineView = [[UIView alloc] init];
    _underscoreLineView.backgroundColor = [UIColor greenColor];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor = [UIColor colorWithRed:35.0/255 green:207.0/255 blue:169.0/255 alpha:1];
    _submitButton.tintColor = [UIColor whiteColor];
    [_submitButton setTitle:@"发 送 验 证 码" forState:UIControlStateNormal];
    
    _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"validate-phone-background"]];
    
    [self.view addSubview:_bottomImageView];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:_requestPhoneNumberLabel];
    [_requestPhoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(10);
    }];
    
    [self.view addSubview:_phoneNumberField];
    [_phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_requestPhoneNumberLabel.mas_right);
        make.height.equalTo(_requestPhoneNumberLabel.mas_height);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    [self.view addSubview:_underscoreLineView];
    [_underscoreLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_requestPhoneNumberLabel.mas_bottom).with.offset(7);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(5);
    }];
    
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_underscoreLineView).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
}

- (void)sendCaptcha {
    NSMutableURLRequest *sendCaptchaRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://pandoctor.applinzi.com/sendMessage.php?mobile=%@", _phoneNumberField.text]]];
    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:sendCaptchaRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
            [[[UIAlertView alloc] initWithTitle:@"验证码发送失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
        }
        
        [[[UIAlertView alloc] initWithTitle:@"验证码已发送" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        self.requestPhoneNumberLabel.text = @"验证码: ";
        self.phoneNumberField.text = @"";
        self.phoneNumberField.placeholder = @"请输入验证码";
        [self.submitButton setTitle:@"登 录" forState:UIControlStateNormal];
    }] resume];
}

- (void)login {
    NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://pandoctor.applinzi.com//register.php?order=exist&mobile=%@", _phoneNumberField.text]]];
    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:loginRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
       //     NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
            [[[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"HttpResponseCode:%ld", responseCode);
      //  NSLog(@"HttpResponseBody %@",responseString);
        
        if (![responseString isEqualToString:@"0"]) {
            [self storeInformationAfterLoginSuccess];
            
            if (_isRoot) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return;
        }
        
        [self goRegisterInformation];
        
    }] resume];
}

- (void)goRegisterInformation {
    RegistInformationViewController *nextVC = [[RegistInformationViewController alloc] init];
    nextVC.isRoot = _isRoot;
    nextVC.phone = _phoneNumberField.text;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)storeInformationAfterLoginSuccess {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
    Singleton *instance = [Singleton getInstance];
    NSMutableDictionary *dic = instance.userDictonary;
    //[plistDictionary setObject:self.phoneNumberField.text forKey:@"login"];
    [plistDictionary setObject:[dic objectForKey:@"nickname"] forKey:@"login"];
    [plistDictionary setObject:[dic objectForKey:@"userID"] forKey:@"userID"];
    
    [plistDictionary writeToFile:documentPlistPath atomically:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
