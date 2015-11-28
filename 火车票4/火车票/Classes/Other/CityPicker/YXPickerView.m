//
//  YXPickerView.m
//  CityPickerView
//
//  Created by 刘雨轩 on 15/10/12.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//
#import "YXPickerView.h"
#import "MBProgressHUD+XMG.h"
@interface YXPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong)NSArray *ProvinceArray;
@property(nonatomic,strong)NSArray *citiesArray;
@property(nonatomic,strong)NSArray *areasArray;
@property (nonatomic, strong) NSMutableData *fileData;  //网络下载车次的数据

@end
@implementation YXPickerView
#pragma mark
#pragma ----------------------------

- (NSString *)selProvince
{
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    return self.ProvinceArray[index][@"state"];
}
- (NSString *)selCity
{
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    return self.citiesArray[index];
}
- (NSString *)selArea
{
    if (self.areasArray.count > 0) {
        NSInteger index = [self.pickerView selectedRowInComponent:2];
        return self.areasArray[index];
    }else
    {
        return @"";
    }
    
}
- (NSArray *)ProvinceArray
{
    if (!_ProvinceArray) {
        _ProvinceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"province.plist" ofType:nil]];
        _citiesArray = _ProvinceArray[0][@"cities"];
    }
    
    return _ProvinceArray;
}
- (NSArray *)citiesArray
{
    if (!_citiesArray) {
        NSInteger index =[self.pickerView selectedRowInComponent:0];
        _citiesArray = _ProvinceArray[index][@"cities"];
        
    }
    return _citiesArray;
}

- (NSArray *)areasArray
{
    
    if (!_areasArray) {
        [self reloadAreas];
    }
    
    return _areasArray;
}


#pragma mark   创建方法
#pragma ----------------------------
- (instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:@"YXPickerView" owner:nil options:nil].lastObject;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    return self;
}
#pragma mark   pickerView的代理方法
#pragma ----------------------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    if (component == 0) {
        count = self.ProvinceArray.count;
    }else if(component == 1)
    {
        count = self.citiesArray.count;
    }else
    {
        count = self.areasArray.count;
    }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = nil;
    if (component == 0) {   //省
        str = self.ProvinceArray[row][@"state"];
    }else if(component == 1)  //城市
    {
        str = self.citiesArray[row];
    }else     //地区
    {
        str = self.areasArray[row];
    }
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //更新城市数据
        self.citiesArray = self.ProvinceArray[row][@"cities"];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        //更新地区数据
        [self reloadAreas];
        
        
    }else if(component == 1)
    {
        //更新地区数据
        
        [self reloadAreas];
    }
    
    //通知代理处理事情
    [self makeMessageToDelegate];
}
#pragma mark   通知自己的代理处理事情
#pragma ----------------------------
- (void)makeMessageToDelegate
{
    
    if ([self.delegate respondsToSelector:@selector(pickerView:SelcetProvince:andCity:andArea:)]) {
        [self.delegate pickerView:self SelcetProvince:[self selProvince] andCity:[self selCity] andArea:[self selArea]];
    }
}

#pragma mark -- 更新地区数组
- (void)reloadAreas
{
    
    [self addRequest];
}

- (void)awakeFromNib
{
//    NSLog(@"-----------");
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}

#pragma mark   发送网络请求
#pragma ----------------------------

- (void)addRequest
{
    [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    NSString *province = [[self selProvince] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *city = [[self selCity] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str= [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/queryAgencySellTicket/queryAgentSellCounty?province=%@&city=%@",province,city];
    
    //        1.确定请求路径
    NSURL *url = [NSURL URLWithString:str];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送
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
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.fileData options:kNilOptions error:nil];
    NSArray *dataArray = dict[@"data"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (dataArray) {
        for (NSArray *arr in dataArray) {
            [array addObject:arr[0]];
        }
        self.areasArray = array;
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        //传送数据
        [self makeMessageToDelegate];
        [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
    }
    
}
/*
 4.当请求失败的适合调用该方法,如果失败那么error有值
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //没有网络的时候
    [MBProgressHUD showError:@"请检查网络!"];
    [MBProgressHUD hideAllHUDsForView:self.superview.superview animated:YES];
}

//获取证书
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
