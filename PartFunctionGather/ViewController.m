//
//  ViewController.m
//  PartFunctionGather
//
//  Created by 冯文秀 on 17/3/10.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate>

@end

@implementation ViewController{
    
    UIButton *leftBtn;
    UIButton *rightBtn;
    
    UIView *topBarView;
    UIImageView *topAvatarView;    //顶部栏的头像
    UIImageView *avatarView;    //scrollview的头像
    
    UITableView *personalTableV;
    
    NSArray *photoList;     //照片数组
    NSMutableArray *dynamicList;    //动态内容数组
    NSMutableArray *dynamicExpandList;   //动态内容展开数组
    ShakeItemView *shakeView;
}

- (void)dealloc{
    personalTableV.delegate = nil;      //防止返回时，还在滚动导致崩溃
    [topBarView removeFromSuperview];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (personalTableV) {
        personalTableV.delegate = self;
    }
    topBarView.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    personalTableV.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    topBarView.hidden = YES;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addCustomButtonNavLeft];
    [self addCustomButtonNavRight];
    
    [self initDataSource];
    
    [self layoutPersonalTableView];
    
     shakeView = [[ShakeItemView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initDataSource{
    photoList = @[
                  @"bbc_tr_ht_b",
                  @"bbc_tr_jz_b",
                  @"bbc_tr_nsns_b",
                  @"bbc_tr_st_b",
                  @"bbc_tr_zt_b",
                  @"bbc_th_msry"
                  ];
    
    dynamicList = [[NSMutableArray alloc] init];
    dynamicExpandList = [[NSMutableArray alloc] init];
    NSArray *list = @[
                      @{
                          @"avatar":@"wemart_head",
                          @"uname":@"Meet",
                          @"timebefore":@"今天12点",
                          @"from":@"[江苏]程序员培训学院",
                          @"sex":@"1",
                          @"title":@"下周开始项目练习喽，biubiubiu",
                          @"piclist":@[],
                          @"likenums":@(100),
                          @"clicknums":@(100),
                          @"comtnums":@(10)
                          },
                      @{
                          @"avatar":@"bbc_th_msry",
                          @"uname":@"Photoshop",
                          @"timebefore":@"今天11点",
                          @"from":@"[上海]经济技术学院",
                          @"sex":@"0",
                          @"title":@"求约，无聊中~，蛋疼·",
                          @"piclist":@[
                                  @"bbc_th_smdq"
                                  ],
                          @"likenums":@(100),
                          @"clicknums":@(100),
                          @"comtnums":@(10)
                          },
                      @{
                          @"avatar":@"bbc_th_smdq",
                          @"uname":@"Text",
                          @"timebefore":@"今天10点",
                          @"from":@"[上海]经济技术学院",
                          @"sex":@"1",
                          @"title":@"如果超人会飞，那就让我在空中停一停歇，俯瞰整个世界。不要问我哭过了没，因为超人不能流眼泪。",
                          @"piclist":@[
                                  @"bbc_th_smdq",
                                  @"bbc_th_smdq"
                                  ],
                          @"likenums":@(100),
                          @"clicknums":@(100),
                          @"comtnums":@(10)
                          }
                      ];
    
    [dynamicList addObjectsFromArray:list];
    
    for (int i=0; i<[dynamicList count]; i++) {
        [dynamicExpandList addObject:@(NO)];
    }
    
}
#pragma mark --- 添加 左边自定义按钮 ---
- (void)addCustomButtonNavLeft{
    CGRect barRect = self.navigationController.navigationBar.bounds;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, barRect.size.height, barRect.size.height)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = barRect.size.height/2.0;
    [button setImage:[UIImage imageNamed:@"wemart_down02"] forState:UIControlStateNormal];
    [button setBackgroundColor:ColorRGB(101, 101, 101)];
    [button addTarget:self action:@selector(btnNavLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn = button;
    leftBtn.tag = 2;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

#pragma mark --- 左边按钮事件 ---
- (void)btnNavLeftAction:(UIButton *)button{
    NSString *upStr;
    NSString *downStr;

    if (button.tag == 2) {
        upStr = @"wemart_up02";
        downStr = @"wemart_down02";
    }
    else{
        upStr = @"wemart_up03";
        downStr = @"wemart_down03";
    }
    BOOL isUp = [[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:upStr]];
    if (!isUp) {
        shakeView.frame = CGRectMake(0, 64, KScreenWidth, 0);;
        [self.view addSubview:shakeView];
        [UIView animateWithDuration:0.3 animations:^{
            shakeView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64);
        } completion:^(BOOL finished) {
            [button setImage:[UIImage imageNamed:upStr] forState:UIControlStateNormal];
        }];
    }
    else{
        shakeView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64);
        [UIView animateWithDuration:0.3 animations:^{
            shakeView.frame = CGRectMake(0, 64, KScreenWidth, 0);;
        } completion:^(BOOL finished) {
            [shakeView removeFromSuperview];
            [button setImage:[UIImage imageNamed:downStr] forState:UIControlStateNormal];
        }];
    }
}

#pragma mark --- 添加 右边自定义按钮 ---
- (void)addCustomButtonNavRight{
    
    CGRect barRect = self.navigationController.navigationBar.bounds;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, barRect.size.height, barRect.size.height)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = barRect.size.height/2.0;
    [button setImage:[UIImage imageNamed:@"homepage_message_icon03"] forState:UIControlStateNormal];
    [button setBackgroundColor:ColorRGB(101, 101, 101)];
    [button addTarget:self action:@selector(btnNavRightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn = button;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark --- 右边边按钮事件 ---
- (void)btnNavRightAction{
    PublishAlertView *alertView = [[PublishAlertView alloc] init];
    [alertView show];
}

- (void)layoutPersonalTableView{
    
    personalTableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    personalTableV.delegate = self;
    personalTableV.dataSource = self;
    personalTableV.backgroundColor = [UIColor clearColor];
    personalTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:personalTableV];
    personalTableV.tableHeaderView = [self obtainHeaderView];
    
}

- (UIView *)obtainHeaderView{
    
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat screenW = KScreenWidth;
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    [headerView addSubview:bgImgView];
    
    CGFloat avatarW = screenW*250.0/1080.0;
    UIImage *img = [UIImage imageNamed:@"wemart_head"];
    avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((screenW-avatarW)/2.0, screenW*40.0/1080.0-44.0, avatarW, avatarW)];
    avatarView.image = img;
    topAvatarView.image = img;
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.cornerRadius = avatarW/2.0;
    avatarView.layer.borderWidth = 0.5;
    avatarView.layer.borderColor = [ColorRGB(45, 41, 40) CGColor];
    [headerView addSubview:avatarView];
    
    
    CGRect nameLFrame;
    NSString *nameStr = @"iPhone ";
    CGFloat baseFontSize = screenW*55.0/1080.0/1.2;
    CGFloat nameLW = [self TextWidth:nameStr Font:[UIFont systemFontOfSize:baseFontSize] Height:baseFontSize*1.2];
    CGFloat nameLMaxW = screenW - 2*screenW*140.0/1080.0;
    if (nameLW > nameLMaxW) {
        nameLFrame = CGRectMake(screenW*140.0/1080.0, avatarView.frame.origin.y+ avatarView.frame.size.height + screenW*40.0/1080.0, nameLMaxW, baseFontSize*1.2);
    }else{
        nameLFrame = CGRectMake((screenW-nameLW)/2.0, avatarView.frame.origin.y+ avatarView.frame.size.height + screenW*40.0/1080.0, nameLW, baseFontSize*1.2);
    }
    UILabel *nameL = [[UILabel alloc] initWithFrame:nameLFrame];
    nameL.font = [UIFont systemFontOfSize:baseFontSize];
    nameL.text = nameStr;
    nameL.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameL];
    
    CGFloat sexVW = screenW*55.0/1080.0;
    CGRect sexVFrame = CGRectMake(nameLFrame.origin.x+nameLFrame.size.width, nameLFrame.origin.y+(nameLFrame.size.height-sexVW)/2.0, sexVW, sexVW);
    NSString *sexStr = @"1";
    UIImageView *sexV = [[UIImageView alloc] initWithFrame:sexVFrame];
    if ([sexStr intValue] == 1) {
        //女
        sexV.image = [UIImage imageNamed:@"sex_woman01"];
    }else if ([sexStr intValue] == 0){
        sexV.image = [UIImage imageNamed:@"sex_man01"];
    }
    [headerView addSubview:sexV];
    
    CGFloat smallFontSize = baseFontSize*50.0/55.0;
    CGRect schoolLFrame = CGRectMake(0, nameLFrame.origin.y+nameLFrame.size.height + screenW*40.0/1080.0, screenW, smallFontSize*1.2);
    UILabel *schoolL = [[UILabel alloc] initWithFrame:schoolLFrame];
    schoolL.text = @"上海大学[上海]";
    schoolL.font = [UIFont systemFontOfSize:smallFontSize];
    schoolL.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:schoolL];
    
    CGRect collegeLFrame = CGRectMake(0, schoolLFrame.origin.y+schoolLFrame.size.height, screenW, smallFontSize*1.2);
    UILabel *collegeL = [[UILabel alloc] initWithFrame:collegeLFrame];
    collegeL.text = @"交互设计学院";
    collegeL.font = [UIFont systemFontOfSize:smallFontSize];
    collegeL.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:collegeL];
    
    CGFloat leftPadding = screenW*30.0/1080.0;
    CGFloat userInfoBtnW = screenW*250.0/1080.0;
    CGFloat userInfoBtnH = screenW*60.0/1080.0;
    UIButton *userInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftPadding, collegeLFrame.origin.y+collegeLFrame.size.height, userInfoBtnW, userInfoBtnH)];
    [userInfoBtn setBackgroundColor:[UIColor clearColor]];
    [userInfoBtn.titleLabel setFont:[UIFont systemFontOfSize:smallFontSize]];
    [userInfoBtn setTitle:@"TA的资料" forState:UIControlStateNormal];
    [userInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userInfoBtn.layer.masksToBounds = YES;
    userInfoBtn.layer.cornerRadius = 5.0;
    userInfoBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    userInfoBtn.layer.borderWidth = 1.0;
    [headerView addSubview:userInfoBtn];
    
    CGFloat numberLW = screenW*180.0/1080.0;
    CGFloat numberLH = screenW*60.0/1080.0;
    UILabel *numberL = [[UILabel alloc] initWithFrame:CGRectMake(screenW-leftPadding-numberLW, userInfoBtn.frame.origin.y+(userInfoBtnH-numberLH)/2.0, numberLW, numberLH)];
    numberL.text = @"12/20";
    numberL.textColor = [UIColor whiteColor];
    numberL.textAlignment = NSTextAlignmentCenter;
    numberL.font = [UIFont systemFontOfSize:screenW*45.0/1080.0/1.2];
    numberL.backgroundColor = ColorRGB(101, 101, 101);
    numberL.layer.masksToBounds = YES;
    numberL.layer.cornerRadius = 10.0;
    [headerView addSubview:numberL];
    
    CGRect bgImgViewFrame = CGRectMake(0, -64.0, screenW, userInfoBtn.frame.origin.y+userInfoBtn.frame.size.height+screenW*20.0/1080.0+64.0);
    bgImgView.frame = bgImgViewFrame;
    //    bgImgView.backgroundColor = [UIColor redColor];
    
    //异步模糊
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *fuzzyImg = [img blurring];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            bgImgView.image = fuzzyImg;
            
        });
    });
    
    CGFloat photoSelectVH = screenW*280.0/1080.0;
    iCarousel *photoSelectV = [[iCarousel alloc] initWithFrame:CGRectMake(0, bgImgViewFrame.origin.y+bgImgViewFrame.size.height, KScreenWidth, photoSelectVH)];
    photoSelectV.backgroundColor = ColorRGB(119, 115, 115);
    photoSelectV.delegate = self;
    photoSelectV.dataSource = self;
    photoSelectV.type = iCarouselTypeLinear;
    [photoSelectV reloadData];
    [headerView addSubview:photoSelectV];
    
    headerView.frame = CGRectMake(0, 0, screenW, photoSelectV.frame.origin.y+photoSelectV.frame.size.height);
    
    return headerView;
    
}

#pragma mark - iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return photoList.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    CGFloat screenW = KScreenWidth;
    UIImageView *imgView = nil;
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW/4.0, screenW*280.0/1080.0)];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-screenW*260.0/1080.0)/2.0, screenW*10.0/1080.0, screenW*260.0/1080.0, screenW*260.0/1080.0)];
        imgView.tag = 2001;
        [view addSubview:imgView];
    }else{
        imgView = (UIImageView *)[view viewWithTag:2001];
    }
    
    imgView.image = [UIImage imageNamed:[photoList objectAtIndex:index]];
    
    return view;
    
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            return 0.0f;
        }
        case iCarouselOptionShowBackfaces:
        {
            return YES;
        }
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return 5;
        }
    }
    //return value;
}

# pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dynamicList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

# pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"DT_ DynamicCell";
    DT_DynamicCell *cell=(DT_DynamicCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[DT_DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *attributes = [dynamicList objectAtIndex:indexPath.section];
    [cell initWithAttributes:attributes expand:[[dynamicExpandList objectAtIndex:indexPath.section] boolValue]];
    [cell.expandBtn addTarget:self action:@selector(expandBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat distance = offsetY + 64.0;
    CGFloat screenW = KScreenWidth;
    CGFloat avatarW = screenW*250.0/1080.0;
    if (distance < avatarW && avatarW - distance >44.0 && offsetY > -64.0 && avatarView) {
        
        CGFloat aw = avatarW - distance;
        avatarView.frame = CGRectMake((screenW-aw)/2.0, screenW*40.0/1080.0-44.0 + distance, aw, aw);
        avatarView.layer.cornerRadius = aw/2.0;
        
    }
    
    CGFloat oldY = - 20.0- (screenW*40.0/1080.0-44.0) ;
    CGFloat offsetYL = avatarW - 64.0 - 44.0;
    
    if (offsetY > offsetYL + oldY) {
        
        avatarView.hidden = YES;
        
        //64的距离，alpha从0到1。
        CGFloat alpha;
        CGFloat btnAlpha;
        if (offsetY-(offsetYL + oldY) < 64.0) {
            alpha = (offsetY-(offsetYL + oldY))/64.0;
            if (offsetY-(offsetYL + oldY) < 32.0) {
                btnAlpha = 1 - (offsetY-(offsetYL + oldY))/32.0;
                [self btnStartState];
            }else{
                btnAlpha =  (offsetY-(offsetYL + oldY) - 32.0)/32.0;
                [self btnSwitchState];
            }
        }else{
            alpha = 1.0;
            btnAlpha = 1.0;
            [self btnSwitchState];
        }
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        leftBtn.alpha = btnAlpha;
        rightBtn.alpha = btnAlpha;
        topAvatarView.hidden = NO;

        
    }else{
        topAvatarView.hidden = YES;
        
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self btnStartState];
        leftBtn.alpha = 1.0;
        rightBtn.alpha = 1.0;
        avatarView.hidden = NO;
    }
    
}

//按钮初始状态
- (void)btnStartState{
    leftBtn.tag = 3;

    [leftBtn setImage:[UIImage imageNamed:@"wemart_down03"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = ColorRGB(101, 101, 101);
    [rightBtn setImage:[UIImage imageNamed:@"homepage_message_icon03"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = ColorRGB(101, 101, 101);
    
}

//按钮下拉切换图片状态
- (void)btnSwitchState{
    leftBtn.tag = 2;

    [leftBtn setImage:[UIImage imageNamed:@"wemart_down02"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"homepage_message_icon02"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    
}


//展开按钮点击
- (void)expandBtn:(UIButton *)sender{
    
    CGRect rect = [sender convertRect:sender.bounds toView:personalTableV];
    NSIndexPath *cellPath = [personalTableV indexPathsForRowsInRect:rect][0];
    BOOL isExpand = [[dynamicExpandList objectAtIndex:cellPath.section] boolValue];
    [dynamicExpandList replaceObjectAtIndex:cellPath.section withObject:@(!isExpand)];
    [personalTableV reloadData];
    
}


#pragma mark - 通用方法
- (CGFloat)TextWidth:(NSString *)str2 Font:(UIFont *)font Height:(CGFloat)height{
    NSString *str=[NSString stringWithFormat:@"%@",str2];
    CGSize constraint = CGSizeMake(MAXFLOAT, height);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:dic context:nil].size;
    return size.width;
}


@end
