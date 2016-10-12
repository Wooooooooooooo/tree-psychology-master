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
#import "ModifyInformationViewController.h"
#import "Singleton.h"

int navH;

@interface ModifyInformationViewController ()
{
    BOOL hasNavs;
}

@property (strong,nonatomic) UIImage *userImage;
@property (strong,nonatomic) UIButton *boyButton;
@property (strong,nonatomic) UIButton *girlButton;
@property (strong, nonatomic) UILabel *welLabel;
@property (strong,nonatomic) UILabel *nicknameLabel;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *schoolNumberLabel;
@property (strong,nonatomic) UILabel *collegeLabel;
@property  (strong,nonatomic) UILabel *majorLabel;
@property (strong,nonatomic) UITextField * nameField;
@property (strong, nonatomic) UITextField *telField;
@property (strong, nonatomic) UITextField *CAPTCHAField;
@property (strong, nonatomic) UITextField *nicknameField;
@property (strong, nonatomic) UITextField *schoolNumberField;
@property (strong, nonatomic) UITextField *collegeField;
@property (strong, nonatomic) UITextField *majorField;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *sex;
@property (strong,nonatomic) NSDictionary *infoDictionary;


@property (strong, nonatomic) UIButton *loginButton;
@property (strong,nonatomic) UIButton *logoffButton;
@property (strong, nonatomic) JKCountDownButton *CAPTCHAButton;

@property (strong, nonatomic) MKNetworkOperation *op;

// CL Add
@property (atomic, copy) NSString *captcha;
@property (atomic) NSDictionary *dic;

@end

@implementation ModifyInformationViewController

@synthesize welLabel,nicknameField,nicknameLabel,nameLabel,nameField,telField,CAPTCHAField,loginButton,CAPTCHAButton,logoffButton;
@synthesize schoolNumberLabel,schoolNumberField,collegeField,collegeLabel,majorField,majorLabel;
@synthesize settingsView,boyButton,girlButton,sex;
@synthesize op,userImage;
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
    //if (FrameH > 319 && FrameH < 321) {
        userImage = [UIImage imageNamed:@"picOfBoyHead.png"];
  //  }else{
  //      userImage = [UIImage imageNamed:@"panda.png"];
   // }
    UIImageView* userImageView = [[UIImageView alloc] initWithImage:userImage];
    userImageView.frame = CGRectMake(userImageW/2-userImageNewW/2, 0, userImageH, userImageH);
    NSLog(@"%d",navH);

    [scroll addSubview:userImageView];
    
    
    sex = @"0";
    boyButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2-3*telIconW, navH+userImageH+uptel/2, 3*telIconW, telIconW)];
    UIImage *boyYesImage = [UIImage imageNamed:@"picOfBoyYes.png"];
    UIEdgeInsets insets1 = UIEdgeInsetsMake(0,0,0,0);
    [boyYesImage resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeStretch];
    [boyButton setBackgroundColor:[UIColor blackColor]];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateNormal];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateSelected];
    //[boyButton addSubview:boyImageView];
    [boyButton addTarget:self action:@selector(boyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:boyButton];
    
    
    
    girlButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2, navH+userImageH+uptel/2,3*telIconW, telIconW)];
    UIImage *girlImage = [UIImage imageNamed:@"picOfGirl.png"];
    UIEdgeInsets insets2 = UIEdgeInsetsMake(0,0,0,0);
    [girlImage resizableImageWithCapInsets:insets2 resizingMode:UIImageResizingModeStretch];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateNormal];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateSelected];
    [girlButton setBackgroundColor:[UIColor yellowColor]];
    
    [girlButton addTarget:self action:@selector(girlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:girlButton];
    
    //创建昵称输入框
    nicknameField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + uptel + userImageH, telW, telH)];
    nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.frame = CGRectMake(0, 0, telIconW, telH);
    nicknameLabel.text=@"昵称";
    nicknameLabel.textAlignment = NSTextAlignmentCenter;
    nicknameLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
    nicknameField.leftView = nicknameLabel;
    nicknameField.leftViewMode = UITextFieldViewModeAlways;
    nicknameField.placeholder = @"请输入您的昵称";
    nicknameField.font = [UIFont systemFontOfSize:(hitFont+0)];
    nicknameField.returnKeyType = UIReturnKeyDone;
    nicknameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameField.keyboardType = UIKeyboardTypeNumberPad;
    nicknameField.delegate = self;
    nicknameField.borderStyle = UITextBorderStyleNone;
    nicknameField.backgroundColor = [UIColor whiteColor];
    [nicknameField.layer setCornerRadius:4];
    
    //创建姓名输入框
    nameField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + 1.5*uptel + userImageH, telW, telH)];
    nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 0, telIconW, telH);
    nameLabel.text=@"姓名";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
    nameField.leftView = nameLabel;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.placeholder = @"请输入您的姓名";
    nameField.font = [UIFont systemFontOfSize:(hitFont+1)];
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.delegate = self;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.backgroundColor = [UIColor whiteColor];
    [nameField.layer setCornerRadius:4];
    
    // 学号
    schoolNumberField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + 2*uptel + userImageH, telW, telH)];
    schoolNumberLabel = [[UILabel alloc] init];
    schoolNumberLabel.frame = CGRectMake(0, 0, telIconW, telH);
    schoolNumberLabel.text=@"学号";
    schoolNumberLabel.textAlignment = NSTextAlignmentCenter;
    schoolNumberLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
    schoolNumberField.leftView = schoolNumberLabel;
    schoolNumberField.leftViewMode = UITextFieldViewModeAlways;
    schoolNumberField.placeholder = @"请输入您的学号";
    schoolNumberField.font = [UIFont systemFontOfSize:(hitFont+1)];
    schoolNumberField.returnKeyType = UIReturnKeyDone;
    schoolNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    schoolNumberField.keyboardType = UIKeyboardTypeNumberPad;
    schoolNumberField.delegate = self;
    schoolNumberField.borderStyle = UITextBorderStyleNone;
    schoolNumberField.backgroundColor = [UIColor whiteColor];
    [schoolNumberField.layer setCornerRadius:4];
    
    
    //学院
    
    collegeField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + 2.5*uptel + userImageH, telW, telH)];
    collegeLabel = [[UILabel alloc] init];
    collegeLabel.frame = CGRectMake(0, 0, telIconW, telH);
    collegeLabel.text=@"学院";
    collegeLabel.textAlignment = NSTextAlignmentCenter;
    collegeLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
    collegeField.leftView = collegeLabel;
    collegeField.leftViewMode = UITextFieldViewModeAlways;
    collegeField.placeholder = @"请输入您的学院";
    collegeField.font = [UIFont systemFontOfSize:(hitFont+1)];
    collegeField.returnKeyType = UIReturnKeyDone;
    collegeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    collegeField.keyboardType = UIKeyboardTypeNumberPad;
    collegeField.delegate = self;
    collegeField.borderStyle = UITextBorderStyleNone;
    collegeField.backgroundColor = [UIColor whiteColor];
    [collegeField.layer setCornerRadius:4];
    //专业
    majorField = [[UITextField alloc]initWithFrame:CGRectMake((userImageW - telW)/2, navH + 3*uptel + userImageH, telW, telH)];
    majorLabel = [[UILabel alloc] init];
    majorLabel.frame = CGRectMake(0, 0, telIconW, telH);
    majorLabel.text=@"专业";
    majorLabel.textAlignment = NSTextAlignmentCenter;
    majorLabel.textColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:170/255.0 alpha:1.0];
    majorField.leftView = majorLabel;
    majorField.leftViewMode = UITextFieldViewModeAlways;
    majorField.placeholder = @"请输入您的专业";
    majorField.font = [UIFont systemFontOfSize:(hitFont+1)];
    majorField.returnKeyType = UIReturnKeyDone;
    majorField.clearButtonMode = UITextFieldViewModeWhileEditing;
    majorField.keyboardType = UIKeyboardTypeNumberPad;
    majorField.delegate = self;
    majorField.borderStyle = UITextBorderStyleNone;
    majorField.backgroundColor = [UIColor whiteColor];
    [majorField.layer setCornerRadius:4];
    
    
    
    //创建登录（注册）按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton.layer setCornerRadius:4];
    loginButton.frame = CGRectMake((userImageW - telW)/2,navH +3.5*uptel + userImageH, telW, telH);
    [loginButton setTitle:@"修改信息" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:22/255.0 green:175/255.0 blue:170/255.0 alpha:1]];
    [loginButton addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:(hitFont+2)];
    
    
    logoffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoffButton.layer setCornerRadius:4];
    logoffButton.frame = CGRectMake((userImageW - telW)/2,navH +4*uptel + userImageH, telW, telH);
    [logoffButton setTitle:@"注销" forState:UIControlStateNormal];
    [logoffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoffButton setBackgroundColor:[UIColor colorWithRed:22/255.0 green:175/255.0 blue:170/255.0 alpha:1]];
    [logoffButton addTarget:self action:@selector(logoffClicked) forControlEvents:UIControlEventTouchUpInside];
    logoffButton.titleLabel.font = [UIFont systemFontOfSize:(hitFont+2)];
    
    
    
    
    
    [scroll addSubview:nameField];
    [scroll addSubview:nameLabel];
    [scroll addSubview:nicknameLabel];
    [scroll addSubview:nicknameField];
    [scroll addSubview:schoolNumberField];
    [scroll addSubview:schoolNumberLabel];
    [scroll addSubview:collegeLabel];
    [scroll addSubview:collegeField];
    [scroll addSubview:majorField];
    [scroll addSubview:majorLabel];

    
    [scroll addSubview:welLabel];
    [scroll addSubview:telField];
    [scroll addSubview:CAPTCHAField];
    [scroll addSubview:CAPTCHAButton];
    [scroll addSubview:loginButton];
    [scroll addSubview:logoffButton];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 *  用户成功登录时执行，改变成已登录状态
 */
//- (void)cancelLoginView{
//    [self.view removeFromSuperview];
//}

-(void)boyButtonClicked{
    
    //上方图像
    //if (FrameH > 319 && FrameH < 321) {
    userImage = [UIImage imageNamed:@"picOfBoyHead.png"];
    //  }else{
    //      userImage = [UIImage imageNamed:@"panda.png"];
    // }
    UIImageView* userImageView = [[UIImageView alloc] initWithImage:userImage];
    userImageView.frame = CGRectMake(userImageW/2-userImageNewW/2, 0, userImageH, userImageH);
    NSLog(@"%d",navH);
    
    [scroll addSubview:userImageView];
    
    boyButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2-3*telIconW, navH+userImageH+uptel/2, 3*telIconW, telIconW)];
    UIImage *boyYesImage = [UIImage imageNamed:@"picOfBoyYes.png"];
    UIEdgeInsets insets1 = UIEdgeInsetsMake(0,0,0,0);
    [boyYesImage resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeStretch];
    [boyButton setBackgroundColor:[UIColor blackColor]];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateNormal];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateSelected];
    //[boyButton addSubview:boyImageView];
    [boyButton addTarget:self action:@selector(boyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:boyButton];
    
    
    
    girlButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2, navH+userImageH+uptel/2,3*telIconW, telIconW)];
    UIImage *girlImage = [UIImage imageNamed:@"picOfGirl.png"];
    UIEdgeInsets insets2 = UIEdgeInsetsMake(0,0,0,0);
    [girlImage resizableImageWithCapInsets:insets2 resizingMode:UIImageResizingModeStretch];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateNormal];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateSelected];
    [girlButton setBackgroundColor:[UIColor yellowColor]];

    [girlButton addTarget:self action:@selector(girlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:girlButton];
   
    sex=@"0";

}

-(void)girlButtonClicked{
    
    //上方图像
    //if (FrameH > 319 && FrameH < 321) {
    userImage = [UIImage imageNamed:@"picOfGirlHead.png"];
    //  }else{
    //      userImage = [UIImage imageNamed:@"panda.png"];
    // }
    UIImageView* userImageView = [[UIImageView alloc] initWithImage:userImage];
    userImageView.frame = CGRectMake(userImageW/2-userImageNewW/2, 0, userImageH, userImageH);
    NSLog(@"%d",navH);
    
    [scroll addSubview:userImageView];
    
    
    boyButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2-3*telIconW, navH+userImageH+uptel/2, 3*telIconW, telIconW)];
    UIImage *boyYesImage = [UIImage imageNamed:@"picOfBoy.png"];
    UIEdgeInsets insets1 = UIEdgeInsetsMake(0,0,0,0);
    [boyYesImage resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeStretch];
    [boyButton setBackgroundColor:[UIColor blackColor]];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateNormal];
    [boyButton setBackgroundImage:boyYesImage forState:UIControlStateSelected];
    //[boyButton addSubview:boyImageView];
    [boyButton addTarget:self action:@selector(boyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:boyButton];
    
    
    
    girlButton = [[UIButton alloc]initWithFrame:CGRectMake(userImageW/2, navH+userImageH+uptel/2,3*telIconW, telIconW)];
    UIImage *girlImage = [UIImage imageNamed:@"picOfGirlYes.png"];
    UIEdgeInsets insets2 = UIEdgeInsetsMake(0,0,0,0);
    [girlImage resizableImageWithCapInsets:insets2 resizingMode:UIImageResizingModeStretch];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateNormal];
    [girlButton setBackgroundImage:girlImage forState:UIControlStateSelected];
    [girlButton setBackgroundColor:[UIColor yellowColor]];
    
    [girlButton addTarget:self action:@selector(girlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:girlButton];
    
    sex = @"1";

    
}

-(void)loginClicked{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确定要修改信息吗" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory =[paths objectAtIndex:0];
        NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
        NSString *tel = [plistDictionary objectForKey:@"tel"];
        NSString *nickname = nicknameField.text;
        NSString *name = nameField.text;
        NSString *major= majorField.text;
        NSString *college = collegeField.text;
        NSString *studentID = schoolNumberField.text;
        if([nickname isEqualToString:@""]||[name isEqualToString:@""]||[major isEqualToString:@""]||[college isEqualToString:@""]||[studentID isEqualToString:@""]){
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请填写完整的信息" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            

            [self presentViewController:alertController animated:YES completion:nil];

            
        }
        
        NSString *checkURL = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/register.php?order=overwrite&nickName=%@&name=%@&major=%@&college=%@&studentID=%@&sex=%@&mobile=%@", nickname,name,major,college,studentID,sex,tel];
        NSMutableURLRequest *checkReq = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:checkURL]];
        [checkReq setHTTPMethod:@"GET"];
        NSLog(@"hhhhhhhhhhhhhurl %@",checkURL);
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

                Singleton *instance = [Singleton getInstance];
                instance.nickname = nickname;
                    [self storeInformationAfterLoginSuccess];
          //          [self performSelectorOnMainThread:@selector(pop) withObject:nil waitUntilDone:NO];
           //     }
                
            //    [self.navigationController popViewControllerAnimated:true];
            }
       
        }];
        [checkDataTask resume];
        
        [self.navigationController popViewControllerAnimated:true];

    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
   
}

- (void)storeInformationAfterLoginSuccess {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
    Singleton *instance = [Singleton getInstance];
    [plistDictionary setObject:instance.nickname forKey:@"login"];
    //[plistDictionary setObject:self.telField.text forKey:@"login"];
    
    NSLog(@"%@", plistDictionary);
    
    [plistDictionary writeToFile:documentPlistPath atomically:YES];
     //[self.navigationController popViewControllerAnimated:true];
}

-(void)logoffClicked{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确定要注销吗" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory =[paths objectAtIndex:0];
        NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
        [plistDictionary removeObjectForKey:@"login"];
        [plistDictionary removeObjectForKey:@"tel"];
        [plistDictionary removeObjectForKey:@"userID"];
        //[plistDictionary setObject:self.telField.text forKey:@"login"];
        NSLog(@"%@", plistDictionary);
        
        [plistDictionary writeToFile:documentPlistPath atomically:YES];
        
        [self.navigationController popViewControllerAnimated:true];
        
    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
@end
