//
//  QRDJoinRoomView.m
//  QNRTCKitDemo
//
//  Created by 冯文秀 on 2018/1/16.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDJoinRoomView.h"

@implementation QRDJoinRoomView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initJoinRoomView];
    }
    return self;
}

- (void)initJoinRoomView {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    UIView *roomBackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, viewWidth - 10, 40)];
    roomBackView.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    roomBackView.layer.cornerRadius = 20;
    [self addSubview:roomBackView];
    
    self.roomTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, viewWidth - 50, 40)];
    self.roomTextField.backgroundColor = QRD_COLOR_RGBA(73,73,75,1);
    self.roomTextField.placeholder = @"房间名称";
    self.roomTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.roomTextField.attributedPlaceholder];
    [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [placeholderAttributedString length])];
    [placeholderAttributedString addAttribute:NSFontAttributeName value:QRD_LIGHT_FONT(11) range:NSMakeRange(0, [placeholderAttributedString length])];
    self.roomTextField.attributedPlaceholder = placeholderAttributedString;
    self.roomTextField.textAlignment = NSTextAlignmentLeft;
    self.roomTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.roomTextField.font = QRD_REGULAR_FONT(13);
    self.roomTextField.textColor = [UIColor whiteColor];
    [roomBackView addSubview:_roomTextField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, viewWidth - 50, 54)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.numberOfLines = 0;
    hintLabel.text = @"如果没有该房间，则会自动创建，房间名仅支持 3 ~ 64 位字母、数字、_ 和 - 的组合";
    hintLabel.font = QRD_LIGHT_FONT(10);
    [self addSubview:hintLabel];
        
    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinButton.frame = CGRectMake(5, 110, viewWidth - 10, 40);
    self.joinButton.backgroundColor = QRD_COLOR_RGBA(52,170,220,1);
    self.joinButton.layer.cornerRadius = 20;
    self.joinButton.titleLabel.font = QRD_REGULAR_FONT(14);
    [self.joinButton setTitle:@"进入会议" forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_joinButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
