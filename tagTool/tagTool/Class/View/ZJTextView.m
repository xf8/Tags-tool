//
//  ZJTextView.m
//  百思不得解
//
//  Created by 张健 on 15/8/21.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJTextView.h"
#import "UIView+ZJFrame.h"
@interface ZJTextView ()

@end
@implementation ZJTextView
- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.x = 4;
        placeholderLabel.y = 8;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderLabel.textColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.placeholderLabel.width = [UIScreen mainScreen].bounds.size.width - 2 * 5;
    [self.placeholderLabel sizeToFit];
}

// 监听输入
- (void)textDidChange{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = _placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = [placeholderColor copy];
    self.placeholderLabel.textColor = _placeholderColor;
    [self setNeedsLayout];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
