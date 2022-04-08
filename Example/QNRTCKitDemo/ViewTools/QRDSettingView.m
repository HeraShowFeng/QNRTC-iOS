//
//  QRDSettingView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDSettingView.h"

@interface QRDSettingView ()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *appIdText;
@property (nonatomic, assign) BOOL redundantEnable;
@end

@implementation QRDSettingView

- (id)initWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText appIdText:(NSString *)appIdText redundantEnable:(BOOL)redundantEnable {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _viewWidth = CGRectGetWidth(frame);
        _placeholderText = placeholderText;
        _appIdText = appIdText;
        _redundantEnable = redundantEnable;
        [self initSettingView];
    }
    return self;
}

- (void)initSettingView {
    UIView *roomBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, _viewWidth - 10, 40)];
    roomBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    roomBackView.layer.cornerRadius = 20;
    [self addSubview:roomBackView];
    
    UILabel *userHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    userHintLabel.textColor = [UIColor whiteColor];
    userHintLabel.font = QRD_LIGHT_FONT(12);
    userHintLabel.textAlignment = NSTextAlignmentLeft;
    userHintLabel.text = @"昵称";
    [roomBackView addSubview:userHintLabel];
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _viewWidth - 110, 40)];
    self.userTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userTextField.textAlignment = NSTextAlignmentLeft;
    self.userTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.userTextField.font = QRD_REGULAR_FONT(13);
    self.userTextField.textColor = [UIColor whiteColor];
    self.userTextField.text = _placeholderText;

    [roomBackView addSubview:_userTextField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, _viewWidth - 50, 27)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.text = @"仅支持 3 ~ 64 位字母、数字、_ 和 - 的组合";
    hintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:hintLabel];
        
    //Appid
    UIView *appIdBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 84, _viewWidth - 10, 40)];
    appIdBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    appIdBackView.layer.cornerRadius = 20;
    [self addSubview:appIdBackView];
    
    UILabel *appIdHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    appIdHintLabel.textColor = [UIColor whiteColor];
    appIdHintLabel.font = QRD_LIGHT_FONT(12);
    appIdHintLabel.textAlignment = NSTextAlignmentLeft;
    appIdHintLabel.text = @"AppID";
    appIdHintLabel.backgroundColor =QRD_COLOR_RGBA(73,73,75,1);
    [appIdBackView addSubview:appIdHintLabel];
    
    self.appIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _viewWidth - 110, 40)];
    self.appIdTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.appIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.appIdTextField.textAlignment = NSTextAlignmentLeft;
    self.appIdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.appIdTextField.font = QRD_REGULAR_FONT(13);
    self.appIdTextField.textColor = [UIColor whiteColor];
    self.appIdTextField.text = _appIdText;
    
    [appIdBackView addSubview:_appIdTextField];
    
    UILabel *idHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 124, _viewWidth - 50, 27)];
    idHintLabel.textColor = [UIColor whiteColor];
    idHintLabel.text = @"请输入您的企业专用AppID";
    idHintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:idHintLabel];
    
    UILabel *redundantLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 164, 40, 40)];
    redundantLabel.textColor = [UIColor grayColor];
    redundantLabel.font = [UIFont systemFontOfSize:12];
    redundantLabel.text = @"RED";
    [redundantLabel sizeToFit];
    [self addSubview:redundantLabel];
    
    self.redundantSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(60, 164, 60, 40)];
    [self.redundantSwitch sizeToFit];
    [self addSubview:_redundantSwitch];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 180, _viewWidth - 10, 40)];
    self.saveButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_saveButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
