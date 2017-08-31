//
//  ViewController.m
//  ZDExcel
//
//  Created by Dong on 2017/8/24.
//  Copyright © 2017年 Dong. All rights reserved.
//



#import "ViewController.h"

#import "ZDExcelView.h"

@interface ViewController ()<ZDExcelViewDelegate>

@property (nonatomic,strong) ZDExcelView * excelView;
@property (nonatomic,strong) NSMutableArray * dataArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZDExcelView * excelView = [[ZDExcelView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:excelView];
    excelView.delegate = self;
    self.excelView = excelView;
    [self.view setBackgroundColor:[UIColor greenColor]];
    
 // 2011 淘宝真个拆成了三家公司 淘宝，一淘，聚划算
    NSArray * titleArr = @[@"日期",@"姓名",@"电话次数",@"QQ次数",@"微信次数",@"短信次数",@"邮件次数",@"拜访次数"];
    NSMutableArray * dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i ++) {
        NSInteger count = titleArr.count;
        NSMutableArray * dataArrTmp = [NSMutableArray array];
        for (NSInteger j = 0; j < count ; j ++) {

            if (j == 0) {
                [dataArrTmp addObject:[NSString stringWithFormat:@"%ld月2日",i]];
            }else{
                [dataArrTmp addObject:[NSString stringWithFormat:@"%u",arc4random()%100]];
//                [dataArrTmp addObject:[NSString stringWithFormat:@"%ld",j]];
            }
        }
        
        [dataArr addObject:dataArrTmp];
        
    }
    self.dataArr = dataArr;
    [excelView reloaDataWithTitleArr:titleArr dataArr:dataArr];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath tableViewIndexPath:(NSIndexPath *)tableViewIndexPath {
    NSArray * arr = [self.dataArr objectAtIndex:tableViewIndexPath.row];
    NSString * content = [arr objectAtIndex:indexPath.item + 1] ;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"点击" message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"😯" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray * titleArr = @[@"日期",@"电话次数",@"QQ次数",@"微信次数",@"短信次数",@"邮件次数",@"拜访次数"];
    NSMutableArray * dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i ++) {
        NSInteger count = titleArr.count;
        NSMutableArray * dataArrTmp = [NSMutableArray array];
        for (NSInteger j = 0; j < count ; j ++) {
            
            if (j == 0) {
                [dataArrTmp addObject:[NSString stringWithFormat:@"%ld月2日",i]];
            }else{
                [dataArrTmp addObject:[NSString stringWithFormat:@"%u",arc4random()%100]];
                //                [dataArrTmp addObject:[NSString stringWithFormat:@"%ld",j]];
            }
        }
        
        [dataArr addObject:dataArrTmp];
        
    }
    self.dataArr = dataArr;
    
    [self.excelView reloaDataWithTitleArr:titleArr dataArr:dataArr];
}




@end
