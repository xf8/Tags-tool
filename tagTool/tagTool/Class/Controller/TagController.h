//
//  TagController.h
//  tagTool
//
//  Created by 张健 on 15/9/20.
//  Copyright © 2015年 张健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagController : UIViewController
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, copy) void (^getTagsBlock)(NSArray *);
@end
