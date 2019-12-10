//
//  MD5Util.m
//  GBSClientiOS
//
//  Created by asd on 2018/7/21.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Util

+ (NSString *) MD5ForLower32Bate:(NSString *)str {
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

+ (NSString *) md5:(NSString *) str {
    const char *concat_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash uppercaseString];
}

@end
