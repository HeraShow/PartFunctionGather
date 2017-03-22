//
//  CustomShakeCell.m
//  move
//
//  Created by 冯文秀 on 17/1/1.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import "CustomShakeCell.h"

@implementation CustomShakeCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60 + 24, 24)];
        self.bgView.backgroundColor = ColorRGB(240, 243, 245);
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.borderWidth = 0.5;
        self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:_bgView];
        
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, 50, 18)];
        self.itemLabel.font = WMMediumFont(13);
        self.itemLabel.textColor = [UIColor blackColor];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_itemLabel];
        
    }
    return self;
}


- (void)startShaking
{
    CAKeyframeAnimation *Z = (CAKeyframeAnimation *)[self.contentView.layer animationForKey:@"transform.roration.z"];
    CAKeyframeAnimation *Y = (CAKeyframeAnimation *)[self.contentView.layer animationForKey:@"transform.roration.y"];
    if (Z == nil) {
        CAKeyframeAnimation *shaking = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        shaking.values = @[[NSNumber numberWithFloat:-0.2],[NSNumber numberWithFloat:0.3]];
        shaking.autoreverses= YES;
        shaking.duration = 0.18;
        shaking.repeatCount = 1000;
        [self.contentView.layer addAnimation:shaking forKey:@"shaking"];
    }
    if (Y == nil) {
        CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transfrom.rotation.y"];
        bounce.values = @[[NSNumber numberWithFloat:4],[NSNumber numberWithFloat:-4]];
        bounce.autoreverses = YES;
        bounce.duration = 0.18;
        bounce.repeatCount = 1000;
        [self.contentView.layer addAnimation:bounce forKey:@"bounce"];
    }
    return;
    
}



- (void)stopShaking
{
    [self.contentView.layer removeAllAnimations];
}







@end
