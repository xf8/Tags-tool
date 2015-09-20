//
//  ZJTagField.m
//  百思不得解
//
//  Created by 张健 on 15/8/26.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJTagField.h"

@implementation ZJTagField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 先设置占位文字
        self.placeholder = @"多个标签用逗号或者换行隔开";
    }
    return self;
}

- (void)deleteBackward{
    !self.beforeDeleteBackwardBlock ?  : self.beforeDeleteBackwardBlock();
    [super deleteBackward];
}

@end
