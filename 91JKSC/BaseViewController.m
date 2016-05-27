//
//  BaseViewController.m
//  model
//
//  Created by 商城 阜新 on 16/1/4.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "Common.h"
#import "MyNavigationBar.h"
#import "MyNavigationItem.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createTableView];
    self.navigationController.navigationBarHidden = YES;
    self.fd_prefersNavigationBarHidden = YES;
}

-(void)createNavWithLeftImage:(NSString *)leftImageName andRightImage:(NSArray *)rightImageName andTitleView:(UIView *)titleView andTitle:(NSString *)title andSEL:(SEL)sel{
   
    MyNavigationItem * leftItem = [[MyNavigationItem alloc]init];
    
    leftItem.imageName = leftImageName;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<rightImageName.count; i++) {
        
        MyNavigationItem *rightItem = [[MyNavigationItem alloc]init];
        rightItem.imageName = [rightImageName objectAtIndex:i];

        [arr addObject:rightItem];

    }
    
   
    MyNavigationBar *navBar = [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    [navBar createMyNavigationBarWithImageName:nil andTitle:title andLeftItems:@[leftItem] andRightItems:arr andTitleView:titleView andClass:self andSEL:sel andColor:[UIColor colorWithRed:0.01f green:0.48f blue:0.22f alpha:1.00f]];
    [self.view addSubview:navBar];
}
-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

-(NSMutableArray *)dataArr
{
    static NSMutableArray * dataArr;
    if (dataArr == nil) {
        dataArr = [[NSMutableArray alloc]init];
    }
    return dataArr;
}




@end
