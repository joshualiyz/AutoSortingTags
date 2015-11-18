//
//  ViewController.m
//  test
//
//  Created by joshuali on 15/11/17.
//  Copyright © 2015年 aixuehuisi. All rights reserved.
//

#import "ViewController.h"
#import "SwapViewController.h"
#import "OrderViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SwapViewController * swap_vc = [SwapViewController new];
    swap_vc.tabBarItem.title = @"swap";
    OrderViewController * order_vc = [OrderViewController new];
    order_vc.title = @"order";
    self.viewControllers = @[swap_vc, order_vc];
}

@end
