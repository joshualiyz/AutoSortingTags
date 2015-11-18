//
//  OrderViewController.m
//  AutoSortingTags
//
//  Created by joshuali on 15/11/17.
//  Copyright © 2015年 joshuali. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderingTagsView.h"

@interface OrderViewController ()
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    OrderingTagsView * tagsView = [[OrderingTagsView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 200)];
    [tagsView configView];
    [self.view addSubview:tagsView];
}

@end
