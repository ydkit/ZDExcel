//
//  ShowCollectionViewCell.m
//  ZDExcel
//
//  Created by Dong on 2017/8/24.
//  Copyright © 2017年 Dong. All rights reserved.
//

#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF)) / 255.0 alpha:1.0]

#import "ShowCollectionViewCell.h"

#import <Masonry.h>

@implementation ShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.title2Label = [[UILabel alloc] init];
        [self.contentView addSubview:self.title2Label];
        [self.title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        [self.title2Label setTextAlignment:NSTextAlignmentCenter];
        
     }
    return self;
}


@end
