//
//  JMColumnMenuFooterView.m
//  JMColumnMenu
//
//  Created by JM on 2017/12/18.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenuFooterView.h"
#import "UIView+JM.h"

@interface JMColumnMenuFooterView()

/** 标题 */
@property (nonatomic, strong) UILabel *title;
/** 描述 */
@property (nonatomic, strong) UILabel *detail;

@end

@implementation JMColumnMenuFooterView


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
