//
//  ZDExcelView.m
//  ZDExcel
//
//  Created by Dong on 2017/8/28.
//  Copyright © 2017年 Dong. All rights reserved.
//

#define WWWW CGRectGetWidth([[UIScreen mainScreen] bounds])
#define HHHH CGRectGetHeight([[UIScreen mainScreen] bounds])
#define ItemWidth  100.f
#define ItemHeight 40.f

//alpha通道RGB颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//alpha通道十六进制颜色
#define HEXCOLOR(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:(a)]
//通道十六进制颜色
#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF)) / 255.0 alpha:1.0]

#import "ZDExcelView.h"

#import "ShowCollectionViewCell.h"
#import "CoreTableViewCell.h"
#import "LeftTableViewCell.h"

@interface ZDExcelView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CoreTableViewCellDelegate>

@property (nonatomic,strong) UIView * contentView;//框架view
@property (nonatomic,strong) UILabel * titleLabel;//左角标
@property (nonatomic,strong) UITableView * leftTableView;//左侧tableView
@property (nonatomic,strong) UITableView * coreTableView;//coretableView
@property (nonatomic,strong) UICollectionView * rightTopCollectionView;//顶部collectionview
@property (nonatomic,strong) UICollectionView * coreCollectionView;//核心view

@property (nonatomic,strong) NSArray * leftArr;
@property (nonatomic,strong) NSArray * topArr;//核心view
@property (nonatomic,strong) NSArray * dataArr;//核心view

@property (nonatomic,assign) CGFloat contentOffSetX;




@end

@implementation ZDExcelView

- (void)reloaDataWithTitleArr:(NSArray *)titleArr dataArr:(NSArray *)dataArr {
    
    if (!titleArr ||
        !dataArr) {
        NSString * content = !titleArr ? @"标题数据源格式错误" : @"核心数据源格式错误";
        NSLog(@"%@",content);
        return;
    }
    
    if (titleArr.count <= 1 ||
        dataArr.count <= 1) {
        
        NSLog(@"数据源不能少于一个数据");
        return;
    }
    
    if (titleArr.count != [[dataArr firstObject] count] ) {
         NSLog(@"两组数据的数量不一致: %ld .. %ld",titleArr.count,[[dataArr firstObject] count]);
        return;
    }
    
    if (titleArr.count) {
        [self.titleLabel setText:[titleArr firstObject]];
    }
    NSMutableArray * titleArrRight = [NSMutableArray arrayWithArray:titleArr];
    [titleArrRight removeObjectAtIndex:0];
    self.topArr = (NSArray *)titleArrRight;
    self.rightTopCollectionView.contentSize = CGSizeMake((ItemWidth + .5f) * self.topArr.count - .5f, ItemHeight);

    [self.rightTopCollectionView reloadData];
    
    NSMutableArray * coreArrLeft = [NSMutableArray array];
    NSMutableArray * coreArrRight = [NSMutableArray array];
    for (id object  in dataArr) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray * arrTemp = (NSArray *)object;
            NSMutableArray * arr = [NSMutableArray arrayWithArray:arrTemp];
            [coreArrLeft addObject:[arr firstObject]];
            
            NSMutableArray * arrRight = [NSMutableArray arrayWithArray:arr];
            [arrRight removeObjectAtIndex:0];
            [coreArrRight addObject:arrRight];
            
        }else{
            NSLog(@"核心数据源格式错误,应为嵌套数组，不是一层数组");
            return;
        }
    }
    self.leftArr = coreArrLeft;
    self.dataArr = coreArrRight;
    [self.leftTableView reloadData];
    [self.coreTableView reloadData];
}


/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
 */
//- (void)drawRect:(CGRect)rect {
//
//  
//    
//}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftTableView];
    [self.contentView addSubview:self.rightTopCollectionView];
    //    [self.contentView addSubview:self.coreCollectionView];
    [self.contentView addSubview:self.coreTableView];
    
 
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, WWWW - 20, HHHH - 64 * 2)];
        [_contentView setBackgroundColor:COLORHEX(0xe8e8e8)];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ItemWidth - .5f, ItemHeight - .5f)];
        [_titleLabel setTextColor:COLORHEX(0x4a4a4a)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:COLORHEX(0xf3f3f3)];
        
    }
    return _titleLabel;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ItemHeight, ItemWidth, 500) style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        NSString * itemName = NSStringFromClass([LeftTableViewCell class]);
        
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:itemName];
        

    }
    return _leftTableView;
}

- (UITableView *)coreTableView {
    if (!_coreTableView) {
        _coreTableView = [[UITableView alloc] initWithFrame:CGRectMake(ItemWidth, ItemHeight, WWWW - 20 - ItemWidth,500) style:UITableViewStyleGrouped];
        _coreTableView.delegate = self;
        _coreTableView.dataSource = self;
        _coreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSString * itemName = NSStringFromClass([CoreTableViewCell class]);
        
        [_coreTableView registerClass:[CoreTableViewCell class] forCellReuseIdentifier:itemName];
        
    }
    return _coreTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.leftArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        NSString * itemName = NSStringFromClass([LeftTableViewCell class]);

         LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:itemName];
   
        NSString * title = [self.leftArr objectAtIndex:indexPath.row];
        [cell reloadDataWithTitle:title];
        return cell;
    }else {
        CoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoreTableViewCell class])];
        cell.delegate = self;
        [cell reloadDataWithContentOffSetX:self.contentOffSetX];
        NSArray * arr = [self.dataArr objectAtIndex:indexPath.row];
        [cell reloadDataArr:arr tableViewIndexPath:indexPath];
        return cell;
    }
    
}

- (UICollectionView *)rightTopCollectionView {
    if (!_rightTopCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = .5f;
        layout.minimumInteritemSpacing = .5f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _rightTopCollectionView = [[UICollectionView alloc ] initWithFrame:CGRectMake(ItemWidth, 0, WWWW - 20 - ItemWidth,ItemHeight) collectionViewLayout:layout];
        _rightTopCollectionView.delegate = self;
        _rightTopCollectionView.dataSource = self;
        _rightTopCollectionView.bounces = NO;
        [_rightTopCollectionView setBackgroundColor:COLORHEX(0xe8e8e8)];
        NSString * itemName = NSStringFromClass([ShowCollectionViewCell class]);
        //        [_rightTopCollectionView registerNib:[UINib nibWithNibName:itemName bundle:nil] forCellWithReuseIdentifier:itemName];
        [_rightTopCollectionView registerClass:[ShowCollectionViewCell class] forCellWithReuseIdentifier:itemName];
         
 
    }
    return _rightTopCollectionView;
}

- (UICollectionView *)coreCollectionView {
    if (!_coreCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.f;
        layout.minimumInteritemSpacing = .5f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _coreCollectionView = [[UICollectionView alloc ] initWithFrame:CGRectMake(ItemWidth, ItemHeight, WWWW - 20 - ItemWidth,500) collectionViewLayout:layout];
        _coreCollectionView.delegate = self;
        _coreCollectionView.dataSource = self;
        [_coreCollectionView setBackgroundColor:[UIColor greenColor]];
    
        
        NSString * itemName = NSStringFromClass([ShowCollectionViewCell class]);
        //        [_rightTopCollectionView registerNib:[UINib nibWithNibName:itemName bundle:nil] forCellWithReuseIdentifier:itemName];
        
        [_coreCollectionView registerClass:[ShowCollectionViewCell class] forCellWithReuseIdentifier:itemName];
        
    }
    return _coreCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == _rightTopCollectionView) {
        return 1;
    }
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _rightTopCollectionView) {
        return self.topArr.count;
    }
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ItemWidth, ItemHeight - .5f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShowCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShowCollectionViewCell class]) forIndexPath:indexPath];
    NSString * title = [self.topArr objectAtIndex:indexPath.item];
    [item.title2Label setText:title];
    [item.title2Label setTextColor:COLORHEX(0x4a4a4a)];
    [item.title2Label setFont:[UIFont systemFontOfSize:14.f]];
    [item.title2Label setTextAlignment:NSTextAlignmentCenter];
    [item.title2Label setBackgroundColor:COLORHEX(0xf3f3f3)];
    
    
    return item;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, .5f, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString * title = [self.topArr objectAtIndex:indexPath.item];
//    UIAlertController * alert = [[UIAlertController alloc]init];
    
}


#pragma mark -- 滚动同步处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.coreTableView) {
        //        if (self.coreTableView.contentOffset.x != 0) {
        //            return;
        //        }
        if (self.coreTableView.contentOffset.x!= 0) {
            self.rightTopCollectionView.contentOffset = CGPointMake( self.coreTableView.contentOffset.x, self.rightTopCollectionView.contentOffset.y);
            
        }
        
        if (self.coreTableView.contentOffset.y!= 0) {
            self.leftTableView.contentOffset = CGPointMake( self.leftTableView.contentOffset.x, self.coreTableView.contentOffset.y);
            
        }
    }else if (scrollView == self.rightTopCollectionView) {
        self.contentOffSetX = scrollView.contentOffset.x;
        
        NSArray * cells = self.coreTableView.visibleCells;
        for (CoreTableViewCell * cell in cells) {
            [cell reloadDataWithContentOffSetX:self.contentOffSetX];
        }
        //        self.coreTableView.contentOffset = CGPointMake( self.rightTopCollectionView.contentOffset.x, self.coreTableView.contentOffset.y);
    }else if (scrollView == self.leftTableView) {
        
        self.coreTableView.contentOffset = CGPointMake( self.coreTableView.contentOffset.x, self.leftTableView.contentOffset.y);
    }
}

- (void)scrollViewCollectionViewDidScroll:(UIScrollView *)scrollViewCollectionView {
    self.rightTopCollectionView.contentOffset = CGPointMake( scrollViewCollectionView.contentOffset.x, self.rightTopCollectionView.contentOffset.y);
    self.contentOffSetX = scrollViewCollectionView.contentOffset.x;
    //    [self.coreTableView reloadData];
    NSArray * cells = self.coreTableView.visibleCells;
    for (CoreTableViewCell * cell in cells) {
        [cell reloadDataWithContentOffSetX:self.contentOffSetX];
    }
}

- (void)collectionViewCore:(UICollectionView *)collectionViewCore didSelectItemAtIndexPath:(NSIndexPath *)indexPath  tableViewIndexPath:(NSIndexPath *)tableViewIndexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:tableViewIndexPath:)]) {
        [self.delegate collectionView:collectionViewCore didSelectItemAtIndexPath:indexPath  tableViewIndexPath:tableViewIndexPath];
    }
}

@end
