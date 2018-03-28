//
//  CitySelectionViewController.m
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/21.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import "CitySelectionViewController.h"
#import "JJTableViewIndexView.h"
#import "STSearchBar.h"
#import "CitySelectionHeadView.h"
#import "CitySelectionTwoHeadView.h"
#import "CitySelectionViewCell.h"
#import "CitySelectionViewTwoCell.h"
#import "ZYPinYinSearch.h"
#import "WDCityModel.h"
#import "BMChineseSort.h"
#import "WDHotCityModel.h"
#import "BRPositioningManager.h"
static NSString *  CellID = @"CellID";

@interface CitySelectionViewController ()<UITableViewDelegate,UITableViewDataSource,STSearchBarDelegate>
{
    NSMutableArray<WDCityModel *> *dataArray;
}
/** 1.自定义的搜索框 */
@property (nonatomic, strong) STSearchBar *searchBar;

@property (nonatomic, strong) UITableView *searchTableView;

@property (strong,nonatomic)UITableView *CityNametableView;

@property(strong,nonatomic)JJTableViewIndexView * JJView;

@property(strong,nonatomic)NSMutableArray *Marray2;

@property(strong,nonatomic)UIView *maskView;

@property(strong,nonatomic)NSMutableArray *SearchArray;


@property(strong,nonatomic)NSMutableArray *MDataArray;


//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property(nonatomic,strong)NSMutableArray *HotCityArray;

@property(nonatomic,strong)NSMutableDictionary *buffList;


@property(nonatomic,strong)UIView *hotCityView;

@property(nonatomic,strong) CitySelectionHeadView *HotHeadView;

@end

@implementation CitySelectionViewController




//-(void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    NSLog(@"%@",[WDUser sharedUser].CityName);
//    NSLog(@"%@",[WDUser sharedUser].locationCityName);
//    if (![[WDUser sharedUser].CityName isEqualToString:[WDUser sharedUser].locationCityName]) {
//        NSString *Str = [NSString stringWithFormat:@"系统定位到您是在%@,需要切换至%@吗？",[WDUser sharedUser].locationCityName,[WDUser sharedUser].locationCityName];
//        
//        
//        
//        
//        
//        
//        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"温馨提示" message:Str preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if ([[self.buffList allKeys] containsObject:[WDUser sharedUser].locationCityName]) {
//                
//                NSString *codeStr = [self.buffList objectForKey:[WDUser sharedUser].locationCityName];
//                if (self.selectedCityBlock) {
//                    self.selectedCityBlock(codeStr,[WDUser sharedUser].locationCityName);
//                }
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [sureAction setValue:BRmainColor forKey:@"titleTextColor"];
//        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }];
//        [cancelAction setValue:BRmainColor forKey:@"titleTextColor"];
//        [alertController addAction:cancelAction];
//        [alertController addAction:sureAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//      
//    }
//    
//    
//    
//    
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[BRPositioningManager shareInstance] startUpdatingLocation];//开启定位
    self.title = @"城市选择";
    _MDataArray = [NSMutableArray array];

    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.HotHeadView];
    [self.view addSubview:self.CityNametableView];
    
    [self initHeadViewData];
    
}



- (CitySelectionHeadView *)HotHeadView{
    WS(weakSelf);
    if (!_HotHeadView) {
        _HotHeadView = [[[NSBundle mainBundle]loadNibNamed:@"CitySelectionHeadView" owner:nil options:nil] lastObject];
        _HotHeadView.frame = CGRectMake(0, self.searchBar.bottom, WIDTH, 48);
        _HotHeadView.LocatCityBlock = ^(NSString *LocatCityName) {
            if ([[weakSelf.buffList allKeys] containsObject:LocatCityName]) {
                NSString *codeStr = [weakSelf.buffList objectForKey:LocatCityName];
                if (weakSelf.selectedCityBlock) {
                    weakSelf.selectedCityBlock(codeStr,LocatCityName);
                }
            }
        };
    }
    return _HotHeadView;
}

- (UIView *)hotCityView{
    if (!_hotCityView) {
        _hotCityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        [_hotCityView setBackgroundColor:BRCOLOR(@"f8f8f8")];
        
        UILabel * label= [[UILabel alloc]initWithFrame:CGRectMake(15, 6, 200, 18)];
        label.text = @"热门城市";
        label.textColor = BRCOLOR(@"999999");
        label.font =[UIFont systemFontOfSize:15];
        
        [_hotCityView addSubview:label];
        
    }
    
    return _hotCityView;
}


- (NSMutableDictionary *)buffList{
    if (!_buffList) {
        _buffList = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _buffList;
}

- (NSMutableArray *)HotCityArray{
    
    if (!_HotCityArray) {
        _HotCityArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _HotCityArray;
}

- (void)initHeadViewData{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HotCity" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *responseObject =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         for (NSDictionary *Dcit in responseObject) {
             WDHotCityModel *Model = [WDHotCityModel yy_modelWithDictionary:Dcit];
             [self.HotCityArray addObject:Model];
         }
          [self initData];
}

-(void)initData{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityArray" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *responseObject =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   
        NSArray *array= responseObject;
        //模拟网络请求接收到的数组对象 Person数组
        dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<[array count]; i++) {

            [self.buffList setObject:array[i][@"region"] forKey:array[i][@"name"]];

            WDCityModel *Model = [WDCityModel yy_modelWithDictionary:array[i]];

            [dataArray addObject:Model];
        }

        self.indexArray = [BMChineseSort IndexWithArray:dataArray Key:@"name"];
        self.letterResultArr = [BMChineseSort sortObjectArray:dataArray Key:@"name"];
        [self.indexArray insertObject:@"热门" atIndex:0];
        for (NSDictionary *Dict in responseObject) {
            WDCityModel *Model = [WDCityModel yy_modelWithDictionary:Dict];
            [self.MDataArray addObject:Model];
        }
        [self creatJJView];
        [self.CityNametableView reloadData];
}



-(void)creatJJView
{
    WS(weakSelf);
    //实例化
    _JJView = [[JJTableViewIndexView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 83, 40, [UIScreen mainScreen].bounds.size.height - 118 - 64 -49) IndexNameArray:self.indexArray];
    //添加到控制器
    [self.view addSubview:_JJView];
    //实现回调,联动
    [_JJView selectIndexBlock:^(NSInteger section)
     {
    [weakSelf.CityNametableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionTop];
     }];
}



- (NSMutableArray *)SearchArray{
    
    if (!_SearchArray) {
        _SearchArray =[NSMutableArray arrayWithCapacity:0];
    }
    return _SearchArray;
}


- (UITableView *)CityNametableView{

    if (!_CityNametableView) {
        _CityNametableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.HotHeadView.bottom, WIDTH, HEIGHT - self.HotHeadView.bottom - 64) style:UITableViewStyleGrouped];
        _CityNametableView.backgroundColor = RGB(244, 244, 244);
        _CityNametableView.delegate = self;
        _CityNametableView.dataSource = self;
        _CityNametableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_CityNametableView registerClass:[CitySelectionViewCell class] forCellReuseIdentifier:CellID];
        [_CityNametableView registerNib:[UINib nibWithNibName:@"CitySelectionViewTwoCell" bundle:nil] forCellReuseIdentifier:@"CitySelectionViewTwoCell"];
        
//        _tableView.sectionIndexColor = [UIColor blueColor];//设置默认时索引值颜色
//        _tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];//设置选中时，索引背景颜色
//        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];// 设置默认时，索引的背景颜色
    }
    return _CityNametableView;
}


- (UITableView *)searchTableView{

    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.bottom, WIDTH, HEIGHT - self.searchBar.bottom - 64) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _searchTableView;

}

-(UIView *)maskView{

    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

- (STSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[STSearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        _searchBar.delegate = self;
        _searchBar.font = [UIFont systemFontOfSize:14];
        _searchBar.placeholderColor = BRCOLOR(@"aaaaaa");
        _searchBar.placeholder = @"输入城市名称或拼音";
    }
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.searchTableView) {
        return 1;
    }
    return self.indexArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.searchTableView) {
        
        if (self.SearchArray.count == 0) {
            return 1;
        }else{
             return self.SearchArray.count;
        }
       
    }else{
        if (section == 0) {
            return 1;
        }
        
        NSArray *array = self.letterResultArr[section - 1];
        
        return [array count];
    
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchTableView) {
        CitySelectionViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitySelectionViewTwoCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CitySelectionViewTwoCell" owner:nil options:nil]lastObject];
        }
        
        if (self.SearchArray.count == 0) {
            cell.TitleLabel.text = @"抱歉，未找到相关城市，请尝试修改后重试";
            cell.TitleLabel.textAlignment = NSTextAlignmentCenter;
            cell.TitleLabel.textColor = BRCOLOR(@"666666");
            cell.BottomLine.hidden = YES;
            return cell;
            
        }else{
            
            WDCityModel *model = self.SearchArray[indexPath.row];
            
            cell.TitleLabel.text = model.name;
            cell.TitleLabel.textColor = BRCOLOR(@"8168ed");
            cell.TitleLabel.highlightedTextColor = BRmainColor;
            return cell;
        }
        
    }else if(tableView == self.CityNametableView){
    
        if (indexPath.section == 0) {
            
            CitySelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
            cell.hotCityNameBlock = ^(NSString *CID, NSString *CityName) {
                if (self.selectedCityBlock) {
                    self.selectedCityBlock(CID,CityName);
                }
            };
           
    [cell CreateCellViewDataSource:self.HotCityArray];
            
            return cell;
            
        }else{
            
            CitySelectionViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitySelectionViewTwoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CitySelectionViewTwoCell" owner:nil options:nil]lastObject];
            }
            
            WDCityModel *model = self.letterResultArr[indexPath.section - 1][indexPath.row];
            cell.TitleLabel.text = model.name;
            cell.TitleLabel.highlightedTextColor = BRmainColor;            return cell;
          }
    }else{

        return nil;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView == self.searchTableView) {
        return 0.00001;
    }else{
    
        return 30;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    if (tableView == self.searchTableView) {
        return nil;
    }else if(tableView == self.CityNametableView){
        if (section == 0) {
        
        return self.hotCityView;
        
        }else{
            CitySelectionTwoHeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"CitySelectionTwoHeadView" owner:nil options:nil] lastObject];
            
            headView.HeadTitleLabel.text = self.indexArray[section];
            
            return headView;
        }
    
    }
    return nil;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.searchTableView) {
        return 48;
    }else if(tableView == self.CityNametableView) {
    
        if (indexPath.section == 0) {
            return 96;
        }
        
        return 48;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (tableView == self.searchTableView) {
        if (self.SearchArray.count == 0) {
            
        }else{
            WDCityModel *model = self.SearchArray[indexPath.row];
            if (self.selectedCityBlock) {
                self.selectedCityBlock(model.region,model.name);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else{
        
        if (indexPath.section == 0) {
            
            
        }else{
        
      WDCityModel *model = self.letterResultArr[indexPath.section -1][indexPath.row];
        if (self.selectedCityBlock) {
            self.selectedCityBlock(model.region,model.name);
//            
//            DEF_PERSISTENT_SET_OBJECT(model.region, @"CityCode");
//            DEF_PERSISTENT_SET_OBJECT(model.name, @"CityName");
            
        }
     
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    }



}

#pragma mark - --- delegate 视图委托 ---
//开始编辑时调用
-(BOOL)searchBarShouldBeginEditing:(STSearchBar *)searchBar{
    
    [self.view addSubview:self.maskView];
    
    return YES;
}                     // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(STSearchBar *)searchBar{
    
}                    // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(STSearchBar *)searchBar{
    return YES;
}                       // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(STSearchBar *)searchBar{
    
}
//输入框有变化的时候调用 // called when text ends editing
- (void)searchBar:(STSearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqualToString:@""]) {
         [self.searchTableView removeFromSuperview];
    }else{
        [self.view addSubview:self.searchTableView];
        NSArray *searchDataAry = [ZYPinYinSearch searchWithOriginalArray:self.MDataArray andSearchText:searchText andSearchByPropertyName:@"name"];
        self.SearchArray = [NSMutableArray arrayWithArray:searchDataAry];
        [self.searchTableView reloadData];
        NSLog(@"%@ %@",searchText,self.SearchArray);
    }
     
}   // called when text changes (including clear)

//输入框开始有变化的时候调用
- (BOOL)searchBar:(STSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
//    [self.maskView removeFromSuperview];
    return YES;
} // called before text changes

- (void)searchBarSearchButtonClicked:(STSearchBar *)searchBar{
    
}                    // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(STSearchBar *)searchBar{
  
    [self.maskView removeFromSuperview];
    [self.searchTableView removeFromSuperview];
    
}                  // called when cancel button pressed
// called when cancel button pressed


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.maskView removeFromSuperview];
    [self.searchTableView removeFromSuperview];

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
