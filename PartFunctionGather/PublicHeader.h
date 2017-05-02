//
//  PublicHeader.h
//  PartFunctionGather
//
//  Created by 冯文秀 on 17/3/10.
//  Copyright © 2017年 Hera. All rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

// 颜色RGB 通用
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define WMMediumFont(FontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:FontSize]
#define WMLightFont(FontSize) [UIFont fontWithName:@"PingFangSC-Light" size:FontSize]

#import "ViewController.h"
#import "UINavigationBar+Awesome.h"
#import "DT_DynamicCell.h"
#import "iCarousel.h"
#import "UIImage+blurring.h"
#import "PublishAlertView.h"
#import "ShakeItemView.h"


#endif /* PublicHeader_h */
