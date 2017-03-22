//
//  ShakeItemView.m
//  PartFunctionGather
//
//  Created by 冯文秀 on 17/3/10.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import "ShakeItemView.h"
#import "ShakeFlowLayout.h"
#import "CustomShakeCell.h"

@interface ShakeItemView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

// 可变数组，记录最终的移动后的数组顺序
@property(nonatomic, strong)NSMutableArray *lastArray;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)ShakeFlowLayout *flowLayout;

@property(nonatomic, strong)UILongPressGestureRecognizer *longPress;
// 当前被移动的indexPath
@property(nonatomic, strong)NSIndexPath *selectedIndexPath;
@property(nonatomic, assign)BOOL isMove;

@end



@implementation ShakeItemView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initLayoutShakeViewWithFrame:frame];
    }
    return self;
}

#pragma mark --- 初始化 标签视图 ---
- (void)initLayoutShakeViewWithFrame:(CGRect)frame
{
    self.flowLayout = [[ShakeFlowLayout alloc]init];
    self.flowLayout.minimumInteritemSpacing = 20;
    self.flowLayout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 80) collectionViewLayout:self.flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomShakeCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.titleArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"array"];
    if (self.titleArray == nil) {
        self.titleArray = @[@"剧情",@"爱情",@"喜剧",@"动作",@"动画",@"记录",@"科幻",@"古装",@"悬疑",@"惊悚"];
    }
    self.lastArray = [NSMutableArray arrayWithArray:self.titleArray];
    // 长按手势
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:self.longPress];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((frame.size.width - 50)/2, frame.size.height - 60, 50, 30);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
       
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lastArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomShakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.itemLabel.text = self.lastArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50 + 24, 24);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark --- 允许cell可以移动 ---
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --- 移动时执行的事件 ---
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *string = self.lastArray[sourceIndexPath.row];
    [self.lastArray removeObjectAtIndex:sourceIndexPath.row];
    [self.lastArray insertObject:string atIndex:destinationIndexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:self.lastArray] forKey:@"array"];
}


#pragma mark --- 长按手势事件 ---
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress;
{
    // 记录手势开始的位置
    CGPoint location = [longPress locationInView:self.collectionView
                        ];
    // 获取被选中的cell的indexPath
    self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    // 获取当前长按的cell
    CustomShakeCell *cell = (CustomShakeCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    // 手势开始时
    if (longPress.state == UIGestureRecognizerStateBegan) {
        // 记录起始选中的cell的indexPath
        NSIndexPath *indexPath = self.selectedIndexPath;
        // iOS9.0 后的新方法之一 开始在特定的索引路径上对cell进行交互
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        self.isMove = YES;
        [self manageAllCells];
        [self bigger:cell];
        
    }
    // 手势进行时
    else if (longPress.state == UIGestureRecognizerStateChanged)
    {
        // 在手势作用期间更新 交互时的目标位置
        [self.collectionView updateInteractiveMovementTargetPosition:location];
        
    }
    else // 结束移动时
    {
        // 完成手势动作后 结束交互的移动 并取消移动交互
        [self.collectionView endInteractiveMovement];
        [self.collectionView cancelInteractiveMovement];
        self.selectedIndexPath = nil;
        self.isMove = NO;
        [self smaller:cell];
        //[self manageAllCells];
    }
    
    
}

#pragma mark --- 管理当前视图内的所有cell 晃动 或者 不晃动 ---
- (void)manageAllCells
{
    NSArray *cells = [self.collectionView visibleCells];
    for (CustomShakeCell *cell in cells) {
        if (self.isMove == YES) {
            [cell startShaking];
        }
        else
        {
            [cell stopShaking];
        }
    }
}

# pragma mark --- 给被选中的cell 添加放大的动画 ---
- (void)bigger:(CustomShakeCell *)cell {
    [UIView animateWithDuration:0.1 animations:^{
        
        cell.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        
    }];
}

# pragma mark --- 给被选中的cell 返回原型 的动画 ---
- (void)smaller:(CustomShakeCell *)cell {
    [UIView animateWithDuration:0.1 animations:^{
        
        cell.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //[cell stopShaking];
    }];
    
}

#pragma mark --- button点击事件 ---
- (void)buttonAction:(UIButton *)button
{
    [self manageAllCells];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
