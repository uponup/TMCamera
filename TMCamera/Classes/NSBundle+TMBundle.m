//
//  NSBundle+TMBundle.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "NSBundle+TMBundle.h"

@implementation NSBundle (TMBundle)

+ (instancetype)tm_subBundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName {
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    }
    NSBundle *associateBunle = [NSBundle bundleWithPath:[associateBundleURL.path stringByAppendingPathComponent:@"TMCamera.bundle"]];

    NSAssert(associateBunle, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBunle?associateBunle:nil;
}

@end
