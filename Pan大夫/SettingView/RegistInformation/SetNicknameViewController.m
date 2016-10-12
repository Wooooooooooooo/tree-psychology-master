//
//  SetNicknameViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 29/09/2016.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "SetNicknameViewController.h"


#import "Masonry.h"

@interface SetNicknameViewController ()

@property (strong, nonatomic) UILabel *requestNicknameLabel;
@property (strong, nonatomic) UITextField *nicknameField;
@property (strong, nonatomic) UIBarButtonItem *submitBarButtonItem;

@property (weak, nonatomic) ConfirmInformationViewController *parentVC;

@end

@implementation SetNicknameViewController

- (instancetype)initWithParentConfirmInformationViewController:(ConfirmInformationViewController *)parentVC {
    self = [super init];
    if (self) {
        self.parentVC = parentVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _requestNicknameLabel = [[UILabel alloc] init];
    _requestNicknameLabel.text = @"请输入您想使用的昵称";
    [self.view addSubview:_requestNicknameLabel];
    [_requestNicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(84);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    _nicknameField = [[UITextField alloc] init];
    _nicknameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_nicknameField];
    [_nicknameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_requestNicknameLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200);
    }];
    
    _submitBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitNickname)];
    self.navigationItem.rightBarButtonItem = _submitBarButtonItem;
}

- (void)submitNickname {
    _parentVC.nickname = _nicknameField.text;
    [self dismissViewControllerAnimated:YES completion:^{
        [_parentVC commitUserInformation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
