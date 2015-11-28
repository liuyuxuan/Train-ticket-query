//
//  YXTrainTimeController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/16.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//
#define MainScreenW [UIScreen mainScreen].bounds.size.width
#define MainScreenH [UIScreen mainScreen].bounds.size.height
#import "YXTrainTimeController.h"
#import "YXTrainTime.h"
#import "YXTrainTimeCell.h"
#import "MBProgressHUD+XMG.h"
@interface YXTrainTimeController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *array;

@property(nonatomic,strong)UITableView *tableView;  /**< 列表*/
@end

@implementation YXTrainTimeController
#pragma mark   懒加载
#pragma ----------------------------

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 44, MainScreenW, MainScreenH - 44);
        [self.view addSubview:_tableView];
    }
   return  _tableView;
}

- (NSArray *)array
{
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}
#pragma mark   每次即将显示的时候刷新数据
#pragma ----------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addRequest];
    //每次显示的时候返回顶部
    if(self.array.count > 0)
    {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeader];
    self.navigationItem.title = self.trainName;
    
}
- (void)addHeader
{
    UIView *header = [[UIView alloc]init];
    header.frame = CGRectMake(0, 64,MainScreenW , 44);
    UIView *view = [[YXTrainTimeCell alloc]init];
    view.frame = CGRectMake(0, 0,MainScreenW, 44);
    view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [header addSubview:view];
    [self.view addSubview:header];
}

#pragma mark   tableView的相关代理数据
#pragma ----------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TrainTime";
    YXTrainTimeCell *cell  =[self.tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YXTrainTimeCell alloc]init];
    }
    YXTrainTime *trainTime = self.array[indexPath.row];
    cell.trainTime = trainTime;
    if(indexPath.row %2 == 1)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
#pragma mark   请求网络
#pragma ----------------------------
- (void)addRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *path = [NSString stringWithFormat:@"http://lieche.58.com/checi/%@/",self.trainName];
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:path];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //4.解析数据
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        NSRange rang=[str rangeOfString:@"<tbody>"];
        if (rang.length == 0) {
            [MBProgressHUD showError:@"请输入准确的车次!"];
            //等一秒之后返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            return ;
        }
        NSMutableString *str2=[[NSMutableString alloc]initWithString:[str substringFromIndex:rang.location+rang.length]];
        
        rang =[str2 rangeOfString:@"</tbody>"];
        str2=[[NSMutableString alloc]initWithString:[str2 substringToIndex:rang.location]];
        rang =[str2 rangeOfString:@"target=\"_blank\">"];
        NSMutableArray *array= [NSMutableArray array];
        
        do {
            str2=[[NSMutableString alloc]initWithString:[str2 substringFromIndex:rang.location+rang.length]];
            NSRange rang1 =[str2 rangeOfString:@"</tr>"];
            
            
            NSMutableString *str3 = [[NSMutableString alloc]initWithString:[str2 substringToIndex:rang1.location]];
            NSRange rang2 = [str3 rangeOfString:@"</"];
            NSRange rang3 = [str3 rangeOfString:@"<td>"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            int i = 0;
            do {
                NSString *string = [[NSMutableString alloc]initWithString:[str3 substringToIndex:rang2.location]];
                string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                str3 = [[NSMutableString alloc]initWithString:[str3 substringFromIndex:rang3.location+rang3.length]];
                switch (i) {
                    case 0:
                        [dict setValue:string forKey:@"name"];
                        break;
                    case 1:
                        [dict setValue:string forKey:@"day"];
                        break;
                    case 2:
                    {
                        NSRange rang = [string rangeOfString:@"<"];
                        NSString *staTime = [NSString stringWithString:[string substringToIndex:rang.location]];
                        [dict setValue:staTime forKey:@"staTime"];
                        rang = [string rangeOfString:@">"];
                        string = [NSMutableString stringWithString:[string substringFromIndex:rang.length+rang.location]];
                        [dict setObject:string forKey:@"endTime"];
                    }
                        
                        break;
                    case 3:
                        [dict setValue:string forKey:@"stopTime"];
                        break;
                    case 4:
                        [dict setValue:string forKey:@"useTime"];
                        break;
                    case 5:
                        [dict setValue:string forKey:@"mileage"];
                        
                        [array addObject:dict];
                        break;
                    default:
                        break;
                }
                
                rang2 = [str3 rangeOfString:@"</"];
                rang3 = [str3 rangeOfString:@"<td>"];
                i++;
            } while (rang3.length);
            rang =[str2 rangeOfString:@"target=\"_blank\">"];
        } while (rang.length);
        NSMutableArray *arrayT = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            YXTrainTime *trainT = [YXTrainTime trainTimeWithDict:dict];
            [arrayT addObject:trainT];
            
        };
        self.array = arrayT;
        [self.tableView reloadData];
    }];
    
}

@end
