//
//  CustomShakeCell.h
//  move
//
//  Created by 冯文秀 on 17/1/1.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomShakeCell : UICollectionViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *itemLabel;


- (void)startShaking;
- (void)stopShaking;




@end
