//
//  SEMutltiTabViewController.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEMutltiTabViewController.h"
#import <Masonry/Masonry.h>
#import "SETabTableViewCell.h"
#import "SETab.h"
#import "SETabManager.h"
#import "SEUtlity.h"

const NSInteger kSEMutltiTabButtonPortraitLRMargin  =8;
const NSInteger kSEMutltiTabButtonLandscapeLRMargin =32;

@interface SEMutltiTabViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)UIView                   *topView;
@property(nonatomic,strong)UIButton                 *leftButton;
@property(nonatomic,strong)UIButton                 *editButton;
@property(nonatomic,strong)UIButton                 *rightButton;
@property(nonatomic,strong)UILabel                  *titleLabel;
@property(nonatomic,strong)UIView                   *lineView;
@property(nonatomic,strong)NSMutableArray<SETab*>   *dataArray;
@end

@implementation SEMutltiTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.hidden = YES;
    [self setupViews];
    [self.dataArray addObjectsFromArray:[[SETabManager shared]getAllTab]];
    [self.tableView reloadData];

}
#pragma mark -layout
-(void)setupViews{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.leftButton];
    [self.topView addSubview:self.editButton];
    [self.topView addSubview:self.rightButton];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.lineView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44.5);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        BOOL isLandscape = [SEUtlity isLandScapeMode];
        if(isLandscape){
            make.left.equalTo(self.topView).offset(kSEMutltiTabButtonLandscapeLRMargin);
        }else{
            make.left.equalTo(self.topView).offset(kSEMutltiTabButtonPortraitLRMargin);
        }
        make.width.height.mas_equalTo(44);
        make.top.equalTo(self.topView).offset(0);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        BOOL isLandscape = [SEUtlity isLandScapeMode];
        if(isLandscape){
            make.right.equalTo(self.topView).offset(-kSEMutltiTabButtonLandscapeLRMargin);
        }else{
            make.right.equalTo(self.topView).offset(-kSEMutltiTabButtonPortraitLRMargin);
        }
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(24);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton.mas_left).offset(-16);
        make.width.height.top.mas_equalTo(self.leftButton);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right).offset(5);
        make.right.equalTo(self.rightButton.mas_left).offset(-5);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.leftButton);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.right.equalTo(self.topView);
        make.bottom.equalTo(self.topView).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

-(void)updateLayout{
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        BOOL isLandscape = [SEUtlity isLandScapeMode];
        if(isLandscape){
            make.left.equalTo(self.topView).offset(kSEMutltiTabButtonLandscapeLRMargin);
        }else{
            make.left.equalTo(self.topView).offset(kSEMutltiTabButtonPortraitLRMargin);
        }
    }];
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        BOOL isLandscape = [SEUtlity isLandScapeMode];
        if(isLandscape){
            make.right.equalTo(self.topView).offset(-kSEMutltiTabButtonLandscapeLRMargin);
        }else{
            make.right.equalTo(self.topView).offset(-kSEMutltiTabButtonPortraitLRMargin);
        }
    }];
}
#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SETabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SETabTableViewCell cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SETab *cellModel = self.dataArray[indexPath.row];
    [cell configWithUrlTitle:cellModel.title urlString:cellModel.url.absoluteString selected:cellModel.selected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SETab *tab = self.dataArray[indexPath.item];
    [[SETabManager shared] selectTab:tab];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        SETab*tab =self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [[SETabManager shared]removeTabAndUpdateSelectedIndex:tab];
        [tableView reloadData];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    SETab *model = self.dataArray[sourceIndexPath.row];
    [self.dataArray removeObject:model];
    [self.dataArray insertObject:model atIndex:destinationIndexPath.row];
    [[SETabManager shared]changeTabIndex:sourceIndexPath.row destinationIndex:destinationIndexPath.row];
}

#pragma mark -lazy
-(UIView*)topView{
    if(!_topView){
        _topView=[UIView new];
        _topView.backgroundColor =[UIColor whiteColor];
    }
    return _topView;
}

- (UIView *)lineView{
   if (!_lineView) {
       _lineView = [UIView new];
       _lineView.backgroundColor = [UIColor grayColor];
   }
   return _lineView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor grayColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:SETabTableViewCell.class forCellReuseIdentifier:[SETabTableViewCell cellIdentifier]];
    }
    return _tableView;
}

-(UIButton*)leftButton{
    if(!_leftButton){
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateHighlighted];
        @weakify(self)
        [[_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self handleLeftButtonEvent];
        }];
    }
    return _leftButton;
}

-(UIButton*)editButton{
    if(!_editButton){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [_editButton setTitle:@"Done" forState:UIControlStateSelected];
        @weakify(self)
        [[_editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self handleEditButtonEvent];
        }];
    }
    return _editButton;
}

-(UIButton*)rightButton{
    if(!_rightButton){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = SE_HEXCOLOR(0xF1F3F4);
        _rightButton.layer.cornerRadius = 12;
        _rightButton.layer.masksToBounds = YES;
        [_rightButton setImage:[UIImage imageNamed:@"xmark"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"xmark"] forState:UIControlStateHighlighted];
        [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 0)];
        _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _rightButton;
}

-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = SE_HEXCOLOR(0x222222);
        _titleLabel.text=@"Opened tabs";
    }
    return _titleLabel;
}

-(NSMutableArray*)dataArray{
    if(!_dataArray){
        _dataArray =[NSMutableArray new];
    }
    return _dataArray;
}
#pragma mark- button action

-(void)handleLeftButtonEvent{
    SETabManager *tabManager = [SETabManager shared];
    SETab *newTab = [tabManager addTabWithURLString:kSEHomeUrl];
    [tabManager selectTab:newTab];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleEditButtonEvent{
   BOOL flag = !_tableView.editing;
   [_tableView setEditing:flag animated:YES];
   _editButton.selected = flag;
}

#pragma mark- viewWillTransition
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateLayout];
}

@end
