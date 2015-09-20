//
//  TagController.m
//  tagTool
//
//  Created by 张健 on 15/9/20.
//  Copyright © 2015年 张健. All rights reserved.
//

#import "TagController.h"
#import "ZJTagButton.h"
#import "ZJTagField.h"
#import "UIView+ZJFrame.h"
#import "SVProgressHUD.h"
#define ZJSmallMargin 10
#define ZJTagBgColor [UIColor colorWithRed:56/255.0 green:116/255.0 blue:201/255.0 alpha:1.0]
#define ZJScreenH ([UIScreen mainScreen].bounds.size.height)
#define ZJScreenW ([UIScreen mainScreen].bounds.size.width)
@interface TagController () <UITextFieldDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UITextField *tagField;
@property (nonatomic, strong) UIButton *addTagButton;
@property (nonatomic, strong) NSMutableArray *tagBtns;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation TagController
- (NSMutableArray *)tags{
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableArray *)tagBtns{
    if (_tagBtns == nil) {
        _tagBtns = [NSMutableArray array];
    }
    return _tagBtns;
}

- (UIButton *)addTagButton{
    if (_addTagButton == nil) {
        UIButton *addTagButton = [[UIButton alloc] init];
        addTagButton.backgroundColor = ZJTagBgColor;
        addTagButton.width = self.contentView.width;
        addTagButton.height = self.tagField.height;
        
        addTagButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addTagButton.contentEdgeInsets = UIEdgeInsetsMake(0, ZJSmallMargin, 0, 0);
        [addTagButton addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
        addTagButton.hidden = YES;
        [self.contentView addSubview:addTagButton];
        _addTagButton = addTagButton;
    }
    _addTagButton.y = CGRectGetMaxY(self.tagField.frame) + ZJSmallMargin;
    _addTagButton.x = 0;
    return _addTagButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addContentView];
    [self setupNavItem];
    [self addTextField];
    [self setupTagBtns];
}

#pragma mark - setupTagBtns
- (void)setupTagBtns{
    for (NSString *tag in self.tags) {
        self.tagField.text = tag;
        [self addTag];
    }
}

#pragma mark addContentView
- (void)addContentView{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = ZJSmallMargin;
    contentView.y = 64 + ZJSmallMargin;
    contentView.width = ZJScreenW - ZJSmallMargin * 2;
    contentView.height = ZJScreenH - 64 - 2 * ZJSmallMargin;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

#pragma mark setupNavItem
- (void)setupNavItem{
    self.title = @"添加标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done{
    NSArray *tags = [self.tagBtns valueForKeyPath:@"currentTitle"];
    !self.getTagsBlock ? : self.getTagsBlock(tags);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - addTextField
- (void)addTextField{
    ZJTagField *tagField = [[ZJTagField alloc] init];
    tagField.width = self.contentView.width;
    tagField.height = 25;
    tagField.delegate = self;
    __weak typeof(self) weakSelf = self;
    [tagField setBeforeDeleteBackwardBlock:^{
        if (weakSelf.tagField.hasText) return;
        
        ZJTagButton *lastTagBtn = self.tagBtns.lastObject;
        [self tagDelete:lastTagBtn];
    }];
    // [tagField becomeFirstResponder];
    // [tagField layoutIfNeeded];
    [tagField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:tagField];
    self.tagField = tagField;
}
// 监听逗号输入
- (void)textDidChange{
    if (self.tagField.hasText) {
        [self setupTagFieldFrame];
        self.addTagButton.hidden = NO;
        
        NSString *text = self.tagField.text;
        if (text.length == 1) return;
        
        unichar c = [text characterAtIndex:text.length - 1];
        NSString *character = [NSString stringWithFormat:@"%C",c];
        if ([character isEqualToString:@","] || [character isEqualToString:@"，"]) {
            [self.tagField deleteBackward];
            [self addTag];
        }
    }else{
        self.addTagButton.hidden = YES;
    }
}
// tagField的frame
- (void)setupTagFieldFrame{
    self.addTagButton.hidden = NO;
    [self.addTagButton setTitle:[NSString stringWithFormat:@"添加标签：%@",self.tagField.text] forState:UIControlStateNormal];
    
    ZJTagButton *lastTagButton = self.tagBtns.lastObject;
    CGSize tagFieldTextSize = [self.tagField.text sizeWithAttributes:@{NSFontAttributeName : self.tagField.font}];
    NSLog(@"tagFieldTextSize.width--%f",tagFieldTextSize.width);
    CGFloat rightWidth = self.contentView.width - ZJSmallMargin - CGRectGetMaxX(lastTagButton.frame);
    // 右侧剩余距离少于100，tagField就换行
    CGFloat tagFieldWidth = MAX(100, tagFieldTextSize.width);
    if (tagFieldWidth > rightWidth) {
        self.tagField.x = 0;
        self.tagField.y = CGRectGetMaxY(lastTagButton.frame) + ZJSmallMargin;
    }else{
        // 若为第一个标签，标签前不需加间距
        if (lastTagButton == nil) {
            self.tagField.x = CGRectGetMaxX(lastTagButton.frame);
        }else{
            self.tagField.x = CGRectGetMaxX(lastTagButton.frame) + ZJSmallMargin;
        }
        self.tagField.y = lastTagButton.y;
    }
    self.addTagButton.y = CGRectGetMaxY(self.tagField.frame) + ZJSmallMargin;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tagField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tagField resignFirstResponder];
}

#pragma mark - addTagButton
- (void)addTag{
    
    // 如果没有文字，就不添加标签
    if (self.tagField.hasText == NO) return;
    
    // 最多添加5个标签
    if (self.tagBtns.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    ZJTagButton *tagBtn = [[ZJTagButton alloc] init];
    [tagBtn addTarget:self action:@selector(tagDelete:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:self.tagField.text forState:UIControlStateNormal];
    [self.contentView addSubview:tagBtn];
    
    ZJTagButton *lastTagButton = self.tagBtns.lastObject;
    if (lastTagButton){
        CGFloat rightWidth = self.contentView.width - CGRectGetMaxX(lastTagButton.frame) - ZJSmallMargin;
        
        if (rightWidth >= tagBtn.width) {
            tagBtn.x = CGRectGetMaxX(lastTagButton.frame) + ZJSmallMargin;
            tagBtn.y = lastTagButton.y;
            
        }else{
            tagBtn.x = 0;
            tagBtn.y = CGRectGetMaxY(lastTagButton.frame) + ZJSmallMargin;
        }
    }
    [self.tagBtns addObject:tagBtn];
    self.tagField.text = nil;
    [self setupTagFieldFrame];
    self.addTagButton.hidden = YES;
    
}
// 点击删除标签
- (void)tagDelete:(ZJTagButton *)deletedTagBtn{
    [UIView beginAnimations:nil context:nil];
    int index = (int)[self.tagBtns indexOfObject:deletedTagBtn];
    [deletedTagBtn removeFromSuperview];
    [self.tagBtns removeObject:deletedTagBtn];
    for (int i = index; i < self.tagBtns.count; i++) {
        ZJTagButton *tagBtn = self.tagBtns[i];
        if (i > 0) {
            ZJTagButton *previousTagButton = self.tagBtns[i - 1];
            // 这一行右边剩下的宽度
            CGFloat rightWidth = self.contentView.width - CGRectGetMaxX(previousTagButton.frame) - ZJSmallMargin;
            if (rightWidth >= tagBtn.width) {
                tagBtn.y = previousTagButton.y;
                tagBtn.x = CGRectGetMaxX(previousTagButton.frame) + ZJSmallMargin;
            } else {
                tagBtn.x = 0;
                tagBtn.y = CGRectGetMaxY(previousTagButton.frame) + ZJSmallMargin;
            }
        } else {
            tagBtn.x = 0;
            tagBtn.y = 0;
        }
    }
    [self setupTagFieldFrame];
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tagField endEditing:YES];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self addTag];
    return YES;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
