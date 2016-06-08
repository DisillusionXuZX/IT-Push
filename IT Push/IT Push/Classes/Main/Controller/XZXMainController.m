//
//  XZXMainController.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXMainController.h"
#import "XZXMainModel.h"
#import "XZXMainCell.h"
#import "XZXLikeController.h"
#import "XZXContentController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#import "XZXUtil.h"


#import <sqlite3.h>
#import "XZXDBHelper.h"

@interface XZXMainController (){
    sqlite3 *db;
}
@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, assign)BOOL moreData;
@property (nonatomic, weak)UILabel *footer;
@property (nonatomic, assign)BOOL isFooterRefreshing;

@end

@implementation XZXMainController
static NSString * const ID = @"cell";

- (void)setupFooterView{
    UILabel *footer = [[UILabel alloc] init];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor blackColor];
    footer.font = [UIFont systemFontOfSize:12];
    footer.backgroundColor = self.tableView.backgroundColor;
    footer.text = @"没有更多数据";
    footer.XZX_Height = 49;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

- (NSMutableArray *)modelArray{
    if(_modelArray == nil){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XZXBackgroundColor;
    
    self.moreData = YES;
    
    self.isFooterRefreshing = NO;
    
    db = [XZXDBHelper createDatabasePath];
    
    [self setupFooterView];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self sendRequest:1];
    }];
    
    [self sendRequest:0];
    
    
    [self setupNavBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XZXMainCell" bundle:nil] forCellReuseIdentifier:ID];
 
}

- (void)sendRequest:(NSInteger)type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self getURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject;
        if (!(array == nil) && (array.count > 0)) {
            if (type == 1) {
                self.modelArray = [XZXMainModel mj_objectArrayWithKeyValuesArray:responseObject];
            }else{
                [self.modelArray addObjectsFromArray:[XZXMainModel mj_objectArrayWithKeyValuesArray:responseObject]];
            }
            self.footer.text = @"上拉加载更多数据";
            [self.tableView reloadData];
            [self hideHeaderOrFooter:type];
        }else{
            self.footer.text = @"没有更多数据";
            [self hideHeaderOrFooter:type];
        }
        if(self.isFooterRefreshing){
            [self footerEndRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHeaderOrFooter:type];
        if(error.code == NSURLErrorCannotConnectToHost){
            self.footer.text = @"当前无网络!请刷新重试!";
            self.isFooterRefreshing = NO;
            return;
        }else if(error.code == NSPropertyListErrorMinimum){
            self.moreData = NO;
            self.footer.text = @"没有更多数据";
            self.isFooterRefreshing = NO;
            return;
        }
        if(self.isFooterRefreshing){
            [self footerEndRefreshing];
        }
    }];
}

//根据传入的数值判断是隐藏header还是footer
- (void)hideHeaderOrFooter:(NSInteger)type{
    if(type > 0){
        [self.tableView.mj_header endRefreshing];
    }
}


- (NSString *)getURL{
    NSString *str = ArticlePath;
    str = [str stringByAppendingPathComponent:@"01.txt"];
    return str;
}

- (void)setupNavBar{
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navbar_fav_enter_btn~iPhone"] highImage:nil target:self action:@selector(jump)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"IT Express" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [leftItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    leftItem.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)jump{
    [self.navigationController pushViewController:[[XZXLikeController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XZXMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.modelArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.width * 2.0 / 3.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XZXContentController *contentController = [[XZXContentController alloc] init];
    contentController.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:contentController animated:YES];
}

#pragma mark - UITableView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dealWithFooter];
}

- (void)dealWithFooter{
    if(self.modelArray.count == 0) return;
    if(self.isFooterRefreshing) return;
    
    CGFloat contentSizeHeight = self.tableView.contentSize.height;
    CGFloat insetBottom = self.footer.XZX_Height;
    CGFloat height = self.tableView.XZX_Height;
    
    
    CGFloat offsetY = contentSizeHeight + insetBottom - height - 44;
    
    if(self.tableView.contentOffset.y >= offsetY){
        [self footerBeginRefreshing];
    }
}

- (void)footerBeginRefreshing{
    /*因为这里没有更多数据，所以暂时这么写，有更多数据时则按注释内的写
//    if (self.isFooterRefreshing) return;
//    
//    self.isFooterRefreshing = YES;
//    self.footer.text = @"正在加载更多数据";
//    [self sendRequest:-1];
     */
    self.footer.text = @"没有更多数据";
    [self hideHeaderOrFooter:-1];
    
}

- (void)footerEndRefreshing{
    self.isFooterRefreshing = NO;
    self.footer.text = @"上拉加载更多数据";
}

@end
