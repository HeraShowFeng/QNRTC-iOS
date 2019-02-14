//
//  QRDNetworkUtil.m
//  QNRTCTestDemo
//
//  Created by hxiongan on 2018/8/16.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QRDNetworkUtil.h"

@implementation QRDNetworkUtil

+ (void)requestTokenWithRoomName:(NSString *)roomName
                           appId:(NSString *)appId
                          userId:(NSString *)userId
               completionHandler:(void (^)(NSError *, NSString *))completionHandler {


#warning 此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
    /*
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     此处服务器 URL 仅用于 Demo 测试，随时可能修改/失效，请勿用于 App 线上环境！！
     */
    NSURL *requestUrl = [NSURL URLWithString:@"https://live.youinsh.com/api/webrtc/room_token/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dataDic = @{@"room_id":roomName,@"username":userId};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:bodyData];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if (error || resp.statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *tokenDic = resultDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, tokenDic[@"room_token"]);
        });
    }];
    [task resume];
}

+ (void)requestRoomUserListWithRoomName:(NSString *)roomName appId:(NSString *)appId completionHandler:(void (^)(NSError *, NSDictionary *))completionHandler {
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api-demo.qnsdk.com/v1/rtc/users/app/%@/room/%@", appId, roomName]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error, nil);
            });
            return;
        }
        
        NSDictionary * userListDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, userListDic);
        });
    }];
    [task resume];
}
@end
