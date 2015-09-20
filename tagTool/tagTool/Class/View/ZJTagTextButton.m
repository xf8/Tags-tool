//
//  ZJTagTextButton.m
//  百思不得解
//
//  Created by 张健 on 15/8/26.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJTagTextButton.h"
#import "UIView+ZJFrame.h"
#define ZJTagBgColor [UIColor colorWithRed:56/255.0 green:116/255.0 blue:201/255.0 alpha:1.0]

@implementation ZJTagTextButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = ZJTagBgColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageView removeFromSuperview];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.height = 25;
    self.width += 2 * 5;
}

@end
