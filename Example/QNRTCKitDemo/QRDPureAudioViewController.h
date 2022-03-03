//
//  QRDPureAudioViewController.h
//  QNRTCKitDemo
//
//  Created by hxiongan on 2018/12/18.
//  Copyright © 2018年 PILI. All rights reserved.
//

#import "QRDBaseViewController.h"

static NSString *cameraTag = @"camera";
static NSString *screenTag = @"screen";

static NSString *microphoneTag = @"microphone";

@interface QRDPureAudioViewController : QRDBaseViewController

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) UIView *bottomButtonView;
@property (nonatomic, strong) UIButton *microphoneButton;
@property (nonatomic, strong) UIButton *speakerButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *logButton;

@property (nonatomic, assign) BOOL isAudioPublished;


@end
