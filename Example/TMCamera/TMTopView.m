//
//  TMTopView.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMTopView.h"


@interface TMTopView ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation TMTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.6];
        
        self.labelTitle = [UILabel new];
        self.labelTitle.font = [UIFont systemFontOfSize:17];
        self.labelTitle.textColor = UIColor.blackColor;
        [self addSubview:self.labelTitle];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn addTarget:self action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
    }
    return self;
}

@end
