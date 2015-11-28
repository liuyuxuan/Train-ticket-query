//
//  YXPlaceController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/4.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
#import "YXPlaceController.h"
#import "YXCityButton.h"
#import "YXCityNameController.h"
#import "YXDateButton.h"
#import "YXQueryController.h"

@interface YXPlaceController ()
{
    NSDictionary *_staDict;  //第一个城市的字典
    NSDictionary *_endDict;  //第二个城市的字典
}

@property (nonatomic,strong)CalendarHomeViewController *chvc;  //日期弹窗
@property (nonatomic,strong)YXCityNameController *cityCv;  //城市选择控制器
@property (weak, nonatomic) IBOutlet YXDateButton *timeBtn; //时间按钮
@property (weak, nonatomic) IBOutlet YXCityButton *startBtn;   //始发地按钮
@property (weak, nonatomic) IBOutlet YXCityButton *endBtn;  //目的地按钮
@property (weak, nonatomic) IBOutlet UISwitch *speedinessSwitch;  //只搜高铁的开关
@property (weak, nonatomic) IBOutlet UISwitch *studentSwitch;  //学生票开关
@property (nonatomic,strong)NSDate *date;  //日期
@end

@implementation YXPlaceController
#pragma mark   懒加载
#pragma ----------------------------


- (YXCityNameController *)cityCv //城市选择控制器
{
    if (!_cityCv) {
        _cityCv = [[YXCityNameController alloc]init];
        _cityCv.navigationItem.title = @"车站查询";
        _cityCv.hidesBottomBarWhenPushed = YES;
    }
    return _cityCv;
}
- (CalendarHomeViewController *)chvc    //日期弹窗
{
    if (!_chvc) {
        _chvc = [[CalendarHomeViewController alloc]init];
        _chvc.calendartitle = @"出行日期";
        _chvc.hidesBottomBarWhenPushed = YES;
        [_chvc setAirPlaneToDay:60 ToDateforString:nil];
    }
    return _chvc;
}
//需要查询的日期
- (NSDate *)date
{
    if (!_date) {
        //默认明天
        _date = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
    }
    return _date;
}


- (NSDictionary *)staDict
{
    if (!_staDict) {
        //先从沙河中拿取
        NSString *path = [self cachesAppendingWithString:@"staDict"];
        _staDict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (!_staDict) {        //如果沙河没有值就使用默认值
            _staDict = @{
                         @"city":@"北京",
                         @"codeName":@"BJP"
                         };
        }
        
    }
    return _staDict;
}

-(NSDictionary *)endDict
{
    if (!_endDict) {
        //先从沙河中拿取
        NSString *path = [self cachesAppendingWithString:@"endDict"];
        _endDict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (!_endDict) {
            _endDict = @{
                         @"city":@"上海",
                         @"codeName":@"SHH"
                         };
        }
    }
    return _endDict;
}
#pragma mark   保存当前状态的城市
#pragma ----------------------------
- (void)setStaDict:(NSDictionary *)staDict
{
    _staDict = staDict;
    [self.startBtn setTitle:staDict[@"city"] forState:UIControlStateNormal];
    self.startBtn.titleLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.startBtn.titleLabel.alpha = 1;
    }];
}
- (void)setEndDict:(NSDictionary *)endDict
{
    _endDict = endDict;
    [self.endBtn setTitle:endDict[@"city"] forState:UIControlStateNormal];
    self.endBtn.titleLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.endBtn.titleLabel.alpha = 1;
    }];
}
#pragma mark   选择地址
#pragma ----------------------------
//起始地的按钮
- (IBAction)start:(YXCityButton *)sender {
    [self pushNamecontrollerWithObj:self];
}
//结束地按钮
- (IBAction)end:(YXCityButton *)sender {
    [self pushNamecontrollerWithObj:nil];
    
}
//选择地址的界面跳转
- (void)pushNamecontrollerWithObj:(id)obj
{
    self.cityCv.obj = obj;
    [self.navigationController pushViewController:self.cityCv animated:YES];
}

//当选择了城市之后就会调用,当前通知监听
- (void)changeBtnText:(NSNotification *)note
{
    if (note.object) {
        if([note.userInfo isEqualToDictionary:self.endDict])       //判断两个车站是否相同
        {
            [self exchange:nil];
            return;
        }
        self.staDict = note.userInfo;
        //拼接路径,保存
        NSString *path = [self cachesAppendingWithString:@"staDict"];

        [self.staDict writeToFile:path atomically:YES];
    }else
    {
        if([note.userInfo isEqualToDictionary:self.staDict])       //判断两个车站是否相同
        {
            [self exchange:nil];
            return;
        }
        self.endDict = note.userInfo;
        //拼接路径,保存
        NSString *path = [self cachesAppendingWithString:@"endDict"];
        [self.endDict writeToFile:path atomically:YES];
    }
}


//交换按钮
- (IBAction)exchange:(id)sender {
    NSString *name = self.startBtn.titleLabel.text;
    self.startBtn.titleLabel.text = self.endBtn.titleLabel.text;
    self.endBtn.titleLabel.text = name;
    
    //切换字典
    NSDictionary *dict = self.staDict;
    self.staDict = self.endDict;
    self.endDict = dict;
    self.startBtn.titleLabel.alpha = 0;
    self.endBtn.titleLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.startBtn.titleLabel.alpha = 1;
        self.endBtn.titleLabel.alpha = 1;
    }];
}
#pragma mark --返回沙河路径拼接
- (NSString *)cachesAppendingWithString:(NSString *)str;
{
   NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
     caches = [caches stringByAppendingPathComponent:str];
    return caches;
}

#pragma mark - 时间按钮

- (IBAction)time:(UIButton *)sender {
    
    __weak YXPlaceController *se = self;
    //获取日期中的数据
    self.chvc.calendarblock = ^(CalendarDayModel *model){
        se.date =[model date];
        [sender setTitle:[model toString] forState:UIControlStateNormal];
        
    };
    [self.navigationController pushViewController:self.chvc animated:YES];
    
}

#pragma mark   点击查询按钮
#pragma ----------------------------
- (IBAction)search:(id)sender {
    //跳转
    [self pushController];
}

- (void)pushController
{
    //跳转
   YXQueryController *control= [[YXQueryController alloc]init];
    control.hidesBottomBarWhenPushed = YES;
    control.date = self.date;
    control.staDict = self.staDict;
    control.endDict = self.endDict;
    control.isStudents = self.studentSwitch.isOn;
    control.isSpeed = self.speedinessSwitch.isOn;
    
    [self.navigationController pushViewController:control animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDate];
}
#pragma mark   初始化
#pragma ----------------------------
- (void)setUpDate
{
    //显示日期
    NSDateFormatter *dateFter = [[NSDateFormatter alloc]init];
    dateFter.dateFormat = @"yyyy-MM-dd";
    [self.timeBtn setTitle:[dateFter stringFromDate:self.date] forState:UIControlStateNormal];
    //显示城市
    [self.startBtn setTitle:self.staDict[@"city"] forState:UIControlStateNormal];
    [self.endBtn setTitle:self.endDict[@"city"] forState:UIControlStateNormal];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnText:) name:@"cityName" object:nil];
}

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
