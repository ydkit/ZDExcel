//
//  CoreTableViewCell.h
//  ZDExcel
//
//  Created by Dong on 2017/8/24.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoreTableViewCellDelegate <NSObject>


/**
 cell内部的collectionView的滑动代理

 @param scrollViewCollectionView cell内部的collectionView
 */
- (void)scrollViewCollectionViewDidScroll:(UIScrollView *)scrollViewCollectionView;

@optional
/**
 cell内部的collectionView的item的点击事件的监听

 @param collectionViewCore cell内部的collectionView
 @param indexPath cell内部的collectionView的indexPath
 @param tableViewIndexPath cell内部的collectionView所属的tableView的cell的indexPath
 */
- (void)collectionViewCore:(UICollectionView *)collectionViewCore didSelectItemAtIndexPath:(NSIndexPath *)indexPath  tableViewIndexPath:(NSIndexPath *)tableViewIndexPath ;

@end

@interface CoreTableViewCell : UITableViewCell


@property (weak,nonatomic) id<CoreTableViewCellDelegate> delegate;


/**
 <#Description#>

 @param x <#x description#>
 */
- (void)reloadDataWithContentOffSetX:(CGFloat)x;

- (void)reloadDataArr:(NSArray *)arr tableViewIndexPath:(NSIndexPath *)tableViewIndexPath ;

@end
