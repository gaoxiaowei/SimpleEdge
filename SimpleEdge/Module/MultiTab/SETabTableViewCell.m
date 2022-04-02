//
//  SETabTableViewCell.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETabTableViewCell.h"
#import <Masonry/Masonry.h>

@interface SETabTableViewCell()
@property(nonatomic,strong) UILabel     *titleLabel;
@property(nonatomic,strong) UILabel     *urlLabel;
@end
@implementation SETabTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

-(instancetype)init{
    self =[super init];
    if(self){
        [self setupViews];
    }
    return self;
}
#pragma mark -layout
- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.urlLabel];
    [self setupLayout];
}

-(void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(8);
    }];
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
}
#pragma mark -lazy
-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UILabel*)urlLabel{
    if(!_urlLabel){
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font = [UIFont systemFontOfSize:14];
        _urlLabel.textColor = [UIColor blackColor];
    }
    return _urlLabel;
}
#pragma mark -config
- (void)configWithUrlTitle:(NSString*)urlTitle urlString:(NSString*)urlString selected:(BOOL)selected{
    self.titleLabel.text =urlTitle;
    self.urlLabel.text =urlString;
    self.selected=selected;
    if(self.selected){
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
