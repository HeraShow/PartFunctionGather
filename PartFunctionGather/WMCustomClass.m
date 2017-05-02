//
//  WMCustomClass.m
//  微猫商户端
//
//  Created by 冯文秀 on 16/10/26.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import "WMCustomClass.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation WMCustomClass
+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:rand()%255/255.0
                           green:rand()%255/255.0
                            blue:rand()%255/255.0
                           alpha:1.0f];
}
// 颜色转换
+ (UIColor *)colorWithHexString:(NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
+ (CGFloat)colorComponentFrom:(NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark --- 获取UIColor对象的rgb值 ---
- (NSString *)getHexStringByColor:(UIColor *)originColor
{
    NSDictionary *colorDic = [self getRGBDictionaryByColor:originColor];
    int r = [colorDic[@"R"] floatValue] * 255;
    int g = [colorDic[@"G"] floatValue] * 255;
    int b = [colorDic[@"B"] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @{@"R":@(r),
             @"G":@(g),
             @"B":@(b),
             @"A":@(a)};
}

+(CGFloat)ReturnViewFrame:(UIView *)view Direction:(NSString *)string{
    if ([string  isEqual: @"Y"]) {
        return view.frame.origin.y + view.frame.size.height;
    }else{
        return view.frame.origin.x + view.frame.size.width;
    }
}

+ (void)customAlertViewWithMessage:(NSString *)message target:(id)target block:(completeBlock)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message];
    [messageText addAttribute:NSFontAttributeName value:WMLightFont(14) range:NSMakeRange(0, message.length)];
    [messageText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, message.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    [target presentViewController:alert animated:YES completion:^{
        [target dismissViewControllerAnimated:YES completion:block];
    }];
}

+ (void)customAlertViewWithMessage:(NSString *)message target:(id)target sureBlock:(sureBlock)sureBlock dismiss:(BOOL)dismiss sel:(SEL)sel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message];
    [messageText addAttribute:NSFontAttributeName value:WMLightFont(14) range:NSMakeRange(0, message.length)];
    [messageText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, message.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:sureBlock];
    [sureAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:sureAction];
    [target presentViewController:alert animated:YES completion:^{
        if (dismiss) {
            [target performSelector:sel withObject:target afterDelay:5];
        }
    }];
}

+ (NSString *)encodingParaDicWithDataDic:(NSDictionary *)paraDic
{
    NSData *paraData = [NSJSONSerialization dataWithJSONObject:paraDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paraStr = [[NSString alloc] initWithData:paraData encoding:NSUTF8StringEncoding];
    paraStr = [paraStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return paraStr;
}

+ (NSDictionary *)deEncodingParaStr:(NSString *)paraStr
{
    NSMutableString *outputStr = [NSMutableString stringWithString:paraStr];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    NSString *str = [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *resultData = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    id result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * messageDic = result;
    return messageDic;
}

#pragma mark --- 字符串解析成字典 ---
+ (NSDictionary *)receiveDicWithString:(NSString *)str
{
    NSData *resultData = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    id result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * messageDic = result;
    return messageDic;
}

#pragma mark --- 字符串解析成数组 ---
+ (NSArray *)receiveArrayWithString:(NSString *)str
{
    NSData *resultData = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    id result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray * messageArray = result;
    return messageArray;
}

#pragma mark --- 数组/ 字典 解析成字符串 ---
+ (NSString *)receiveDataStrWithID:(id)objc
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objc options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)receiveCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

#pragma mark --- 获取系统时间戳 ---本时区 --
+ (NSString *)getSystemTimeString8Hours
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] + 3600 * 8;
    NSString *timeString = [NSString stringWithFormat:@"%f", time];
    return timeString;
}


+ (NSString *)getfewDaysAgoWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    NSString *beforDateStr = [formatter stringFromDate:newdate];
    return beforDateStr;
}

#pragma mark --- 时间戳 转具体时间 ---
+ (NSString *)timeStampToSpecificTimeWithTimeStamp:(NSInteger)time
{
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *createStr = [formatter stringFromDate:createDate];
    return createStr;
}

#pragma mark --- 具体时间 转时间戳 ---
+ (NSTimeInterval)specificTimeToTimeStampWithTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}


#pragma mark --- MD5加密 ---  需要引入<CommonCrypto/CommonDigest.h>
+ (NSString *)md5HexDigest:(NSString *)url
{
    const char *original_str = [url UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

#pragma mark --- 设置 NavigationBar title 字体大小 颜色 字典 ---
+ (NSMutableDictionary *)customNavigationBarTitle
{
    NSMutableDictionary *barTitleDic = [NSMutableDictionary dictionary];
    [barTitleDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [barTitleDic setObject:WMMediumFont(18) forKey:NSFontAttributeName];
    return barTitleDic;
}

#pragma mark ---  格式化小数 四舍五入类型 到 format多少位 ---
+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

#pragma mark --- 产生随机数 ---
+ (NSString *)makeRandomNumberAndChange
{
    NSInteger num = (float)(1+arc4random()%9999999);
    NSString *numStr = [NSString stringWithFormat:@"%ld", num];
    while (numStr.length < 7) {
        numStr = [numStr stringByAppendingString:@"0"];
    }
    NSMutableArray *numArray = [NSMutableArray array];
    for (NSInteger i = numStr.length - 1; i > -1; i--) {
        [numArray addObject:[numStr substringWithRange:NSMakeRange(i, 1)]];
    }
    NSString *appendStr = [NSString string];
    for (NSString *numStr in numArray) {
        appendStr = [appendStr stringByAppendingString:numStr];
    }
    // 反转数
    NSInteger appendInt = [appendStr integerValue];
    // 1-9
    NSInteger textInt = (float)(1+arc4random()%9);
    // 标准式 ： num 拼接 textInt 拼接 (appedInt + textInt) * textInt
    NSInteger add = appendInt + textInt;
    NSInteger ride = add * textInt;
    NSString *resultStr = [NSString stringWithFormat:@"%ld%ld%ld", num, textInt, ride];
    return resultStr;
}

// 获取当前版本号
+ (NSString *)getWemartMerchantVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)infoDic);
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// sha1 加密算法 不含中文
+ (NSString *)sha1WithNoChineseInput:(NSString *)inputStr
{
    const char *chanStr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:chanStr length:inputStr.length];
    
    uint8_t disget[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, disget);
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [mutableStr appendFormat:@"%02x", disget[i]];
    }
    return mutableStr;
}

// sha1 加密算法 含中文  推荐使用
+ (NSString *)sha1ContainChineseInput:(NSString *)inputStr
{
    NSData *data = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t disget[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, disget);
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [mutableStr appendFormat:@"%02x", disget[i]];
    }
    return mutableStr;
}

// HmacSHA1加密
+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}

@end
