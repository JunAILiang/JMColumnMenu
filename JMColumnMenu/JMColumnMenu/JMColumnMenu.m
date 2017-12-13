//
//  JMColumnMenuController.m
//  JMCollectionView
//
//  Created by JM on 2017/12/11.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenu.h"
#import "JMColumnMenuCell.h"
#import "JMColumnMenuHeaderView.h"
#import "JMColumnMenuModel.h"
#import "UIView+JM.h"

#define CELLID @"CollectionViewCell"
#define HEADERID @"headerId"

@interface JMColumnMenu ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 导航栏的view */
@property (nonatomic, weak) UIView *navView;
/** navTitle */
@property (nonatomic, weak) UILabel *navTitle;
/** navColseBtn */
@property (nonatomic, weak) UIButton *navCloseBtn;
/** tags */
@property (nonatomic, strong) NSMutableArray *tagsArrM;
/** others */
@property (nonatomic, strong) NSMutableArray *otherArrM;
/** CollectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 头部视图 */
@property (nonatomic, weak) JMColumnMenuHeaderView *headerView;
/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
/** 引用headView编辑字符串 */
@property (nonatomic, copy) NSString *editBtnStr;

@end

@implementation JMColumnMenu

- (NSMutableArray *)tagsArrM {
    if (!_tagsArrM) {
        _tagsArrM = [NSMutableArray array];
    }
    return _tagsArrM;
}

- (NSMutableArray *)otherArrM {
    if (!_otherArrM) {
        _otherArrM = [NSMutableArray array];
    }
    return _otherArrM;
}

+ (instancetype)columnMenuWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate{
    return [[self alloc] initWithTagsArrM:tagsArrM OtherArrM:otherArrM Type:type Delegate:delegate];
}

- (instancetype)initWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(JMColumnMenuType)type Delegate:(id<JMColumnMenuDelegate>)delegate{
    if (self = [super init]) {
        self.type = type;
        self.delegate = delegate;
        self.editBtnStr = @"编辑";
        
        for (int i = 0; i < tagsArrM.count; i++) {
            JMColumnMenuModel *model = [[JMColumnMenuModel alloc] init];
            model.title = tagsArrM[i];
            model.type = type;
            if (self.type == JMColumnMenuTypeTouTiao) {
                model.showAdd = NO;
                model.selected = NO;
                if (i == 0) {
                    model.resident = YES;
                }
            } else if (type == JMColumnMenuTypeTencent) {
                if (i != 0) {
                    model.selected = YES;
                } else {
                    model.selected = NO;
                    model.resident = YES;
                }
            }
            [self.tagsArrM addObject:model];
        }
        
        for (NSString *title in otherArrM) {
            JMColumnMenuModel *model = [[JMColumnMenuModel alloc] init];
            model.title = title;
            if (self.type == JMColumnMenuTypeTouTiao) {
                model.showAdd = YES;
            }
            model.type = type;
            model.selected = NO;
            [self.otherArrM addObject:model];
        }
        
        //初始化UI
        [self initColumnMenuUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

}

#pragma mark - 初始化UI
- (void)initColumnMenuUI {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navView.backgroundColor = [UIColor blackColor];
    self.navView = navView;
    [self.view addSubview:navView];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.navView.centerX - 100, self.navView.centerY, 200, 20)];
    navTitle.text = @"频道定制";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
    self.navTitle = navTitle;
    [self.navView addSubview:navTitle];
    
    UIButton *navCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navCloseBtn.frame = CGRectMake(self.navView.width - 30, CGRectGetMinY(self.navTitle.frame), 20, 20);
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JMColumnMenu" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"close_one" ofType:@"png"];
    [navCloseBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    self.navCloseBtn = navCloseBtn;
    [navCloseBtn addTarget:self action:@selector(navCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navCloseBtn];
    
    //视图布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    //UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), self.view.width, self.view.height - self.navView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    //注册cell
    [self.collectionView registerClass:[JMColumnMenuCell class] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[JMColumnMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    
    //添加长按的手势
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    if (self.type == JMColumnMenuTypeTencent) {
        [self.collectionView addGestureRecognizer:self.longPress];
    }
   
}

#pragma mark - 手势识别
- (void)longPress:(UIGestureRecognizer *)longPress {
    NSLog(@"长按手势开始");
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
    //判断是否可以移动
    //    if (indexPath.item == 0) {
    //        return;
    //    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (indexPath.item == 0) {
            return;
        }
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        if (indexPath.item == 0) {
            return;
        }
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}


#pragma mark - UICollectionViewDataSource
//一共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.tagsArrM.count;
    } else {
        return self.otherArrM.count;
    }
}

//每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMColumnMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.model = self.tagsArrM[indexPath.item];
        if (indexPath.item == 0) { //第一个按钮样式区别
            cell.title.textColor = [UIColor redColor];
        }
    } else {
        cell.model = self.otherArrM[indexPath.item];
    }
    
    //关闭按钮点击事件
    cell.closeBtn.tag = indexPath.item;
    [cell.closeBtn addTarget:self action:@selector(colseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//和tableView差不多, 可设置头部和尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        JMColumnMenuHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERID forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[JMColumnMenuHeaderView alloc] init];
        }
        if (indexPath.section == 0) {
            headerView.titleStr = @"已选频道";
            headerView.detailStr = @"按住拖动调整排序";
            if (self.type == JMColumnMenuTypeTouTiao) {
                [headerView.editBtn setTitle:self.editBtnStr forState:UIControlStateNormal];
                headerView.editBtn.hidden = NO;
                [headerView.editBtn addTarget:self action:@selector(headViewEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
        } else if (indexPath.section == 1) {
            headerView.editBtn.hidden = YES;
            headerView.titleStr = @"频道推荐";
            headerView.detailStr = @"点击添加频道";
        }
        self.headerView = headerView;
        return headerView;
    }
    
    return nil;
}

#pragma mark - 头部编辑按钮点击事件
- (void)headViewEditBtnClick {
    NSLog(@"头部视图");
    if ([self.editBtnStr containsString:@"编辑"]) {
        self.editBtnStr = @"完成";
        [self.headerView.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        [self.collectionView addGestureRecognizer:self.longPress];
        
        for (int i = 0; i < self.tagsArrM.count; i++) {
            JMColumnMenuModel *model = self.tagsArrM[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
    } else {
        self.editBtnStr = @"编辑";
        [self.headerView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self.collectionView removeGestureRecognizer:self.longPress];
        
        for (int i = 0; i < self.tagsArrM.count; i++) {
            JMColumnMenuModel *model = self.tagsArrM[i];
            if (i == 0) {
                model.selected = NO;
            } else {
                model.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}

//头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 40);
}


//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.width * 0.25 - 10, 53);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JMColumnMenuModel *model;
    if (indexPath.section == 0) {
        model = self.tagsArrM[indexPath.item];
        //判断是否是编辑状态
        if ([self.editBtnStr containsString:@"编辑"]) {
            //判断是否是头条,是就直接回调出去
            if (model.type == JMColumnMenuTypeTouTiao) { //头条
                if ([self.delegate respondsToSelector:@selector(columnMenuDidSelectTitle:Index:)]) {
                    [self.delegate columnMenuDidSelectTitle:model.title Index:indexPath.item];
                }
                [self navCloseBtnClick];
                return;
            }
        }
        
        //判断是否可以删除
        if (model.resident) {
            return;
        }
        
        model.selected = NO;
        model.showAdd = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        [self.tagsArrM removeObjectAtIndex:indexPath.item];
        [self.otherArrM insertObject:model atIndex:0];
        
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    } else if (indexPath.section == 1) {
        JMColumnMenuCell *cell = (JMColumnMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.closeBtn.hidden = YES;
        model  = self.otherArrM[indexPath.item];
        if (model.type == JMColumnMenuTypeTencent) {
            model.selected = YES;
        } else if (model.type == JMColumnMenuTypeTouTiao) {
            if ([self.editBtnStr containsString:@"编辑"]) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
        model.showAdd = NO;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        [self.otherArrM removeObjectAtIndex:indexPath.item];
        [self.tagsArrM addObject:model];
        
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:self.tagsArrM.count-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
        
    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - item关闭按钮点击事件
- (void)colseBtnClick:(UIButton *)sender {
    JMColumnMenuModel *model = self.tagsArrM[sender.tag];
    model.selected = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self.tagsArrM removeObjectAtIndex:sender.tag];
    [self.otherArrM insertObject:model atIndex:0];
    
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    
    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

//在开始移动是调动此代理方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"开始移动");
    return YES;
}

//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"结束移动");
    JMColumnMenuModel *model;
    if (sourceIndexPath.section == 0) {
        model = self.tagsArrM[sourceIndexPath.item];
        [self.tagsArrM removeObjectAtIndex:sourceIndexPath.item];
    } else {
        model = self.otherArrM[sourceIndexPath.item];
        [self.otherArrM removeObjectAtIndex:sourceIndexPath.item];
    }
    
    if (destinationIndexPath.section == 0) {
        model.selected = YES;
        [self.tagsArrM insertObject:model atIndex:destinationIndexPath.item];
    } else if (destinationIndexPath.section == 1) {
        model.selected = NO;
        [self.otherArrM insertObject:model atIndex:destinationIndexPath.item];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    
    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

#pragma mark - 刷新tag
- (void)refreshDelBtnsTag {
    for (JMColumnMenuCell *cell in self.collectionView.visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        cell.closeBtn.tag = indexPath.item;
    }
}

#pragma mark - 更新block数组
- (void)updateBlockArr {
    NSMutableArray *tempTagsArrM = [NSMutableArray array];
    NSMutableArray *tempOtherArrM = [NSMutableArray array];
    for (JMColumnMenuModel *model in self.tagsArrM) {
        [tempTagsArrM addObject:model.title];
    }
    for (JMColumnMenuModel *model in self.otherArrM) {
        [tempOtherArrM addObject:model.title];
    }
    
    if ([self.delegate respondsToSelector:@selector(columnMenuTagsArr:OtherArr:)]) {
        [self.delegate columnMenuTagsArr:tempTagsArrM OtherArr:tempOtherArrM];
    }
}

#pragma mark - 导航栏右侧关闭按钮点击事件
- (void)navCloseBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
