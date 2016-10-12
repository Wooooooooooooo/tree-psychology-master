//
//  ComfirmInformationViewController.m
//  Pan大夫
//
//  Created by Tom on 15/9/2.
//  Copyright (c) 2015年 Neil. All rights reserved.
//

#import "ConfirmInformationViewController.h"
#import "ConfirmInformationView.h"
#import "SetNicknameViewController.h"
#import "Singleton.h"
#import "AppDelegate.h"

@interface ConfirmInformationViewController ()<ConfirmInformationViewDelegate>

@property(nonatomic)ConfirmInformationView *confirmInformationView;
@property(strong, nonatomic) NSArray *keyArray;
@property(strong, nonatomic)NSDictionary *infoDictionay;

@end

@implementation ConfirmInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    _confirmInformationView = [[ConfirmInformationView alloc]initWithFrame:self.view.frame InformationDictionary:_infoDictionay];
    _confirmInformationView.delegate = self;
    [self.view addSubview:_confirmInformationView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self refleshData];
}

//初始化试图控制器，通过字典传值
-(id)initWithInformationDictionary:(NSDictionary *)informationDictionary{
    self = [super init];
    if (self) {
        _infoDictionay = [[NSDictionary alloc]initWithDictionary:informationDictionary];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitButtonClicked {
    //NSLog(@"commitButtonClicked");
    SetNicknameViewController *setNicknameVC = [[SetNicknameViewController alloc] initWithParentConfirmInformationViewController:self];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:setNicknameVC] animated:YES completion:nil];
}

- (void)commitUserInformation {
//    NSString *addInformationURL = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/register.php"];
    NSString *paramsString = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/register.php?order=save&mobile=%@&name=%@&sex=%@&college=%@&major=%@&studentID=%@&nickname=%@", [self.phone mk_urlEncodedString], [self.confirmInformationView.nameLabel.text mk_urlEncodedString], [self.confirmInformationView.sexLabel.text mk_urlEncodedString], [self.confirmInformationView.collogeLabel.text mk_urlEncodedString], [self.confirmInformationView.majorLabel.text mk_urlEncodedString], [self.confirmInformationView.IDLabel.text mk_urlEncodedString], [self.nickname mk_urlEncodedString]];
//    NSData *paramsData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"%@", paramsString);
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:paramsString]];
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody:paramsData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
         //   NSLog(@"Httperror: %@ %ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      //      NSLog(@"HttpResponseCode:%ld", responseCode);
     //       NSLog(@"HttpResponseBody %@",responseString);
            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            if ([dic objectForKey:@"succeed"]) {
//                if ((BOOL)[dic objectForKey:@"succeed"] == YES) {
                    [self storeInformationAfterLoginSuccess];
                    [self.navigationController performSelectorOnMainThread:@selector(popToRootViewControllerAnimated:) withObject:@YES waitUntilDone:NO];
//                } else {
//                    [[[UIAlertView alloc] initWithTitle:@"错误" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                    if ([dic objectForKey:@"result"]) {
//                        NSLog(@"%@", [dic objectForKey:@"result"]);
//                    }
//                }
//            } else {
//                NSLog(@"%@", dic);
//                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//            }
        }
    }];
    [dataTask resume];
//    NSLog(@"%@", self.phone);
}

- (void)storeInformationAfterLoginSuccess {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
    Singleton *instance = [Singleton getInstance];
    NSMutableDictionary *dictionary = instance.userDictonary;
 //   NSLog(@"kankan %@",dictionary);
    [plistDictionary setObject:[dictionary objectForKey:@"userID"] forKey:@"userID"];
    [plistDictionary setObject:[dictionary objectForKey:@"nickname"] forKey:@"login"];
  //  NSLog(@"plistdictionary %@", plistDictionary);
    
    [plistDictionary writeToFile:documentPlistPath atomically:YES];
}

- (void)goBackToRoot {
    if (_isRoot) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)refleshData{
    if ([@"男" isEqualToString: [_infoDictionay objectForKey:@"性别"] ]) {
        _confirmInformationView.headImageView.image = [UIImage imageNamed:@"picOfBoyHead"];
    }else{
        _confirmInformationView.headImageView.image = [UIImage imageNamed:@"picOfGirlHead"];
    }
    _keyArray = [[NSArray alloc]initWithObjects:@"姓名", @"性别", @"学号", @"学院", @"专业", nil];
    _confirmInformationView.nameLabel.text = [_infoDictionay objectForKey:@"姓名"];
    _confirmInformationView.sexLabel.text = [_infoDictionay objectForKey:@"性别"];
    _confirmInformationView.IDLabel.text = [_infoDictionay objectForKey:@"学号"];
    _confirmInformationView.collogeLabel.text = [_infoDictionay objectForKey:@"学院"];
    _confirmInformationView.majorLabel.text = [_infoDictionay objectForKey:@"专业"];
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
