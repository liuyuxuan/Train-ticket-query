//
//  YXNumberController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/11.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXNumberController.h"
#import "YXTrainTimeController.h"
#import "YXHistoryCell.h"
#import "MBProgressHUD+XMG.h"
@interface YXNumberController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *historyTableVew;
@property(nonatomic,strong)YXTrainTimeController *control;  /**< 控制器*/
@property(nonatomic,strong)NSMutableArray *historyArray;  /**< 历史记录*/

@end

@implementation YXNumberController
#pragma mark   懒加载
#pragma ----------------------------

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        NSString *path = [self cachesAppendingWithString:@"history"];
        
        _historyArray = [NSMutableArray arrayWithContentsOfFile:path];
        if(!_historyArray)
        {
            _historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}
- (YXTrainTimeController *)control
{
    if (!_control) {
        _control = [[YXTrainTimeController alloc]init];
        _control.hidesBottomBarWhenPushed = YES;
    }
    return _control;
}

#pragma mark --返回沙河路径拼接
- (NSString *)cachesAppendingWithString:(NSString *)str;
{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    caches = [caches stringByAppendingPathComponent:str];
    return caches;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    self.historyTableVew.delegate = self;
    self.historyTableVew.dataSource = self;
    self.historyTableVew.showsVerticalScrollIndicator = NO;

}
#pragma mark   点击查询按钮
#pragma ----------------------------
- (IBAction)search:(UIButton *)sender {
    //跳转
    NSString *str = self.textField.text;
    if ([str isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入车次!"];
        return;
    }
    
    self.control.trainName = str;
    //查询当前列表里面有没有这个记录
    NSInteger index = [self.historyArray indexOfObject:str];
    if (index!=NSNotFound) {
        [self.historyArray removeObjectAtIndex:index];
    }
    //限制列表的总数,最多保存10个
    if (self.historyArray.count == 10) {
        [self.historyArray removeObjectAtIndex:9];
    }
    [self.historyArray insertObject:str atIndex:0];
    [self.historyTableVew reloadData];
    NSString *path = [self cachesAppendingWithString:@"history"];
    [self.historyArray writeToFile:path atomically:YES];
    
    [self.navigationController pushViewController:self.control animated:YES];
    
}
//点击屏幕退出文本编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField endEditing:YES];
}
#pragma mark   文本框代理
#pragma ----------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (range.length == 0) {
        
    char a = (char)[string characterAtIndex:0];
    if(a <'z'+1 && a >'a'-1)
    {
        a = a - 32;
        NSMutableString *str = [NSMutableString stringWithString:textField.text];
        [str appendString:[NSString stringWithFormat:@"%c",a]];
        textField.text = str;
        return NO;
    }
    }
    return YES;
}


#pragma mark   历史搜索列表的数据处理
#pragma ----------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"History";
    YXHistoryCell *cell = [[YXHistoryCell alloc]init];
    cell.trainName = self.historyArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = self.historyArray[indexPath.row];
}

@end
