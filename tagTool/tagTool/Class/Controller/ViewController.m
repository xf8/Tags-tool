//
//  ViewController.m
//  tagTool
//
//  Created by 张健 on 15/9/20.
//  Copyright © 2015年 张健. All rights reserved.
//

#import "ViewController.h"
#import "ZJTextView.h"
#import "ZJTextBottomView.h"
#import "UIView+ZJFrame.h"

#define ZJScreenH ([UIScreen mainScreen].bounds.size.height)
#define ZJScreenW ([UIScreen mainScreen].bounds.size.height)
#define ZJLogFunc NSLog(@"%s",__func__)
@interface ViewController () <UITextViewDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) ZJTextBottomView *textBottomView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [self addTextView];
    [self addTextBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 设置导航Item
- (void)setNavItem{
    self.title = @"发表文字";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)publish{
    NSLog(@"%s",__func__);
}

#pragma mark - textView
- (void)addTextView{
    
    ZJTextView *textV = [[ZJTextView alloc] init];
    textV.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textV.placeholderColor = [UIColor lightGrayColor];
    textV.backgroundColor = [UIColor whiteColor];
    textV.alwaysBounceVertical = YES;
    textV.frame = CGRectMake(0, 64, ZJScreenW, ZJScreenH - 64);
    //    textV.frame = CGRectMake(0, 0, ZJScreenW, ZJScreenH);
    [self.view addSubview:textV];
    self.textView = textV;
    self.textView.delegate = self;
    //    [self.textView becomeFirstResponder];
}

#pragma mark - 添加textBottomView
- (void)addTextBottomView{
    ZJTextBottomView *bottomV = [[ZJTextBottomView alloc] init];
    
    bottomV.x = 0;
    bottomV.y = [UIScreen mainScreen].bounds.size.height - bottomV.height;
    [self.view addSubview:bottomV];
    self.textBottomView = bottomV;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{
    // 键盘弹出时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        // 键盘y值
        CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        // self.textBottomView.y = keyboardY - self.textBottomView.height;
        CGFloat y = keyboardY - ZJScreenH;
        self.textBottomView.transform = CGAffineTransformMakeTranslation(0, y);
    }];
    NSLog(@"%@",NSStringFromCGRect(self.textBottomView.frame));
}

- (void)dealloc{
    ZJLogFunc;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
