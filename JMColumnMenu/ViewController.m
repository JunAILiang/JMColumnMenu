//
//  ViewController.m
//  JMColumnMenu
//
//  Created by JM on 2017/12/12.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "ViewController.h"
#import "JMColumnMenu.h"


#import "UIView+JM.h"
#import "JMConfig.h"

@interface ViewController ()<JMColumnMenuDelegate>

/** menuView */
@property (nonatomic, strong) JMColumnMenu *menu;

@end

@implementation ViewController


+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor blackColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JM";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *arr = @[@"仿腾讯新闻",@"仿今日头条"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = kRandomColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        btn.centerX = self.view.width * 0.5 - 50;
        btn.width = 100;
        btn.height = 40;
        btn.y = i * 40 + 20 * (i + 1);
        btn.layer.cornerRadius = 4.f;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn {
    //初始化数据
    NSMutableArray *myTagsArrM = [NSMutableArray arrayWithObjects:@"要闻",@"视频",@"娱乐",@"军事",@"新时代",@"独家",@"广东",@"社会",@"图文",@"段子",@"搞笑视频", nil];
    NSMutableArray *otherArrM = [NSMutableArray arrayWithObjects:@"八卦",@"搞笑",@"短视频",@"图文段子",@"极限第一人", nil];
    
    if (btn.tag == 0) { //仿腾讯新闻
        JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:myTagsArrM OtherArrM:otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
        [self presentViewController:menuVC animated:YES completion:nil];
    } else if (btn.tag == 1) { //仿今日头条
        JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:myTagsArrM OtherArrM:otherArrM Type:JMColumnMenuTypeTouTiao Delegate:self];
        [self presentViewController:menuVC animated:YES completion:nil];
    }
}

#pragma mark - JMColumnMenuDelegate
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr {
    NSLog(@"选择数组---%@",tagsArr);
    NSLog(@"未选择数组%@",otherArr);
}

- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index {
    NSLog(@"点击的标题---%@  对应的index---%zd",title, index);
}


@end
