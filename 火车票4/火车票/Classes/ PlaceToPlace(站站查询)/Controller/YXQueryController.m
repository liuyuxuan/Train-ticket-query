//
//  YXQueryController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/5.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//
#define MainScreenW [UIScreen mainScreen].bounds.size.width
#define MainScreenH [UIScreen mainScreen].bounds.size.height
#define ChildViewH 60
#import "YXQueryController.h"
#import "YXButton.h"
#import "YXKCell.h"
#import "YXGCell.h"
#import "YXTrain.h"
#import "YXKTrain.h"
#import "YXGTrain.h"
#import "MBProgressHUD+XMG.h"
#import "MJRefresh.h"
#import "YXTrainTimeController.h"
#import "UIView+Frame.h"
@interface YXQueryController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableData *fileData;  //网络下载车次的数据
@property (nonatomic,strong)NSArray *stateArray;    //保存是否学生票
@property (nonatomic,strong)NSMutableArray *array;    //保存是否学生票
@property (nonatomic,strong)MJRefreshGifHeader *header;
@property(nonatomic,strong)YXTrainTimeController *control;  /**< 自控制器*/

@end

@implementation YXQueryController
#pragma mark   lazy loading
#pragma ----------------------------

- (YXTrainTimeController *)control
{
    if (!_control) {
        _control = [[YXTrainTimeController alloc]init];
        _control.hidesBottomBarWhenPushed = YES;
    }
    return _control;
}

- (MJRefreshGifHeader *)header
{
    if (!_header) {
        //下拉刷新的头部
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(addRequest)];
        self.tableView.header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _header = header;
    }
    return _header;
}

-(NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = @[@"ADULT",@"0X00"];
    }
    return _stateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildView];
    [self addChildView];
    [self addRequest];
}
#pragma mark - 属性设置

- (void)setUpChildView
{
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[self stringTimeForDate:self.date]];
    
//   self.tableView.contentInset = UIEdgeInsetsMake(ChildViewH, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //取消间隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 添加子控件
- (void)addChildView
{
    CGFloat viewW = MainScreenW;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,MainScreenH- ChildViewH, viewW, ChildViewH)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    CGFloat btnW = viewW / 2;
    //按钮图片处理

    //设置前一天的按钮
    YXButton *btn1 = [YXButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 10, btnW-20, ChildViewH-20);


    [btn1 setTitle:@"前一天" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    
    //设置后一天的按钮
    YXButton *btn3 = [YXButton buttonWithType:UIButtonTypeCustom];
    [btn3 setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
    btn3.frame = CGRectMake(btnW * 1+10, 10, btnW-20, ChildViewH-20);
//

    [btn3 setTitle:@"后一天" forState:UIControlStateNormal];
    btn3.tag = 0;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn3];


}
static int const YXAddDay = 24 * 60 *60;

#pragma mark - 按钮点击
- (void)btnClick:(YXButton *)btn
{
    //今天
    NSDate *curDate = [NSDate date];
    //最大可以选则的日期
    NSDate *maxDate = [curDate dateByAddingTimeInterval:YXAddDay * 59];
    NSString *maxTime =[self stringTimeForDate:maxDate];
    NSString *curTime = [self stringTimeForDate:curDate];
    //选择的日期
    NSString *time = [self stringTimeForDate:self.date];
    //控制日期
    if (([time isEqualToString:curTime]&&btn.tag == 1) || ([time isEqualToString:maxTime]&&btn.tag == 0)) {
        [MBProgressHUD showError:@"请选择正确的日期!"];
        return;
    }

    self.date = [self.date dateByAddingTimeInterval:btn.tag?-YXAddDay:+YXAddDay];
    //重新加载
    self.navigationItem.title = [NSString stringWithFormat:@"%@",time];
    [self addRequest];
}
#pragma mark   把一个日期转换为一个字符串
#pragma ----------------------------
- (NSString *)stringTimeForDate:(NSDate *)date
{
    NSDateFormatter *dateFter = [[NSDateFormatter alloc]init];
    dateFter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [dateFter stringFromDate:date];
    return time;
}
#pragma mark - TableView的代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXTrain *train = self.array[indexPath.row];
    
    if ([train isKindOfClass:[YXGTrain class]]) {
        YXGCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GCell"];
        if (!cell) {
            cell = [[YXGCell alloc]init];
        }
        cell.gTrain = train;
        if(indexPath.row %2 == 1)
        {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else
    {
        YXKCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCell"];
        if (!cell) {
            cell = [[YXKCell alloc]init];
        }
        cell.kTrain = train;
        if(indexPath.row %2 == 1)
        {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXTrain *train = self.array[indexPath.row];
   self.control.trainName = train.number;
    [self.navigationController pushViewController:self.control animated:YES];
}

#pragma mark   发送网络请求
#pragma ----------------------------

- (void)addRequest
{
    [self.header endRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //获取时间
    NSDateFormatter *dateFter = [[NSDateFormatter alloc]init];
    dateFter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [dateFter stringFromDate:self.date];
    //状态
    NSString *state = self.stateArray[self.isStudents];
    NSString *str = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/lcxxcx/query?purpose_codes=%@&queryDate=%@&from_station=%@&to_station=%@",state,date,self.staDict[@"codeName"],self.endDict[@"codeName"]];
    NSURL *url = [NSURL URLWithString:str];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.设置代理,发送请求
    [NSURLConnection connectionWithRequest:request delegate:self];
}



/*
 1.接收到服务器响应的适合调用
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileData = [NSMutableData data];
    
}

/*
 2.接收到服务器返回的数据,会调用多次
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.fileData appendData:data];
    
}

/*
 3.当请求完成之后调用该方法
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.fileData options:kNilOptions error:nil];
    NSArray *array = dict[@"data"][@"datas"];
    if (!array) {
        [MBProgressHUD showError:@"没有相应的车次!"];
        //等一秒之后返回
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    NSMutableArray *arraydate = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        if((
            [dict[@"station_train_code"] characterAtIndex:0] == 'K' ||
            [dict[@"station_train_code"] characterAtIndex:0] == 'T' ||
            [dict[@"station_train_code"] characterAtIndex:0] == 'Z' ||
            [dict[@"station_train_code"] characterAtIndex:0] == 'L' )
           &&  !self.isSpeed  //只搜高铁开关关闭的时候
           )  //k,T,z,L列车
        {
            YXKTrain *kTran = [YXKTrain kTrainWithDict:dict];
            [arraydate addObject:kTran];
        }else if([dict[@"station_train_code"] characterAtIndex:0] == 'G' ||
                 [dict[@"station_train_code"] characterAtIndex:0] == 'D'||
                 [dict[@"station_train_code"] characterAtIndex:0] == 'C')  //g,c,d列车
        {
            YXGTrain *gTran = [YXGTrain gTrainWithDict:dict];
            [arraydate addObject:gTran];
        }
    }
    self.array = arraydate;
    [self.tableView reloadData];
}
/*
 4.当请求失败的适合调用该方法,如果失败那么error有值
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //没有网络的时候
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:@"请检查网络!"];
    //等一秒之后返回
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark - 获取网络数据
#pragma mark  NSURLConnectionDataDelegate  start

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


@end
