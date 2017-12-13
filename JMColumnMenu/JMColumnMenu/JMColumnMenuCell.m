//
//  JMColumnMenuCell.m
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenuCell.h"
#import "UIView+JM.h"
#import "JMConfig.h"

@interface JMColumnMenuCell()

/** 空View */
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation JMColumnMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //空View
        self.emptyView = [[UIView alloc] initWithFrame:CGRectZero];
        self.emptyView.backgroundColor = [JMConfig colorWithHexString:@"#f4f4f4"];
        [self.contentView addSubview:self.emptyView];
        
        //标题
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.layer.masksToBounds = YES;
        self.title.layer.cornerRadius = 5.f;
        self.title.backgroundColor = [JMConfig colorWithHexString:@"#f4f4f4"];
        [self.emptyView addSubview:self.title];
        
        //关闭按钮
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JMColumnMenu" ofType:@"bundle"]];
        NSString *path = [bundle pathForResource:@"close" ofType:@"png"];
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        self.closeBtn.hidden = YES;
        [self.emptyView addSubview:self.closeBtn];
        
        //添加按钮
        NSString *add_path = [bundle pathForResource:@"add" ofType:@"png"];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setImage:[UIImage imageWithContentsOfFile:add_path] forState:UIControlStateNormal];
        self.addBtn.hidden = YES;
        [self.emptyView addSubview:self.addBtn];
        
    }
    return self;
}

- (void)updateAllFrame:(JMColumnMenuModel *)model {
    self.emptyView.frame = CGRectMake(5, 6.5, self.contentView.width - 10, self.contentView.height - 13);
    
    self.title.size = [self returnTitleSize];

    if (model.showAdd) {
        self.title.center = CGPointMake(self.emptyView.width / 2 + 6, self.emptyView.height / 2);
    } else {
        self.title.center = CGPointMake(self.emptyView.width / 2, self.emptyView.height / 2);
    }

    self.closeBtn.frame = CGRectMake(self.contentView.width - 16, 0, 18, 18);

    self.addBtn.size = CGSizeMake(10, 10);
    self.addBtn.centerY = self.title.centerY;
    self.addBtn.x = CGRectGetMinX(self.title.frame) - 12;
}

- (void)setModel:(JMColumnMenuModel *)model {
    _model = model;
    
    //标题文字处理
    if (model.title.length == 2) {
        self.title.font = [UIFont systemFontOfSize:15];
    } else if (model.title.length == 3) {
        self.title.font = [UIFont systemFontOfSize:14];
    } else if (model.title.length == 4) {
        self.title.font = [UIFont systemFontOfSize:13];
    } else if (model.title.length > 4) {
        self.title.font = [UIFont systemFontOfSize:12];
    }
    
    if (model.type == JMColumnMenuTypeTencent) {
        self.title.text = model.title;
        self.closeBtn.hidden = !model.selected;
    } else if (model.type == JMColumnMenuTypeTouTiao) {
        self.closeBtn.hidden = !model.selected;
        self.title.text = [NSString stringWithFormat:@"%@",model.title];
        if (model.showAdd) {
            self.addBtn.hidden = NO;
        } else {
            self.addBtn.hidden = YES;
        }
    }
    
    [self updateAllFrame:model];
}

- (CGSize)returnTitleSize {
    CGFloat maxWidth = self.emptyView.width - 12;
    CGSize size = [self.title.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:self.title.font}
                                                context:nil].size;
    return size;
}


@end
