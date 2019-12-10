//
//  MD5Util.h
//  GBSClientiOS
//
//  Created by asd on 2018/7/21.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Util : NSObject

+ (NSString *) MD5ForLower32Bate:(NSString *)str;
+ (NSString *) md5:(NSString *) input;

@end
