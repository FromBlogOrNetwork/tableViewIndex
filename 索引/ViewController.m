//
//  ViewController.m
//  索引
//
//  Created by 欧家俊 on 16/12/21.
//  Copyright © 2016年 欧家俊. All rights reserved.
//

#import "ViewController.h"
#import "JJTableViewIndexView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    JJTableViewIndexView * JJView;
    UITableView * _tableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    //创建索引栏视图
    [self creatJJView];
}

-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
}
-(void)creatJJView
{
    //添加图片字符串数组
    NSArray * arr
    =@[@"d_aini",@"d_aoteman",@"d_baibai",@"d_beishang",@"d_bishi",@"d_bizui",@"d_chanzui",@"d_chijing",@"d_dahaqi",@"d_dalian",@"d_ding",@"d_ding"];
    //实例化
    JJView = [[JJTableViewIndexView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 100, 40, [UIScreen mainScreen].bounds.size.height - 140) imageNameArray:arr];
    //添加到控制器
    [self.view addSubview:JJView];
    //实现回调,联动
    [JJView selectIndexBlock:^(NSInteger section)
     {
         [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
     }];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    unichar ch = 65 + section;
    NSString * str = [NSString stringWithUTF8String:(char *)&ch];
    return str;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}


@end
