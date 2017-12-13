# JMColumnMenu
仿腾讯新闻、今日头条栏目管理

# 如何使用
*   可以通过CocoaPods导入 ``` pod 'JMColumnMenu', '~> 1.0' ```
*   或者直接下载工程把JMColumnMenu导入到您的项目中


## 初始化数据
```
NSMutableArray *myTagsArrM = [NSMutableArray arrayWithObjects:@"要闻",@"视频",@"娱乐",@"军事",@"新时代",@"独家",@"广东",@"社会",@"图文",@"段子",@"搞笑视频", nil];
NSMutableArray *otherArrM = [NSMutableArray arrayWithObjects:@"八卦",@"搞笑",@"短视频",@"图文段子",@"极限第一人", nil];
```

## 一行代码调用
```
JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:myTagsArrM OtherArrM:otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
[self presentViewController:menuVC animated:YES completion:nil];
        
JMColumnMenu *menuVC1 = [[JMColumnMenu alloc] initWithTagsArrM:myTagsArrM OtherArrM:otherArrM Type:JMColumnMenuTypeTencent Delegate:self];
[self presentViewController:menuVC1 animated:YES completion:nil];
```
## 遵守代理
```
#pragma mark - JMColumnMenuDelegate
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr {
    NSLog(@"选择数组---%@",tagsArr);
    NSLog(@"未选择数组%@",otherArr);
}

- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index {
    NSLog(@"点击的标题---%@  对应的index---%zd",title, index);
}
```
联系我:<br>
   *    qq: 1245424073
[我的博客](https://ljmvip.cn)
