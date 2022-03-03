//
//  QRDPureAudioViewController.m
//  QNRTCKitDemo
//
//  Created by hxiongan on 2018/12/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDPureAudioViewController.h"
#import "UIView+Alert.h"
#import <QNRTCKit/QNRTCKit.h>

@interface QRDPureAudioViewController ()

@end

@implementation QRDPureAudioViewController

- (void)dealloc {
    NSLog(@"QRDPureAudioViewController - dealloc!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = QRD_COLOR_RGBA(20, 20, 20, 1);

    // 配置核心类 QNRTCClient
    [self setupClient];
    
    [self setupBottomButtons];
    
    // 发送请求获取进入房间的 Token
    [self requestToken];
    
    self.logButton = [[UIButton alloc] init];
    [self.logButton setImage:[UIImage imageNamed:@"log-btn"] forState:UIControlStateNormal];
    [self.logButton addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logButton];
    [self.view bringSubviewToFront:self.tableView];
    
    [self.logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
        
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logButton);
        make.top.equalTo(self.logButton.mas_bottom);
        make.width.height.equalTo(self.view).multipliedBy(0.6);
    }];
    self.tableView.hidden = YES;
}

- (void)conferenceAction:(UIButton *)conferenceButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stoptimer];
    // 离开房间
    [self.client leave];
    
    [QNRTC deinit];
    [super viewDidDisappear:animated];
}

- (void)setTitle:(NSString *)title {
    if (nil == self.titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        if (@available(iOS 9.0, *)) {
            self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        } else {
            self.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.titleLabel];
    }
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.view.center.x, self.logButton.center.y);
    [self.view bringSubviewToFront:self.titleLabel];
}

- (void)joinRTCRoom {
    [self.view showNormalLoadingWithTip:@"加入房间中..."];
    // 将获取生成的 token 传入 sdk
    // 6.使用有效的 token 加入房间
    [self.client join:self.token];
}

- (void)requestToken {
    [self.view showFullLoadingWithTip:@"请求 token..."];
    __weak typeof(self) wself = self;
    // 获取 Token 必须要有 3个信息
    // 1. roomName 房间名
    // 2. userId 用户名
    // 3. appId id标识（相同的房间、相同的用户名，不同的 appId 将无法进入同一个房间）
    [QRDNetworkUtil requestTokenWithRoomName:self.roomName appId:self.appId userId:self.userId completionHandler:^(NSError *error, NSString *token) {
        
        [wself.view hideFullLoading];
        
        if (error) {
            [wself addLogString:error.description];
            [wself.view showFailTip:error.description];
            wself.title = @"请求 token 出错，请检查网络";
        } else {
            NSString *str = [NSString stringWithFormat:@"获取到 token: %@", token];
            [wself addLogString:str];
            
            wself.token = token;
            // 加入房间
            [wself joinRTCRoom];
        }
    }];
}

- (void)setupClient {
    [QNRTC configRTC:[QNRTCConfiguration defaultConfiguration]];
    // 1.创建初始化 RTC 核心类 QNRTCClient
    self.client = [QNRTC createRTCClient];
    self.client.delegate = self;
    
    [self.renderBackgroundView addSubview:self.colorView];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.renderBackgroundView);
    }];
}


- (void)setupBottomButtons {
    
    self.bottomButtonView = [[UIView alloc] init];
    [self.view addSubview:self.bottomButtonView];
    
    UIButton* buttons[3];
    NSString *selectedImage[] = {
        @"microphone",
        @"close-phone",
        @"loudspeaker",
    };
    NSString *normalImage[] = {
        @"microphone-disable",
        @"close-phone",
        @"loudspeaker-disable",
    };
    SEL selectors[] = {
        @selector(microphoneAction:),
        @selector(conferenceAction:),
        @selector(loudspeakerAction:)
    };
    
    UIView *preView = nil;
    for (int i = 0; i < ARRAY_SIZE(normalImage); i ++) {
        buttons[i] = [[UIButton alloc] init];
        [buttons[i] setImage:[UIImage imageNamed:selectedImage[i]] forState:(UIControlStateSelected)];
        [buttons[i] setImage:[UIImage imageNamed:normalImage[i]] forState:(UIControlStateNormal)];
        [buttons[i] addTarget:self action:selectors[i] forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomButtonView addSubview:buttons[i]];
    }
    int index = 0;
    _microphoneButton = buttons[index ++];
    _conferenceButton = buttons[index ++];
    _speakerButton = buttons[index ++];
    _speakerButton.selected = YES;
    
    CGFloat buttonWidth = 54;
    NSInteger space = (UIScreen.mainScreen.bounds.size.width - buttonWidth * 3)/4;
    
    NSArray *array = [NSArray arrayWithObjects:buttons count:3];
    [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:buttonWidth leadSpacing:space tailSpacing:space];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(buttonWidth);
        make.bottom.equalTo(self.bottomButtonView).offset(-space * 0.8);
    }];
        
    preView = buttons[0];
    [self.bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.top.equalTo(preView.mas_top);
    }];
}

- (void)requestRoomUserList {
    [self.view showFullLoadingWithTip:@"请求房间用户列表..."];
    __weak typeof(self) wself = self;
    
    [QRDNetworkUtil requestRoomUserListWithRoomName:self.roomName appId:self.appId completionHandler:^(NSError *error, NSDictionary *userListDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.view hideFullLoading];
            
            if (error) {
                [wself.view showFailTip:error.description];
                [wself addLogString:@"请求用户列表出错，请检查网络😂"];
            } else {
                [wself dealRoomUsers:userListDic];
            }
        });
    }];
}

- (void)dealRoomUsers:(NSDictionary *)usersDic {
    NSArray * userArray = [usersDic objectForKey:@"users"];
    if (0 == userArray.count) {
        [self.view showTip:@"房间中暂时没有其他用户"];
        [self addLogString:@"房间中暂时没有其他用户"];
    }
}

#pragma mark - 连麦时长计算

- (void)startTimer {
    [self stoptimer];
    self.durationTimer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(timerAction)
                                               userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    self.duration ++;
    NSString *str = [NSString stringWithFormat:@"%02ld:%02ld", self.duration / 60, self.duration % 60];
    self.title = str;
}

- (void)stoptimer {
    if (self.durationTimer) {
        [self.durationTimer invalidate];
        self.durationTimer = nil;
    }
}

- (void)microphoneAction:(UIButton *)microphoneButton {
    self.microphoneButton.selected = !self.microphoneButton.isSelected;
    // 打开/关闭音频
    [self.audioTrack updateMute:!self.microphoneButton.isSelected];
}

- (void)loudspeakerAction:(UIButton *)loudspeakerButton {
    [QNRTC setSpeakerphoneMuted:![QNRTC speakerphoneMuted]];
    loudspeakerButton.selected = ![QNRTC speakerphoneMuted];
}

- (void)logAction:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.selected) {
        if ([self.tableView numberOfRowsInSection:0] != self.logStringArray.count) {
            [self.tableView reloadData];
        }
    }
    self.tableView.hidden = !button.selected;
}

- (void)publish {
    // 初始化音频 Track 配置
    QNMicrophoneAudioTrackConfig *audioTrackConfig = [[QNMicrophoneAudioTrackConfig alloc] initWithTag:microphoneTag bitrate:64];
    self.audioTrack = [QNRTC createMicrophoneAudioTrackWithConfig:audioTrackConfig];
    
    // 纯音频则只发布音频 track
    [self.client publish:@[self.audioTrack] completeCallback:^(BOOL onPublished, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.microphoneButton.enabled = YES;
            self.isAudioPublished = YES;
        });
    }];
}


- (void)showAlertWithMessage:(NSString *)message title:(NSString *)title completionHandler:(void (^)(void))handler
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - QNRTCClientDelegate

/**
 * 房间状态变更的回调。当状态变为 QNConnectionStateReconnecting 时，SDK 会为您自动重连，如果希望退出，直接调用 leave 即可
 */
- (void)RTCClient:(QNRTCClient *)client didConnectionStateChanged:(QNConnectionState)state disconnectedInfo:(QNConnectionDisconnectedInfo *)info {
    [super RTCClient:client didConnectionStateChanged:state disconnectedInfo:info];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hiddenLoading];
        
        if (QNConnectionStateConnected == state || QNConnectionStateReconnected == state) {
            [self startTimer];
        } else {
            [self stoptimer];
        }
        
        if (QNConnectionStateConnected == state) {
            // 获取房间内用户
            [self requestRoomUserList];
            
            [self.view showSuccessTip:@"加入房间成功"];
            self.microphoneButton.selected = YES;
            [self publish];
        } else if (QNConnectionStateIdle == state) {
            switch (info.reason) {
                case QNConnectionDisconnectedReasonKickedOut:{
                    NSString *str = [NSString stringWithFormat:@"你被服务器踢出房间"];
                    
                    dispatch_main_async_safe(^{
                        [self.view showTip:str];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.presentingViewController) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                            } else {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        });
                    });
                }
                    break;
                case QNConnectionDisconnectedReasonLeave:{
                    [self.view showSuccessTip:@"离开房间成功"];
                }
                    break;
                default:{
                    [self.view hiddenLoading];

                    NSString *errorMessage = info.error.localizedDescription;
                    if (info.error.code == QNRTCErrorReconnectTokenError) {
                        errorMessage = @"重新进入房间超时";
                    }
                    [self showAlertWithMessage:errorMessage title:@"错误" completionHandler:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
                    break;
            }
            
        } else if (QNConnectionStateReconnecting == state) {
            [self.view showNormalLoadingWithTip:@"正在重连..."];
            self.title = @"正在重连...";
            self.microphoneButton.enabled = NO;
        } else if (QNConnectionStateReconnected == state) {
            [self.view showSuccessTip:@"重新加入房间成功"];
            self.microphoneButton.enabled = YES;
        }
    });
}

/**
* 远端用户发布音/视频的回调
*/
- (void)RTCClient:(QNRTCClient *)client didUserPublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID {
    [super  RTCClient:client didUserPublishTracks:tracks ofUserID:userID];
}

/**
 * 远端用户取消发布音/视频的回调
 */
- (void)RTCClient:(QNRTCClient *)client didUserUnpublishTracks:(NSArray<QNRemoteTrack *> *)tracks ofUserID:(NSString *)userID{
    [super RTCClient:client didUserUnpublishTracks:tracks ofUserID:userID];
        
    dispatch_main_async_safe(^{
        for (QNRemoteTrack *track in tracks) {
            QRDUserView *userView = [self userViewWithUserId:userID];
            QNRemoteTrack *tempTrack = [userView trackInfoWithTrackId:track.trackID];
            if (tempTrack) {
                [userView.traks removeObject:tempTrack];
                
                if (track.kind == QNTrackKindVideo) {
                    if ([track.tag isEqualToString:screenTag]) {
                        [userView hideScreenView];
                    } else {
                        [userView hideCameraView];
                    }
                } else {
                    [userView setMuteViewHidden:YES];
                }
                
                if (0 == userView.traks.count) {
                    [self removeRenderViewFromSuperView:userView];
                }
            }
        }
    });
}

/**
* 远端用户离开房间的回调
*/
- (void)RTCClient:(QNRTCClient *)client didLeaveOfUserID:(NSString *)userID  {
    [super RTCClient:client didLeaveOfUserID:userID];
}

/**
* 调用 subscribe 订阅 userId 成功后收到的回调
*/
- (void)RTCClient:(QNRTCClient *)client didSubscribedRemoteVideoTracks:(NSArray<QNRemoteVideoTrack *> *)videoTracks audioTracks:(NSArray<QNRemoteAudioTrack *> *)audioTracks ofUserID:(NSString *)userID {
    [super RTCClient:client didSubscribedRemoteVideoTracks:videoTracks audioTracks:audioTracks ofUserID:userID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (QNRemoteVideoTrack *track in videoTracks) {
            QRDUserView *userView = [self userViewWithUserId:userID];
            if (!userView) {
                userView = [self createUserViewWithTrackId:track.trackID userId:userID];
                [self.userViewArray addObject:userView];
                NSLog(@"createRenderViewWithTrackId: %@", track.trackID);
            }
            if (nil == userView.superview) {
                [self addRenderViewToSuperView:userView];
            }
            
            QNRemoteVideoTrack *tempTrack = (QNRemoteVideoTrack *)[userView trackInfoWithTrackId:track.trackID];
            if (tempTrack) {
                [userView.traks removeObject:tempTrack];
            }
            [userView.traks addObject:track];
            track.videoDelegate = self;
            track.remoteDelegate = self;
            if ([track.tag isEqualToString:screenTag]) {
                if (track.muted) {
                    [userView hideScreenView];
                } else {
                    [userView showScreenView];
                }
            } else {
                if (track.muted) {
                    [userView hideCameraView];
                } else {
                    [userView showCameraView];
                }
            }
        }
        
        for (QNRemoteAudioTrack *track in audioTracks) {
            QRDUserView *userView = [self userViewWithUserId:userID];
            if (!userView) {
                userView = [self createUserViewWithTrackId:track.trackID userId:userID];
                [self.userViewArray addObject:userView];
                NSLog(@"createRenderViewWithTrackId: %@", track.trackID);
            }
            if (nil == userView.superview) {
                [self addRenderViewToSuperView:userView];
            }
            
            QNTrack *tempTrack = [userView trackInfoWithTrackId:track.trackID];
            if (tempTrack) {
                [userView.traks removeObject:tempTrack];
            }
            track.remoteDelegate = self;
            track.audioDelegate = self;
            [userView.traks addObject:track];
            [userView setMuteViewHidden:NO];
            [userView setAudioMute:track.muted];
        }
    });
}

/**
 * 远端用户视频首帧解码后的回调，如果需要渲染，则需要返回一个带 renderView 的 QNVideoRender 对象
 */
- (void)RTCClient:(QNRTCClient *)client firstVideoDidDecodeOfTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    [super RTCClient:client firstVideoDidDecodeOfTrack:videoTrack remoteUserID:userID];
    
    QRDUserView *userView = [self userViewWithUserId:userID];
    if (!userView) {
        [self.view showFailTip:@"逻辑错误了 firstVideoDidDecodeOfRemoteUserId 中没有获取到 VideoView"];
    }
    
    userView.contentMode = UIViewContentModeScaleAspectFit;
    QNTrack *track = [userView trackInfoWithTrackId:videoTrack.trackID];
    
    QNVideoView * renderView =  [track.tag isEqualToString:screenTag] ? userView.screenView : userView.cameraView;
    [videoTrack play:renderView];
}

/**
 * 远端用户视频取消渲染到 renderView 上的回调
 */
- (void)RTCClient:(QNRTCClient *)client didDetachRenderTrack:(QNRemoteVideoTrack *)videoTrack remoteUserID:(NSString *)userID {
    [super RTCClient:client didDetachRenderTrack:videoTrack remoteUserID:userID];
    
    QRDUserView *userView = [self userViewWithUserId:userID];
    if (userView) {
        QNRemoteVideoTrack *trackInfo = [userView trackInfoWithTrackId:videoTrack.trackID];
        if ([videoTrack.tag isEqualToString:screenTag]) {
            [userView hideScreenView];
        } else {
            [userView hideCameraView];
        }
    }
    [videoTrack play:nil];
}

/**
* 远端用户发生重连
*/
- (void)RTCClient:(QNRTCClient *)client didReconnectingOfUserID:(NSString *)userID {
    [super RTCClient:client didReconnectingOfUserID:userID];
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.view showSuccessTip:[NSString stringWithFormat:@"远端用户 %@，发生了重连！", userID]];
   });
}

/**
* 远端用户重连成功
*/
- (void)RTCClient:(QNRTCClient *)client didReconnectedOfUserID:(NSString *)userID {
    [super RTCClient:client didReconnectedOfUserID:userID];
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.view showSuccessTip:[NSString stringWithFormat:@"远端用户 %@，重连成功了！", userID]];
   });
}

#pragma mark QNRemoteTrackDelegate

/**
 * 远端用户 Track 状态变更为 muted 的回调
 */
- (void)remoteTrack:(QNRemoteTrack *)remoteTrack didMutedByRemoteUserID:(NSString *)userID {
    [super remoteTrack:remoteTrack didMutedByRemoteUserID:userID];
    if (QNTrackKindVideo == remoteTrack.kind) {
        QRDUserView *userView = [self userViewWithUserId:userID];
        QNRemoteTrack *track = [userView trackInfoWithTrackId:remoteTrack.trackID];
        if ([track.tag isEqualToString:screenTag]) {
            if (track.muted) {
                [userView hideScreenView];
            } else {
                [userView showScreenView];
            }
        } else {
            if (track.muted) {
                [userView hideCameraView];
            } else {
                [userView showCameraView];
            }
        }
    }else {
        QRDUserView *userView = [self userViewWithUserId:userID];
        [userView setAudioMute:remoteTrack.muted];
    }
}

@end
