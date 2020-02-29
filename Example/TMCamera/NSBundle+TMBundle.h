//
//  NSBundle+TMBundle.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (TMBundle)
+ (instancetype)tm_subBundleWithBundleName:(NSString *)bundleName targetClass:(Class)targetClass;
@end

NS_ASSUME_NONNULL_END
