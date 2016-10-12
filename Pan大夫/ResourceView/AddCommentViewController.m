//
//  AddCommentViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "AddCommentViewController.h"
#import "Singleton.h"

@interface AddCommentViewController ()

@property (nonatomic) NSString *articleId;
@property (nonatomic) NSString *userId;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation AddCommentViewController

- (instancetype)initWithArticleId:(NSString *)articleId userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _articleId = articleId;
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加评论";
    
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.editable = YES;
    _textView.font = [UIFont fontWithName:@"Arial" size:25];
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型

    [self.view addSubview:_textView];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _submitButton.frame = CGRectMake(0, 0, 34, 17);
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_submitButton setTitle:@"OK" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(addCommentClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_submitButton];
    
    [_textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitComment {
    NSString *commentText = _textView.text;
    NSString *bodyStr = [NSString stringWithFormat:@"articleId=%@&userId=%@&content=%@", _articleId, _userId, [commentText mk_urlEncodedString]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/Comment/addComment.php?%@", bodyStr]]];
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
       //     NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      //      NSLog(@"HttpResponseCode:%ld", responseCode);
      //      NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
       //         NSLog(@"%@", [dic objectForKey:@"error"]);
                return;
            }
            if (!(BOOL)[dic objectForKey:@"Succeed"]) {
                [[[UIAlertView alloc] initWithTitle:@"操作失败" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return;
            }
            [self performSelectorOnMainThread:@selector(goBack) withObject:nil waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addCommentClicked{
    
    if([_textView.text isEqualToString:@""]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请填写评论内容" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }else{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确定要发表评论吗" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory =[paths objectAtIndex:0];
        NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
        NSString *text = _textView.text;
        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];//plist 文件
        NSString *checkURL = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/getcom.php?id=%@&userID=%@&comment=%@",_articleId,[plistDictionary objectForKey:@"userID"],text];
        NSLog(@"asdasdasdasdasdasdasdasd %@",checkURL);
        NSMutableURLRequest *checkReq = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:checkURL]];
        [checkReq setHTTPMethod:@"GET"];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"发表评论成功" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            [self.navigationController popViewControllerAnimated:true];
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        NSURLSessionDataTask *checkDataTask = [session dataTaskWithRequest:checkReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
       //         NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络连接异常" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                //            [self.navigationController popViewControllerAnimated:YES];
                [self performSelectorOnMainThread:@selector(pop) withObject:nil waitUntilDone:NO];
            } else {
             //   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"字符串时你吗好呀 %@",responseString);
           //   NSMutableDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if ([responseString isEqualToString:@"1"]) {
               //     [self performSelectorOnMainThread:@selector(goAddPersonalInformation) withObject:nil waitUntilDone:NO];
                    /*
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"发表评论成功" message:[NSString stringWithFormat:@""] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                        
                        [self.navigationController popViewControllerAnimated:true];
                        
                    }];
                    [alertController addAction:okAction];
                     [self presentViewController:alertController animated:YES completion:nil];
                         [checkDataTask resume];
                     */
                } else {
                    
                    
                   
                }
           //     NSLog(@"%@", JSONDic);
                [self.navigationController popViewControllerAnimated:true];
            }
        }];

        
    }];
        [alertController addAction:cancelAction];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)pop{
    [self.navigationController popViewControllerAnimated:true];
}
@end
