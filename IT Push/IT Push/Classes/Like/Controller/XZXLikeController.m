//
//  XZXLikeController.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXLikeController.h"
#import "XZXMainCell.h"
#import "XZXMainModel.h"
#import "XZXDBHelper.h"
#import <MJRefresh/MJRefresh.h>

static NSString * const ID = @"cell";

@interface XZXLikeController()
@property (nonatomic, assign)sqlite3 *db;
@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)BOOL moreData;
@end

@implementation XZXLikeController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (NSMutableArray *)modelArray{
    if(_modelArray == nil){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.page = 0;
    self.db = [XZXDBHelper createDatabasePath];
    self.modelArray = [XZXDBHelper selectValue:self.db withPage:self.page];
    [self.tableView reloadData];
    self.moreData = [self ifMoreData:self.modelArray];
    
    
    self.view.backgroundColor = XZXBackgroundColor;
    [self setupNavBar];
    
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        self.modelArray = [XZXDBHelper selectValue:self.db withPage:self.page];
        self.moreData = [self ifMoreData:self.modelArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(self.moreData == NO){
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self.modelArray addObjectsFromArray:[XZXDBHelper selectValue:self.db withPage:self.page]];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XZXMainCell" bundle:nil] forCellReuseIdentifier:ID];
    
}

- (BOOL)ifMoreData:(NSMutableArray *)array;{
    return !(array.count < likeCountPerPage);
}


- (void)setupNavBar{
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navbar_fav_icon~iPhone"] highImage:nil target:nil action:nil];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nb_alert_failure_icon"] highImage:nil target:self action:@selector(back)];
    
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XZXMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPress];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.width * 2.0 / 3.0;
}

#pragma mark UITableViewCell长按的调用方法

- (void)cellLongPress:(UILongPressGestureRecognizer *)longPress{
    CGPoint point = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    XZXMainModel *model = self.modelArray[indexPath.row];
    [self presentViewController:[self setupUIAlertController:model] animated:YES completion:^{
        
    }];
}

- (UIAlertController *)setupUIAlertController:(XZXMainModel *)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [XZXDBHelper deleteValue:model withDB:self.db];
        [self.modelArray removeObject:model];
        [self.tableView reloadData];
    }];
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:delete];
    [alertController addAction:back];
    return alertController;
}

@end
