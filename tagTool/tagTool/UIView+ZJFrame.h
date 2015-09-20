//
//  UIView+ZJFrame.h
//  百思不得解
//
//  Created by 张健 on 15/8/15.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJFrame)
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
+ (instancetype)viewFromXib;
@end
