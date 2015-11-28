//
//  YXDepotController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/11.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXDepotController.h"
#import "YXPickerView.h"
#import "YXAddressController.h"
#import "YXMapController.h"
@interface YXDepotController ()<YXPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *provinceFld;
@property (weak, nonatomic) IBOutlet UITextField *cityFld;
@property (weak, nonatomic) IBOutlet UITextField *areaFld;

@property(nonatomic,strong)YXPickerView *pickerView;  /**< 城市选择器*/

@end

@implementation YXDepotController
#pragma mark   懒加载
#pragma ----------------------------

- (YXPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[YXPickerView alloc]init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

#pragma mark   pickerView的代理方法
#pragma ----------------------------
- (void)pickerView:(YXPickerView *)pickerView SelcetProvince:(NSString *)province andCity:(NSString *)city andArea:(NSString *)area
{
    self.provinceFld.text = province;
    self.cityFld.text = city;
    self.areaFld.text = area;
}

#pragma mark   初始化
#pragma ----------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
    //监听地图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapReturn:) name:@"map" object:nil];
}
- (void)setUpData
{
    self.provinceFld.inputView = self.pickerView;
    self.cityFld.inputView = self.pickerView;
    self.areaFld.inputView = self.pickerView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//退出键盘
- (void)quitPickerView
{
    [self.provinceFld endEditing:YES];
    [self.cityFld endEditing:YES];
    [self.areaFld endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self quitPickerView];
}
#pragma 进入地图之后返回
- (void)mapReturn:(NSNotification *)note
{
    if (note.userInfo) {
        NSMutableString *province = [NSMutableString stringWithString:note.userInfo[@"State"]];
        if(![note.userInfo[@"City"] isEqualToString:@"北京市"])
        {
        self.provinceFld.text =[province stringByReplacingOccurrencesOfString:@"省" withString:@""];
        NSMutableString *city = [NSMutableString stringWithString:note.userInfo[@"City"]];
        self.cityFld.text = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            self.areaFld.text = note.userInfo[@"SubLocality"];
        }else
        {
            self.provinceFld.text = @"北京";
            self.areaFld.text = note.userInfo[@"SubLocality"];
            self.cityFld.text = @"北京";
        }
    }
}

#pragma mark   查询按钮
#pragma ----------------------------
- (IBAction)search:(UIButton *)sender {
    [self quitPickerView];
    //跳转
    [self pushAddressController];
}
- (IBAction)GoMap:(id)sender {
    YXMapController *controller = [[YXMapController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)pushAddressController
{
    NSString *provinceNormal = self.provinceFld.text;
    NSString *province = [provinceNormal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *cityNormal = self.cityFld.text;
    NSString *city =[cityNormal  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *areaNormal = self.areaFld.text;
    NSString *area = [areaNormal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/queryAgencySellTicket/query?province=%@&city=%@&county=%@",province,city,area];
    YXAddressController *controller = [[YXAddressController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.path = path;
    controller.navigationItem.title = [NSString stringWithFormat:@"%@-%@-%@",provinceNormal,cityNormal,areaNormal];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
