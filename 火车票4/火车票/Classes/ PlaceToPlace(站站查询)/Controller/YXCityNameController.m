//
//  YXCityNameController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXCityNameController.h"
#import "UIView+Frame.h"
@interface YXCityNameController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *cityName;  //名字
@property (nonatomic,strong)NSMutableArray *cityNamePy;  //拼音
@property (nonatomic,strong)NSArray *array;  //全部数组
@property (nonatomic,strong)NSArray *filterArray;  //模糊搜索
@property (nonatomic,strong)UISearchDisplayController *searchDisplayController;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *header;  /**< 搜索条头部*/

@end

@implementation YXCityNameController
#pragma mark   懒加载
#pragma ----------------------------
- (UIView *)header
{
    if (!_header) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 44)];
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
        _header = view;
    }
    return _header;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 44, self.view.width, self.view.height-44);
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)cityName
{
    if (!_cityName) {
        _cityName = [NSMutableArray array];
        for (NSDictionary *dict in self.array) {
            [_cityName addObject:dict[@"city"]];
        }
    }
    return _cityName;
}
- (NSMutableArray *)cityNamePy
{
    if (!_cityNamePy) {
        _cityNamePy = [NSMutableArray array];
        for (NSDictionary *dict in self.array) {
            [_cityNamePy addObject:dict[@"shortName"]];
        }
    }
    return _cityNamePy;
}
- (NSArray *)array
{
    if (!_array) {
        _array =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityName.plist" ofType:nil]];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    //每次显示的时候返回顶部
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

#pragma mark - 添加搜索框
- (void)addSearchView
{
    //取消间隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"请输入车站";
    searchBar.delegate = self;
    
    //添加搜索框
    [self.header addSubview: searchBar];
    //管理者
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    
    
}
#pragma mark   搜索条代理方法
#pragma ----------------------------
#pragma mark - 搜索条的取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.filterArray = nil;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.2 animations:^{
        self.header.transform = CGAffineTransformMakeTranslation(0, -40);
    }];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.2 animations:^{
        self.header.transform = CGAffineTransformIdentity;
    }];
    
    return YES;
}
#pragma mark   tableview
#pragma ----------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.array.count;
    }else{
        // 谓词搜索
        NSString *str = self.searchDisplayController.searchBar.text;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd]%@",str];
        char a;
        if (![str isEqualToString:@""]) {
            a = [str characterAtIndex:0];
        }
        if ((a >'a'&& a < 'z') || (a >'A'&& a < 'Z')) {
            NSArray *arr = [[NSArray alloc] initWithArray:[self.cityNamePy filteredArrayUsingPredicate:predicate]];
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                
                for (NSDictionary *dict in self.array) {
                    if ([dict[@"shortName"] isEqualToString:arr[i]]) {
                        [array addObject:dict[@"city"]];
                    }
                }
            }
            self.filterArray = array;
        }else
        {
            self.filterArray =  [[NSArray alloc] initWithArray:[self.cityName filteredArrayUsingPredicate:predicate]];
        }
        return self.filterArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView == self.tableView) {
        cell.textLabel.text = self.array[indexPath.row][@"city"];
    }else{
        cell.textLabel.text = self.filterArray[indexPath.row];
    }
    if(indexPath.row %2 == 1)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.filterArray.count > 0) {
        NSString *name = self.filterArray[indexPath.row];
        NSArray *array  =self.array;
        for (NSDictionary *dict in array) {
            if ([name isEqualToString:dict[@"city"]]) {
                self.dict = dict;
                break;
            }
        }
    }else
    {
        self.dict = self.array[indexPath.row];
    }
    self.searchDisplayController.searchBar.text = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
    //发送一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityName" object:self.obj userInfo:@{@"city":self.dict[@"city"],@"codeName":self.dict[@"codeName"]}];
}

@end
