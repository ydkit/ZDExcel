//
//  CoreTableViewCell.m
//  ZDExcel
//
//  Created by Dong on 2017/8/24.
//  Copyright © 2017年 Dong. All rights reserved.
//

#define ItemWidth  100.f
#define ItemHeight 40.f

#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF)) / 255.0 alpha:1.0]

#define WWWW CGRectGetWidth([[UIScreen mainScreen] bounds])
#define HHHH CGRectGetHeight([[UIScreen mainScreen] bounds])

#import "CoreTableViewCell.h"

#import "ShowCollectionViewCell.h"

#import <Masonry.h>

@interface CoreTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * coreCollectionView;//核心view
@property (nonatomic,strong) NSArray * dataArr;//核心view
@property (nonatomic,strong) NSIndexPath * tableViewIndexPath;//tableview的indexPath



@end

@implementation CoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coreCollectionView];
        [self.coreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
  
    }
    return self;
}

- (void)reloadDataArr:(NSArray *)arr tableViewIndexPath:(NSIndexPath *)tableViewIndexPath {
    if (!arr) {
        return;
    }
    
    if (arr.count <= 0) {
        return;
    }
    self.tableViewIndexPath = tableViewIndexPath;
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    self.coreCollectionView.contentSize = CGSizeMake((ItemWidth + .5f) * self.dataArr.count - .5f, ItemHeight);
    [self.coreCollectionView reloadData];

}

- (UICollectionView *)coreCollectionView {
    if (!_coreCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = .5f;
        layout.minimumInteritemSpacing = 1.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _coreCollectionView = [[UICollectionView alloc ] initWithFrame:CGRectZero collectionViewLayout:layout];
        _coreCollectionView.delegate = self;
        _coreCollectionView.dataSource = self;
        [_coreCollectionView setBackgroundColor:COLORHEX(0xe8e8e8)];
        _coreCollectionView.bounces = NO;
        
        NSString * itemName = NSStringFromClass([ShowCollectionViewCell class]);
        //        [_rightTopCollectionView registerNib:[UINib nibWithNibName:itemName bundle:nil] forCellWithReuseIdentifier:itemName];
        
        [_coreCollectionView registerClass:[ShowCollectionViewCell class] forCellWithReuseIdentifier:itemName];
        
    }
    return _coreCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ItemWidth, ItemHeight - .5f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShowCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShowCollectionViewCell class]) forIndexPath:indexPath];
    NSString * title = [self.dataArr objectAtIndex:indexPath.item];
    [item.title2Label setText:title];
    
    [item.title2Label setTextColor:COLORHEX(0x9b9b9b)];
    [item.title2Label setFont:[UIFont systemFontOfSize:15.f]];
    [item.title2Label setTextAlignment:NSTextAlignmentCenter];
    [item.title2Label setBackgroundColor:[UIColor whiteColor]];
    return item;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, .5f, 0);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionViewCore:didSelectItemAtIndexPath:tableViewIndexPath:)]) {
        [self.delegate collectionViewCore:collectionView didSelectItemAtIndexPath:indexPath tableViewIndexPath:self.tableViewIndexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(scrollViewCollectionViewDidScroll:)]) {
        [self.delegate scrollViewCollectionViewDidScroll:scrollView];
    }
}


/**
 表格在左右滑动过程中，上下滑动 会发生部分cell里的collectionview的偏移位置不同步

 @param x <#x description#>
 */
- (void)reloadDataWithContentOffSetX:(CGFloat)x {
    if ( self.coreCollectionView.contentOffset.x == x) {
        return;
    }
    self.coreCollectionView.contentOffset = CGPointMake(x, 0);
}


@end
