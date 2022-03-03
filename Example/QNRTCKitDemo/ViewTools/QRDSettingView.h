//
//  QRDSettingView.h
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/17.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRDSettingView : UIView

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *appIdTextField;
@property (nonatomic, strong) UIButton *saveButton;

- (instancetype)initWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText appIdText:(NSString *)appIdText;

@end
