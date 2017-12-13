//
//  JMColumnMenuHeaderView.m
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenuHeaderView.h"
#import "UIView+JM.h"

@interface JMColumnMenuHeaderView()

/** 标题 */
@property (nonatomic, strong) UILabel *title;
/** 描述 */
@property (nonatomic, strong) UILabel *detail;

@end

@implementation JMColumnMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];

        self.detail = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detail.textColor = [UIColor lightGrayColor];
        self.detail.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.detail];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.cornerRadius = 6.f;
        self.editBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.editBtn.layer.borderWidth = 1.f;
        self.editBtn.hidden = YES;
        [self addSubview:self.editBtn];
        
        [self initFrame];
    }
    return self;
}

- (void)initFrame {
    CGFloat titleX = 12;
    CGFloat titleW = [self returnTitleSize].width;
    CGFloat titleH = 16;
    CGFloat titleY = self.height * 0.5 - titleH * 0.5;
    self.title.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat detailW = 160;
    CGFloat detailH = 16;
    CGFloat detailY = titleY;
    CGFloat detailX = CGRectGetMaxX(self.title.frame) + 10;
    self.detail.frame = CGRectMake(detailX, detailY, detailW, detailH);
    
    self.editBtn.centerY = self.title.centerY;
    self.editBtn.size = CGSizeMake(50, 24);
    self.editBtn.x = self.width - 60;
}

- (CGSize)returnTitleSize {
    CGSize size = [self.title.text boundingRectWithSize:CGSizeMake(self.width - 20, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:self.title.font}
                                                  context:nil].size;
    return size;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.title.text = titleStr;
    
    [self initFrame];
}

- (void)setDetailStr:(NSString *)detailStr {
    _detailStr = detailStr;
    
    self.detail.text = detailStr;
    
    [self initFrame];
}

@end






