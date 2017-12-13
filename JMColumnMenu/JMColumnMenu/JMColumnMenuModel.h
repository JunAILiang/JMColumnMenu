//
//  JMColumnMenuModel.h
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/8.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMColumnMenu.h"

@interface JMColumnMenuModel : NSObject

/** title */
@property (nonatomic, copy) NSString *title;
/** 是否选中 */
@property (nonatomic, assign) BOOL selected;
/** 是否允许删除 */
@property (nonatomic, assign) BOOL resident;
/** 是否显示加号 */
@property (nonatomic, assign) BOOL showAdd;
/** type */
@property (nonatomic, assign) JMColumnMenuType type;

@end
