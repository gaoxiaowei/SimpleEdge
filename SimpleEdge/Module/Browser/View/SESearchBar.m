//
//  SESearchBar.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SESearchBar.h"
#import <Masonry/Masonry.h>
#import "SEInputAccessoryView.h"
#import "SEURLTool.h"

@interface SESearchBar ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView                *borderView;
@property (nonatomic, strong) UIButton              *cancelBtn;
@property (nonatomic, strong) UITextField           *textField;
@property (nonatomic, strong) SEInputAccessoryView  *inputView;
@property (nonatomic, strong) UIButton              *clearButton;

@end

@implementation SESearchBar
@synthesize searchText = _synSearchText;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shouldSelectAll = YES;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.borderView];
    [self addSubview:self.cancelBtn];
    [self.borderView addSubview:self.textField];
    [self setupLayout];
}

#pragma mark - init status
- (void)focusOnTextField {
    [self.textField becomeFirstResponder];
}

- (void)loseFocusOnTextField {
    [self.textField resignFirstResponder];
}

- (void)setSearchText:(NSString *)searchText {
    _synSearchText = searchText;
    self.textField.text = searchText;
}

- (NSString *)searchText {
    _synSearchText = self.textField.text;
    return _synSearchText;
}

#pragma mark - action
- (void)clickCancelBtn {
    if ([self.delegate respondsToSelector:@selector(searchBar:didClickCacncel:)]) {
        [self.delegate searchBar:self didClickCacncel:self.cancelBtn];
    }
}

- (void)clickClearBtn {
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([SEURLTool isUrl:textField.text] && self.shouldSelectAll) {
        [textField selectAll:self];
        [self performSelector:@selector(layoutTextField) withObject:self afterDelay:1.0/20.0];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchBar:didClickSearch:)]) {
        [self.delegate searchBar:self didClickSearch:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)layoutTextField{
    [self.textField setNeedsLayout];
}

#pragma mark - inputAccessoryView
- (void)inputViewSelectString:(NSString *)str {
    UITextField *textField = self.textField;
    NSInteger pos = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSInteger rangeLength = [textField offsetFromPosition:textField.selectedTextRange.start toPosition:textField.selectedTextRange.end];
    NSInteger length = [textField.text length];
    unichar c = 8198; //中文输入法下的空格留白字符
    NSString *text = textField.text;
    NSString *space = [NSString stringWithCharacters:&c length:1];
    [textField.superview becomeFirstResponder];
    [textField becomeFirstResponder];
    
    textField.text = [text stringByReplacingOccurrencesOfString:space withString:@""];
    NSInteger newLenght = [textField.text length];
    NSInteger newPos = pos - (length-newLenght);
    UITextPosition *newStart = [textField positionFromPosition:textField.beginningOfDocument offset:newPos];
    UITextPosition *newEnd = [textField positionFromPosition:newStart offset:rangeLength];
    textField.selectedTextRange = [textField textRangeFromPosition:newStart toPosition:newEnd];
    [textField replaceRange:textField.selectedTextRange withText:str];
    UITextPosition *resultPos = [textField positionFromPosition:textField.beginningOfDocument offset:newPos+str.length];
    textField.selectedTextRange = [textField textRangeFromPosition:resultPos toPosition:resultPos];
}

#pragma mark - layout
- (void)setupLayout {
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-65);
        make.height.mas_equalTo(38);
        make.centerY.equalTo(self);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.equalTo(self);
        make.width.mas_equalTo(65);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.borderView);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-12);
    }];
}

#pragma mark - lazy
- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = SE_HEXCOLOR(0xF1F3F4);
        _borderView.layer.cornerRadius = 19;
        _borderView.layer.masksToBounds = YES;
    }
    return _borderView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:SE_HEXCOLOR(0x007AFF) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UITextField *)textField {
    if (!_textField) {
        UIView *rightSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 24)];
        [rightSearchView addSubview:self.clearButton];
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16.0];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.returnKeyType = UIReturnKeyGo;
        _textField.rightViewMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.textColor = SE_HEXCOLOR(0x000000);
        _textField.attributedPlaceholder = [self placeHolder];
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.delegate = self;
        _textField.rightView = rightSearchView;
        _textField.inputAccessoryView = self.inputView;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (SEInputAccessoryView *)inputView {
    if (!_inputView) {
        _inputView = [[SEInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, kSE_ScreenWidth, 50)];
        __weak SESearchBar *weakself = self;
        _inputView.selectStrAction = ^(NSString *str) {
            [weakself inputViewSelectString:str];
        };
    }
    return _inputView;
}

-(UIButton*)clearButton{
    if(!_clearButton){
        _clearButton =[[UIButton alloc]initWithFrame: CGRectMake(4, 2, 20, 20)];
        _clearButton.backgroundColor = [UIColor lightGrayColor];
        _clearButton.layer.cornerRadius = 10;
        _clearButton.layer.masksToBounds = YES;
        [_clearButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        _clearButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *img = [UIImage imageNamed:@"xmark"];
        [_clearButton setImage:img forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (NSAttributedString *)placeHolder {
    NSString *str = @"搜索或输入Web地址";
    NSDictionary *dict = @{NSForegroundColorAttributeName:SE_HEXCOLOR(0x444444),
                           NSFontAttributeName:[UIFont systemFontOfSize:16]};
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:str attributes:dict];
    return att;
}
@end
