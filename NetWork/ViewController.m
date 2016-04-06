//
//  ViewController.m
//  NetWork
//
//  Created by qqqq on 15/12/15.
//  Copyright © 2015年 董永飞. All rights reserved.
//

#import "ViewController.h"
#import "DFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[DFNetworking defaultManager] getDataWithUrlStr:@"http://ic.snssdk.com/neihan/stream/category/data/v3/" parameter:@{@"category_id":@"126",@"count":@"20",@"min_time":@"-1",@"iid":@"3185796162"} Succeed:^(id responseObject) {
//        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic);
//    } Faile:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
//    [[DFNetworking defaultManager] postDataWithUrlStr:@"http://apis.baidu.com/showapi_open_bus/weixin/weixin_num_list" parameter:nil Succeed:^(id responseObject) {
//        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic);
//    } Faile:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    NSString *urlstr = @"http://i.snssdk.com/neihan/video/playback/?video_id=397a1681884c415ab58c009313f13528&quality=720p&line=0&is_gif=0";
//    [[DFNetworking defaultManager] downloadDataWithUrlStr:@"http://v7.pstatp.com/ed8b1e2695fc76f77d3e58eda623a447/5670d699/origin/4236/3464131821" parameter:nil Succeed:^{
//        NSLog(@"成功");
//    } Faile:^(NSError *error) {
//        
//    }];
//    DFNetworking *ss = [[DFNetworking alloc] init];
//    NSLog(@"%@",ss);
//    NSLog(@"%@",[DFNetworking defaultManager]);
//    [[DFNetworking defaultManager] downloadDataWithUrlStr:@"http://v7.pstatp.com/ed8b1e2695fc76f77d3e58eda623a447/5670d699/origin/4236/3464131821" parameter:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
