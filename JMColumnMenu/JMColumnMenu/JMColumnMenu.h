//
//  JMColumnMenuController.h
//  JMCollectionView
//
//  Created by JM on 2017/12/11.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JMColumnMenuType) {
    JMColumnMenuTypeTencent, //腾讯新闻
    JMColumnMenuTypeTouTiao, //今日头条
};

@protocol JMColumnMenuDelegate <NSObject>

/**
 * tagsArr 排序后的选择数组
 * otherArr 排序后未选择数组
 */
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr;

/**
 * 点击的标题
 * 对应的index
 */
- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index;

@end

@interface JMColumnMenu : UIViewController

/**
 * 初始化方法
 */
+ (instancetype)columnMenuWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate;
- (instancetype)initWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate;

/** 代理 */
@property (nonatomic, weak) id <JMColumnMenuDelegate>delegate;
/** 类型 */
@property (nonatomic, assign) JMColumnMenuType type;

@end
