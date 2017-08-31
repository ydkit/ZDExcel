//
//  ZDExcelView.h
//  ZDExcel
//
//  Created by Dong on 2017/8/28.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDExcelViewDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  tableViewIndexPath:(NSIndexPath *)tableViewIndexPath ;

@end

@interface ZDExcelView : UIView

- (void)reloaDataWithTitleArr:(NSArray *)titleArr dataArr:(NSArray *)dataArr;

@property (nonatomic,weak) id<ZDExcelViewDelegate> delegate;

@end
