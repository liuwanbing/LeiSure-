//
//  ReadViewController.m
//  test
//
//  Created by lanou on 16/6/13.
//  Copyright © 2016年 刘万兵. All rights reserved.
//

#import "ReadViewController.h"

#import "ConstantDefineHeader.h"
#import "URLDefineHeader.h"
#import "ReadTypeModel.h"
#import "ReadTypeCollectionCell.h"
#import "CollectionViewCellFactory.h"
#import "ListTableViewController.h"
#import "CarouselView.h"



@interface ReadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//显示阅读分类
@property (nonatomic,strong) UICollectionView *readTypeCollectionView;

@property (nonatomic,strong)NSMutableArray *dataArray;

//显示轮播图的iamgeview
@property (nonatomic,strong)UIImageView *imageView;

//播放轮播图的scrollview
@property (nonatomic,strong)UIScrollView *scrollView;


//页面指示器
@property (nonatomic,strong)UIPageControl *pageController;

@property (nonatomic,strong)NSArray *array;



//轮播图数组
@property (nonatomic,strong)NSArray *carouselDataArray;



@end

@implementation ReadViewController

-(NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BaseCollectionViewCell *cell = [CollectionViewCellFactory CellWithCollectionView:collectionView identifier:@"ReadType" indexPath:indexPath];
    //调用赋值方法,调用一个通过模型的属性给cell赋值的方法，
    [cell setContentWithModel:self.dataArray[indexPath.row]];
    
    return cell;
    
}


#pragma mark--------点击阅读单元格跳转的方法---
//点击cell跳转的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewController *listVC = [[ListTableViewController alloc] init];
    listVC.typeID = self.array[indexPath.row];
    [self.navigationController pushViewController:listVC animated:YES];
}

//点击按钮打开抽屉
- (IBAction)openDrawer:(id)sender {
    //用appdelegate来调用打开或者关闭
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate openDrawer];
    
    }

- (void)createSubViews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //最小行间距
    layout.minimumLineSpacing = 5;
    //最小item间距
    layout.minimumInteritemSpacing = 5;
    //cell的大小
    layout.itemSize = CGSizeMake((KscreenWidth - 10) / 3, (KscreenWidth - 10) / 3);
    self.readTypeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KscreenHeight - KscreenWidth,KscreenWidth,KscreenWidth) collectionViewLayout:layout];
    [self.view addSubview:self.readTypeCollectionView];
    self.readTypeCollectionView.delegate = self;
    self.readTypeCollectionView.dataSource = self;
    //从xib注册cell
    [self.readTypeCollectionView registerNib:[UINib nibWithNibName:@"ReadTypeCollectionCell"bundle:nil]forCellWithReuseIdentifier:@"ReadType"];
}

//请求数据
- (void)requestData {
    
    [RequestTool requestWithType:GET URLString:KreadList_URl parameter:nil callBack:^(NSData *data, NSError *error) {
        //json
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = jsonDic[@"data"];
        NSArray *array = dic[@"list"];
        //将请求得到的数据转换为model
        for (NSDictionary *tempDic in array) {
            ReadTypeModel *model = [ReadTypeModel modelWithDic:tempDic];
            [self.dataArray addObject:model];
        }
        
        //回主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.readTypeCollectionView reloadData];
            //保存轮播图数据
            self.carouselDataArray = jsonDic[@"data"][@"carousel"];
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (NSDictionary *dic  in self.carouselDataArray) {
                [imagesArray addObject:dic[@"img"]];
            }
            //拿到数据后再初始化轮播图
            [self createCarousView:imagesArray];
        });
    }];
}

//初始化轮播图
-(void)createCarousView:(NSArray *)imageRULs {
    CarouselView *carousel = [[CarouselView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - KscreenWidth -5 -64) iamgeURLS:imageRULs];
    [self.view addSubview:carousel];
    //轮播图点击
    carousel.imageClickBlock = ^(NSInteger index) {
    
    
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSubViews];
    [self requestData];
    self.array = @[@1, @27, @8, @23, @14, @18, @10, @6, @29];

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
