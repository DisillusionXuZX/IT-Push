//
//  XZXMainNavController.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXMainNavController.h"

@interface XZXMainNavController ()

@end

@implementation XZXMainNavController



+ (void)load{
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    [bar setBarTintColor:XZXOriginalColor];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    bar.titleTextAttributes = attr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
