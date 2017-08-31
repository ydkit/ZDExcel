//
//  LeftTableViewCell.m
//  ZDExcel
//
//  Created by Dong on 2017/8/28.
//  Copyright © 2017年 Dong. All rights reserved.
//


#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0 green:((float)(((hex) & 0xFF00) >> 8))/255.0 blue:((float)((hex) & 0xFF)) / 255.0 alpha:1.0]


#import "LeftTableViewCell.h"

#import <Masonry.h>

@interface LeftTableViewCell ()

@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation LeftTableViewCell

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
        
        [self.contentView setBackgroundColor:COLORHEX(0xe8e8e8)];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(0.f);
            make.bottom.right.mas_offset(-.5f);
        }];
        
    }
    return self;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLORHEX(0x9b9b9b)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _titleLabel;
}

- (void)reloadDataWithTitle:(NSString *)title {
    [_titleLabel setText:title];
}

@end
