//
//  ZJTextBottomView.m
//  百思不得解
//
//  Created by 张健 on 15/8/21.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJTextBottomView.h"
#import "TagController.h"
#import "ViewController.h"
#import "ZJTagTextButton.h"
#import "UIView+ZJFrame.h"
@interface ZJTextBottomView ()
@property (weak, nonatomic) IBOutlet UIView *bottomTagView;
@property (nonatomic, weak) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *tagTextBtns;
@end
@implementation ZJTextBottomView
- (NSMutableArray *)tagTextBtns
{
    if (!_tagTextBtns) {
        _tagTextBtns = [NSMutableArray array];
    }
    return _tagTextBtns;
}

- (void)awakeFromNib{
    // 添加“+”号按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addBtn sizeToFit];
    [self.bottomTagView addSubview:addBtn];
    self.addBtn = addBtn;
    
    // 默认创建2个标签
    [self createTagTextBtns:@[@"吐槽", @"糗事"]];
}

- (void)createTagTextBtns:(NSArray *)tags{
    // 删除以前的所有label
    [self.tagTextBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagTextBtns removeAllObjects];
    // 所有的标签文本
    for (int i = 0; i < tags.count; i++) {
        // 添加
        ZJTagTextButton *tagTextBtn = [[ZJTagTextButton alloc] init];
        [tagTextBtn setTitle:tags[i] forState:UIControlStateNormal];
        [self.bottomTagView addSubview:tagTextBtn];
        [self.tagTextBtns addObject:tagTextBtn];
    }
    // 重新布局子控件
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZJTextBottomView class]) owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 所有的标签文本
    for (int i = 0; i < self.tagTextBtns.count; i++) {
        // 添加
        ZJTagTextButton *tagTextBtn = self.tagTextBtns[i];
        
        // 计算
        if (i == 0) {
            tagTextBtn.x = 0;
            tagTextBtn.y = 0;
        } else {
            ZJTagTextButton *previousTagTextBtn = self.tagTextBtns[i - 1];
            CGFloat rightWidth = self.bottomTagView.width - CGRectGetMaxX(previousTagTextBtn.frame) - 5;
            if (rightWidth >= tagTextBtn.width) {
                tagTextBtn.y = previousTagTextBtn.y;
                tagTextBtn.x = CGRectGetMaxX(previousTagTextBtn.frame) + 5;
            } else {
                tagTextBtn.x = 0;
                tagTextBtn.y = CGRectGetMaxY(previousTagTextBtn.frame) + 5;
            }
        }
    }
    
    // 加号按钮
    ZJTagTextButton *lastTagTextBtn = self.tagTextBtns.lastObject;
    CGFloat rightWidth = self.bottomTagView.width - CGRectGetMaxX(lastTagTextBtn.frame) - 5;
    if (rightWidth >= self.addBtn.width) {
        self.addBtn.y = lastTagTextBtn.y;
        self.addBtn.x = CGRectGetMaxX(lastTagTextBtn.frame) + 5;
    } else {
        self.addBtn.x = 0;
        self.addBtn.y = CGRectGetMaxY(lastTagTextBtn.frame) + 5;
    }
    
    // 设置topView的尺寸
    self.bottomTagView.height = CGRectGetMaxY(self.addBtn.frame) + 5;
    
    // 设置整个toolbar的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.bottomTagView.frame) + 5 + 35;
    self.y += oldH - self.height;
}

- (void)plusClick{
    TagController *tagVC = [[TagController alloc] init];
    __weak typeof(self) weakSelf = self;
    tagVC.getTagsBlock = ^(NSArray *tags) {
        [weakSelf createTagTextBtns:tags];
    };
    // 传递数据
    tagVC.tags = [self.tagTextBtns valueForKeyPath:@"titleLabel.text"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:tagVC];
    
    UIViewController *rootVC = self.window.rootViewController;
    // 获得发布控制器，跳转到发段子
    [rootVC presentViewController:navVC animated:YES completion:nil];
}

@end
