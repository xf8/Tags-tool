//
//  ZJTagField.h
//  百思不得解
//
//  Created by 张健 on 15/8/26.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTagField : UITextField
@property (nonatomic, copy) void (^beforeDeleteBackwardBlock)();
@end
