//
//  AddEvaluateViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AddEvaluateViewController.h"
#import "AddEvaluateCell.h"
#import "GoodsModel.h"
#import "EvaluateStarCell.h"
#import "EvaluateTitleCell.h"
#import "EveryOrderViewController.h"
#import "EvaluateModel.h"
@interface AddEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *evaluateTableV;
@property (nonatomic,strong)NSMutableArray *goodsArr;
@property (nonatomic,strong)NSMutableArray *evaluateArr;
@property (nonatomic,strong)NSDictionary *infoDict;
@end

@implementation AddEvaluateViewController
-(void)viewWillAppear:(BOOL)animated{
    [self loadDataWithOrderid];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    [self createTableView];
    
    _goodsArr = [[NSMutableArray alloc]init];
    _evaluateArr = [[NSMutableArray alloc]init];

    for (NSDictionary *dict  in self.extend_order_goods) {
        GoodsModel *model = [[GoodsModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [_goodsArr addObject:model];
    }

    [self hideEmptySeparators:self.evaluateTableV];

}
-(NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [[NSMutableArray alloc]init];
    }
    return _goodsArr;
}
-(NSMutableArray *)evaluateArr{
    if (!_evaluateArr) {
        _evaluateArr = [[NSMutableArray alloc]init];
        
    }
    return _evaluateArr;
}
-(NSDictionary *)infoDict
{
    if (!_infoDict) {
        _infoDict = [[NSDictionary alloc]init];
        
    }
    return _infoDict;
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"评价晒单";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView{
    
    self.evaluateTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStyleGrouped];
    self.evaluateTableV.dataSource = self;
    self.evaluateTableV.delegate = self;
    self.evaluateTableV.layer.cornerRadius = 10;
    self.evaluateTableV.layer.masksToBounds = YES;
    self.evaluateTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.evaluateTableV registerClass:[AddEvaluateCell class] forCellReuseIdentifier:@"AddEvaluateCell"];
    [self.evaluateTableV registerClass:[EvaluateStarCell class] forCellReuseIdentifier:@"EvaluateStarCell"];
    [self.evaluateTableV registerClass:[EvaluateTitleCell class] forCellReuseIdentifier:@"EvaluateTitleCell"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.evaluateTableV setSeparatorInset:(UIEdgeInsetsMake(0,4, 0, 0))];
    }

    [self.view addSubview:self.evaluateTableV];
    
}
-(void)hideEmptySeparators:(UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }else{
        return [self.extend_order_goods count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 82;
    }else{
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 230;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[AddEvaluateCell class]]) {
        // 下面这几行代码是用来设置cell的上下行线的位置
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
        if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.evaluateTableV) {
            // 圆角弧度半径
            

            CGFloat cornerRadius = 5.f;
            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
            cell.backgroundColor = UIColor.clearColor;
            
            // 创建一个shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
            CGMutablePathRef pathRef = CGPathCreateMutable();
            // 获取cell的size
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            // CGRectGetMinY：返回对象顶点坐标
            // CGRectGetMaxY：返回对象底点坐标
            // CGRectGetMinX：返回对象左边缘坐标
            // CGRectGetMaxX：返回对象右边缘坐标
            
            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
            BOOL addLine = NO;
            
            if ([tableView numberOfRowsInSection:indexPath.section]-1 == 0) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                addLine = NO;
            }else if (indexPath.row == 0 ) {
                // 初始起点为cell的左下角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
             }else  if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                // 初始起点为cell的左上角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
            layer.path = pathRef;
            backgroundLayer.path = pathRef;
            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
            CFRelease(pathRef);
            // 按照shape layer的path填充颜色，类似于渲染render
            // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.fillColor = [UIColor whiteColor].CGColor;
            // 添加分隔线图层
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                // 分隔线颜色取自于原来tableview的分隔线颜色
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            // view大小与cell一致
            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
            // 添加自定义圆角后的图层到roundView中
            [roundView.layer insertSublayer:layer atIndex:0];
            roundView.backgroundColor = UIColor.clearColor;
            //cell的背景view
            //cell.selectedBackgroundView = roundView;
            cell.backgroundView = roundView;
            
            //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
            backgroundLayer.fillColor = tableView.separatorColor.CGColor;
            [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
            selectedBackgroundView.backgroundColor = UIColor.clearColor;
            cell.selectedBackgroundView = selectedBackgroundView;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellID = @"AddEvaluateCell";
        AddEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        [cell giveCellWithDict:self.infoDict[@"order_goods"][indexPath.row]];
        cell.evaluateBtn.tag = indexPath.row;
        [cell.evaluateBtn addTarget:self action:@selector(addEvaluate:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            NSString *cellID = @"EvaluateTitleCell";
            EvaluateTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            [cell giveCellWithDict:self.infoDict];
            return cell;
        }else{
            NSString *cellID = @"EvaluateStarCell";
            EvaluateStarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            [cell giveCellWithDict:self.infoDict];
            cell.orderId = [NSNumber numberWithLongLong:[_order_id longLongValue]];
            return cell;
        }
    }
}
#pragma mark ---- 修改用户信息网络请求
-(void)loadDataWithOrderid{
    
    NSString *changeurlPath = [NSString stringWithFormat:@"%@orderState.html",API_EVALUATE];
    NSDictionary * changeparamsDic = @{
                                       @"key"           :[Function getKey],
                                       @"order_id" :_order_id
                                       };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [LoadDate httpPost:changeurlPath param:changeparamsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.

            if ([obj[@"code"] longLongValue] == 200) {
                self.infoDict = obj[@"data"];
                for (int i = 0; i<[self.infoDict[@"order_goods"] count]; i++) {
                    if ([self.infoDict[@"order_goods"][i][@"evaluateinfo"] count]>0) {
                        EvaluateModel *model = [[EvaluateModel alloc]init];
                        [model setValuesForKeysWithDictionary:self.infoDict[@"order_goods"][i][@"evaluateinfo"]];
                        [self.evaluateArr addObject:model];
                        
                    }
                }
                
                
            }
            [hud hide:YES];
            [self.evaluateTableV reloadData];
        }else{
            [hud hide:YES];
            [MBProgressHUD showError:@"网络不给力"];
        }
        
    }];
    
    
}

-(void)addEvaluate:(UIButton *)btn{
    EveryOrderViewController *everyVC = [[EveryOrderViewController alloc]init];
    everyVC.orderID =_order_id;
    everyVC.goodsmodel =self.goodsArr[btn.tag];
    if (self.evaluateArr.count >0) {
        everyVC.evaluateModel = self.evaluateArr[btn.tag];
    }
    [self.navigationController pushViewController:everyVC animated:YES];
    if ([btn.currentTitle isEqualToString:@"查看评价"]) {
        everyVC.isTrue = YES;
    }else{

         everyVC.isTrue = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
