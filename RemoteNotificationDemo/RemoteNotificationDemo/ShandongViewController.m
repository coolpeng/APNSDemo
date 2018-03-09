//
//  ShandongViewController.m
//  RemoteNotificationDemo
//
//  Created by Edward on 2018/3/8.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "ShandongViewController.h"
#import "JinanViewController.h"

@interface ShandongViewController ()

@end

@implementation ShandongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    JinanViewController *jinan = [[JinanViewController alloc] init];
    jinan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jinan animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
