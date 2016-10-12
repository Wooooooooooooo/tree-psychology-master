//
//  SMSAuthTableViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 5/17/16.
//  Copyright © 2016 Neil. All rights reserved.
//

// 00000

#import "SMSAuthTableViewController.h"

@interface SMSAuthTableViewController ()

@property (strong, nonatomic) UITableViewCell *enterMobileNumberCell;
@property (strong, nonatomic) UITextField *mobileNumberField;
@property (strong, nonatomic) UITableViewCell *captchaCell;
@property (strong, nonatomic) UITextField *captchaInput;
@property (strong, nonatomic) UIButton *captchaEnsureButton;

@property (atomic, copy) NSString *captcha;

@end

@implementation SMSAuthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"短信验证";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.enterMobileNumberCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.mobileNumberField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    self.mobileNumberField.placeholder = @"手机号码";
    [self.enterMobileNumberCell.contentView addSubview:_mobileNumberField];
    UIButton *getCaptchaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [getCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:12];
    getCaptchaButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10, 70, 20);
    [getCaptchaButton addTarget:self action:@selector(getCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.enterMobileNumberCell.contentView addSubview:getCaptchaButton];
    
    self.captchaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.captchaInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    self.captchaInput.placeholder = @"获取到的验证码";
    [self.captchaCell.contentView addSubview:_captchaInput];
    
    self.captchaEnsureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.captchaEnsureButton.frame = CGRectMake(10, 10, 40, 20);
    self.captchaEnsureButton.tintColor = [UIColor blueColor];
    [self.captchaEnsureButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.captchaEnsureButton addTarget:self action:@selector(ensureCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_captchaEnsureButton];
    
    // 仅供调试用
//    self.captcha = @"000000";
    
    //
    int r = arc4random() % 1000000;
    self.captcha = [NSString stringWithFormat:@"%d", r];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCaptcha {
    NSLog(@"getCaptcha called");
    NSString *mobileNumber = self.mobileNumberField.text;
    NSLog(@"%@", mobileNumber);
    if (self.mobileNumberField.text.length != 11) {
        NSLog(@"%lu", self.mobileNumberField.text.length);
        return;
    }
    // TODO: 手机号正则表达式
    
    NSString *getCaptchaURL = [NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Student/PhoneVerify.php?phone=%@&code=%@", self.mobileNumberField.text, self.captcha];
    
    
    // @Deprecated
//    NSString *getCaptchaURL = [NSString stringWithFormat:@"http://sms.bechtech.cn/Api/send/data/json?accesskey=xxx&secretkey=yyy&mobile=%@&content=YourCaptchaIs000000", self.mobileNumberField.text];
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
        }
    }];
    [dataTask resume];
    NSLog(@"V code sent");
}

- (void)ensureCaptcha {
    if ([self.captchaInput.text isEqualToString:self.captcha]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"%@", self.captcha);
    } else {
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"验证码不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            return self.enterMobileNumberCell;
//            break;
        case 1:
            return self.captchaCell;
        default:
            return [[UITableViewCell alloc] init];
    }
    
    // Configure the cell...
    
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
