//
//  TMUtils.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/4/11.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMUtils.h"
#import "TMCamera.h"

@implementation TMUtils

+ (NSBundle *)currentBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [bundle URLForResource:@"TMCamera" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL: bundleURL];
    return resourceBundle;
}

+ (UIImage *)imageCustomNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self currentBundle] compatibleWithTraitCollection:nil];
}

@end
