//
//  SpecView.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SpecView.h"
#import "SpecTableViewCell.h"
@implementation SpecView
{
    BOOL isOpen;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        [self createSpecView];
    }
    return self;
}

-(void)createSpecView{
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40) style:UITableViewStylePlain];

    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.tag = 40;
    self.tableV.alwaysBounceVertical = NO;
    self.tableV.alwaysBounceHorizontal=NO;

    self.tableV.backgroundColor = [UIColor whiteColor];
    [self.tableV registerClass:[SpecTableViewCell class] forCellReuseIdentifier:@"SpecTableViewCell"];
    [self addSubview:self.tableV];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static   NSString *cellID = @"Cell";
    SpecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SpecTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectBtn.selected = NO;
    }
    if ([self.arr[indexPath.row] isKindOfClass:NSClassFromString(@"NSString")]) {
        cell.textLabel.text = self.arr[indexPath.row];
        cell.selectBtn.tag = indexPath.row +2000;
        NSIndexPath *path = self.selectArr[0];
        if (cell.selectBtn.tag == path.row+2000) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
        
    }else{
        cell.textLabel.text = [self.arr[indexPath.row] objectForKey:@"reason_info"];
        cell.selectBtn.tag = indexPath.row +200;
        NSIndexPath *path = self.selectArr[0];
        if (cell.selectBtn.tag == path.row+200) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {

    self.selectArr =@[indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.arr[indexPath.row] isKindOfClass:NSClassFromString(@"NSString")]) {
         [self.delegate selectText:self.arr[indexPath.row] andForRow:nil];
        for (SpecTableViewCell *cel in tableView.visibleCells) {
            if (cel.selectBtn.tag == indexPath.row +2000) {
                cel.selectBtn.selected = YES;
            }else{
                cel.selectBtn.selected = NO;
            }
        }
        
    }else{
        
        [self.delegate selectText:[self.arr[indexPath.row] objectForKey:@"reason_info"] andForRow:[self.arr[indexPath.row] objectForKey:@"reason_id"]];
        for (SpecTableViewCell *cel in tableView.visibleCells) {
            if (cel.selectBtn.tag == indexPath.row +200) {
                cel.selectBtn.selected = YES;
            }else{
                cel.selectBtn.selected = NO;
            }
        }

    }

    self.hidden = YES;

}

@end
