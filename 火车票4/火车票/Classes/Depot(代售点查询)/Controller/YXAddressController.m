//
//  YXAddressController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXAddressController.h"
#import "MBProgressHUD+XMG.h"
#import "YXAgency.h"
#import "YXAgencyFrame.h"
#import "YXAgencyCell.h"
#import "MJRefresh.h"
#import "YXMapController.h"
@interface YXAddressController ()
@property (nonatomic,strong)NSMutableArray *agencyArray;

@property (nonatomic, strong) NSMutableData *fileData;  //网络下载车次的数据

@property (nonatomic,strong)MJRefreshGifHeader *header;  //下拉刷新

@end

@implementation YXAddressController
#pragma mark   lazy loading
#pragma ----------------------------

- (NSMutableArray *)agencyArray
{
    if (!_agencyArray) {
        _agencyArray = [NSMutableArray array];
    }
    return _agencyArray;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    //取消间隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRequest];
}


#pragma mark   tableView代理方法
#pragma ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agencyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    YXAgencyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YXAgencyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row %2 ==1) {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.agencyFrame = self.agencyArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.agencyArray[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YXAgencyFrame *agencyFrame = self.agencyArray[indexPath.row];
    NSString *address = agencyFrame.agency.address;
    
    YXMapController *control = [[YXMapController alloc]init];
    control.address = address;
    
    [self.navigationController pushViewController:control animated:YES];
    
}

#pragma mark   发送网络请求
#pragma ----------------------------

- (void)addRequest
{
    [self.header endRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:self.path];
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
    if (array.count > 0) {
        NSMutableArray *arrayDate = [NSMutableArray array];
        for (NSDictionary *dict in array)
        {
            YXAgency *agency = [YXAgency agencyWithDict:dict];
            
            YXAgencyFrame *ageFrame = [[YXAgencyFrame alloc]initWithAgency:agency];
            
            [arrayDate addObject:ageFrame];
        }
        self.agencyArray = arrayDate;
        [self.tableView reloadData];
    }else
    {
        [MBProgressHUD showError:@"没有您查询的数据!"];
        //等一秒之后返回
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}
/*
 4.当请求失败的适合调用该方法,如果失败那么error有值
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //没有网络的时候
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessage:@"请检查网络!"];
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
