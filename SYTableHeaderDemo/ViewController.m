//
//  ViewController.m
//  SYTableHeaderDemo
//
//  Created by Saucheong Ye on 10/2/15.
//  Copyright © 2015 sauchye.com. All rights reserved.
//

#import "ViewController.h"

static CGFloat const HEADER_HEIGHT = 200.0;
static CGFloat const HEADER_IMAGE_HEIGHT = 80.0;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *headTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *headBackgroundImageView, *headImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
   
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];

    //title
    self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleLbl.textColor=[UIColor whiteColor];
    self.titleLbl.text = @"Sauchye";
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLbl;
    self.titleLbl.alpha = 0;

     [self configView];
}

- (void)configView
{
    self.headTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    //Notice: 先遵循代理,如将代理放到contentInset后将会显示navigationBar,🙈
    self.headTableView.delegate = self;
    self.headTableView.dataSource = self;

    self.headTableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT, 0, 0, 0);
    [self.view addSubview:self.headTableView];
    

    //background
    self.headBackgroundImageView = [UIImageView new];
    self.headBackgroundImageView.frame = CGRectMake(0, - HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT);
    self.headBackgroundImageView.image = [UIImage imageNamed:@"background_head_image"];
    [self.headTableView addSubview:self.headBackgroundImageView];
    

    self.headView = [UIView new];
    self.headView.backgroundColor = [UIColor clearColor];
    self.headView.frame = CGRectMake(0, - HEADER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT);
    [self.headTableView addSubview:self.headView];
    //icon
    self.headImageView = [UIImageView new];
    self.headImageView.frame = CGRectMake((SCREEN_WIDTH - HEADER_IMAGE_HEIGHT)/2, (HEADER_HEIGHT - HEADER_IMAGE_HEIGHT) / 2, HEADER_IMAGE_HEIGHT, HEADER_IMAGE_HEIGHT);
    self.headImageView.image = [UIImage imageNamed:@"icon_head_image"];
    self.headImageView.alpha = 0.7;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height / 2;
    [self.headView addSubview:self.headImageView];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - Button Event
- (void)leftBarClick{
    NSLog(@"leftBarClick");
}

- (void)settingClick{
    NSLog(@"settingClick");
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + HEADER_HEIGHT)/2;
    
    if (yOffset < - HEADER_HEIGHT) {
        
        CGRect rect = self.headBackgroundImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height = -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        
        self.headBackgroundImageView.frame = rect;
    }
    
    CGFloat alpha = (yOffset + HEADER_HEIGHT) / HEADER_HEIGHT;
    
    if (self.edgesForExtendedLayout == UIRectEdgeTop || self.edgesForExtendedLayout == UIRectEdgeAll) {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor darkGrayColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];

    }
    self.titleLbl.alpha=alpha;
//    alpha=fabs(alpha);
//    alpha=fabs(1-alpha);
//    alpha=alpha<0.2? 0:alpha-0.2;
//    self.headView.alpha=alpha;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const indentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    self.headTableView.delegate = nil;
    self.headTableView.dataSource = nil;
}
@end
