//
//  ZJTagButton.m
//  百思不得解
//
//  Created by 张健 on 15/8/22.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJTagButton.h"
#import "UIView+ZJFrame.h"
#define ZJTagBgColor [UIColor colorWithRed:56/255.0 green:116/255.0 blue:201/255.0 alpha:1.0]
@implementation ZJTagButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ZJTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 计算完毕
    [self sizeToFit];
    
    // 调整
    self.height = 25;
    self.width += 3 * 5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = 5;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
}

@end
