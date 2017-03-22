//
//  ShakeFlowLayout.m
//  CategoryLabel
//
//  Created by 冯文秀 on 17/1/1.
//  Copyright © 2017年 Hera. All rights reserved.
//

#import "ShakeFlowLayout.h"

@implementation ShakeFlowLayout
# pragma mark --- 记录移动的cell 的indexPath 以及位置 ---
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position
{
    UICollectionViewLayoutAttributes *attributes =  [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath withTargetPosition:position];
    attributes.transform = CGAffineTransformMakeScale(1.3, 1.3);
    return attributes;
}
@end
