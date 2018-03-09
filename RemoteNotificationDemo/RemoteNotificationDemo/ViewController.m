//
//  ViewController.m
//  RemoteNotificationDemo
//
//  Created by Edward on 2018/3/8.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "ViewController.h"
#import "ShiJiazhuangViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ShiJiazhuangViewController *sjz = [[ShiJiazhuangViewController alloc] init];
    sjz.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sjz animated:YES];

}

@end
