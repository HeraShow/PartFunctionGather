//
//  WMCustomClass.h
//  微猫商户端
//
//  Created by 冯文秀 on 16/10/26.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completeBlock)(void);
typedef void (^sureBlock)(UIAlertAction *action);
@interface WMCustomClass : NSObject

@property (nonatomic, copy) completeBlock block;
@property (nonatomic, copy) sureBlock sure;
+ (UIColor *)randomColor;

// 颜色转换
+ (UIColor *)colorWithHexString:(NSString *)hexString;

// 获取UIColor对象的rgb值
- (NSString *)getHexStringByColor:(UIColor *)originColor;

+(CGFloat)ReturnViewFrame:(UIView *)view Direction:(NSString *)string;


// 提示框
+ (void)customAlertViewWithMessage:(NSString *)message target:(id)target block:(completeBlock)block;
// 确认提示框
+ (void)customAlertViewWithMessage:(NSString *)message target:(id)target sureBlock:(sureBlock)sureBlock dismiss:(BOOL)dismiss sel:(SEL)sel;

+ (NSDictionary *)receiveDicWithString:(NSString *)str;
+ (NSArray *)receiveArrayWithString:(NSString *)str;
+ (NSString *)receiveDataStrWithID:(id)objc;

// 解码
+ (NSDictionary *)deEncodingParaStr:(NSString *)paraStr;

// 编码
+ (NSString *)encodingParaDicWithDataDic:(NSDictionary *)paraDic;

// 获取当前时间
+ (NSString *)receiveCurrentDate;

// 获取系统时间戳 --- 本时区 --
+ (NSString *)getSystemTimeString8Hours;
// 获取几年几月几天前
+ (NSString *)getfewDaysAgoWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSString *)timeStampToSpecificTimeWithTimeStamp:(NSInteger)time;
+ (NSTimeInterval)specificTimeToTimeStampWithTime:(NSString *)time;
// MD5加密
+ (NSString *)md5HexDigest:(NSString *)url;

+ (NSMutableDictionary *)customNavigationBarTitle;
// 格式化小数 四舍五入
+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV;

+ (NSString *)makeRandomNumberAndChange;


// 获取当前版本号
+ (NSString *)getWemartMerchantVersion;
// 缩小图片
+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;
// sha1 加密算法 不含中文
+ (NSString *)sha1WithNoChineseInput:(NSString *)inputStr;
// sha1 加密算法 含中文  推荐使用
+ (NSString *)sha1ContainChineseInput:(NSString *)inputStr;
// HmacSHA1加密
+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data;

@end
