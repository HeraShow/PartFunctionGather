//
//  PublishAlertView.h
//  PartFunctionGather
//
//  Created by 冯文秀 on 17/2/10.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublishAlertView;

@protocol PublishAlertViewDelegate <NSObject>

- (void)alertView:(PublishAlertView *)alertView buttonClick:(NSInteger)tag;

@end

@interface PublishAlertView : UIView

@property (strong, nonatomic) UIImage *snapshot;
@property (weak, nonatomic) id <PublishAlertViewDelegate> delegate;

- (void)show;

- (void)dismiss;

@end
