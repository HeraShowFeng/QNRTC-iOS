# iOS 纯音频连麦

## 1.具体流程参见 Example/QNRTCKitDemo/QRDPureAudioViewController.m

## 2.本地音频采集配置说明

本地音频采集 Track，示例代码如下：

```objc
QNMicrophoneAudioTrackConfig *audioTrackConfig = [[QNMicrophoneAudioTrackConfig alloc] initWithTag:microphoneTag bitrate:64];
self.audioTrack = [QNRTC createMicrophoneAudioTrackWithConfig:audioTrackConfig];
```

**注意：iOS 端本地音频采集 Track 仅支持配置音频码率，暂不支持采样率、声道数以及位宽的自定义配置。默认音频参数：48KHz、单声道、16bit、64kbps。**

自定义码率配置，可参考 [QNMicrophoneAudioTrackConfig](https://developer.qiniu.com/rtc/8837/QNMicrophoneAudioTrackConfig-iOS)



