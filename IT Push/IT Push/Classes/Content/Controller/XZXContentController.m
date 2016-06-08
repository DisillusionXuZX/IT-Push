//
//  XZXContentController.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXContentController.h"
#import "XZXDBHelper.h"
#import <WebKit/WebKit.h>
#import <AFNetworking/AFNetworking.h>
#import "XZXMainModel.h"

@interface XZXContentController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (assign, nonatomic)sqlite3 *db;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign)CGFloat offsetY;


@property (nonatomic, copy)NSString *date;

@property (weak, nonatomic)WKWebView *webView;
@end

@implementation XZXContentController
- (IBAction)collectBtnClick:(id)sender {
    if(self.collectBtn.selected){
        [XZXDBHelper deleteValue:self.model withDB:self.db];
        self.collectBtn.selected = NO;
    }else{
        [XZXDBHelper insertValueWithModel:self.model withDB:self.db];
        self.collectBtn.selected = YES;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = [XZXDBHelper createDatabasePath];
    self.offsetY = 0;
    
    if ([XZXDBHelper ifExistModel:self.model withDB:self.db]) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }
    self.view.backgroundColor = XZXBackgroundColor;
    
    [self setupNavBar];
    
    [self setupWebView];
    
    [self openHTML];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.webView.scrollView.delegate = nil;
}

- (void)setupWebView{
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = CGRectMake(0, 0, XZXScreenW, XZXScreenH);
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;
    //打开左滑返回功能
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    //设置代理
    self.webView.scrollView.delegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view insertSubview:webView atIndex:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        [self.progressView setAlpha:1.0];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f){
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
}

- (void)openHTML{
    NSURL *url = [NSURL URLWithString:[ArticlePath stringByAppendingPathComponent:self.model.articleURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbar_back_btn_old~iPhone"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:backButton.bounds];
    [view addSubview:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.title = @"文章";
    
}

- (void)jump{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark WebView的ScrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat y = offsetY - self.offsetY;
    self.offsetY = offsetY;
    if(y < 0 || offsetY <= -44){
        [self.navigationController.navigationBar setAlpha:1.0];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }else if(offsetY <= 0 && offsetY >= -44){
        [self.navigationController.navigationBar setAlpha:(CGFloat)( -offsetY / 44)];
    }else{
        [self.navigationController.navigationBar setAlpha:0.0];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
    }
}


@end
