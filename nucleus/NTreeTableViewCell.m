//
//  NTreeTableViewCell.m
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NTreeTableViewCell.h"

#define filenameX 8.f
#define filenameY 4.f
#define indentSize 20.f
#define marginLeft 5.f
#define rowHeight 30.f
#define textColor [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1]
@interface NTreeTableViewCell ()
@property (nonatomic, strong) UILabel *filenameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) BOOL isDirectory;
@end


@implementation NTreeTableViewCell

- (void)setupWithName:(NSString *)name treeLevel:(NSInteger)level directory:(BOOL)isDirectory{
    [self.contentView setBackgroundColor:[UIColor colorWithRed:0.187 green:0.187 blue:0.187 alpha:1]];
    self.filenameLabel.text = name;
    _isDirectory = isDirectory;
//    self.iconImageView.hidden = !isDirectory;
//    self.accessoryType = isDirectory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    CGFloat left = 16 + marginLeft + indentSize * (CGFloat)level;
    
    CGRect titleFrame = self.filenameLabel.frame;
    titleFrame.origin.x = left;
    self.filenameLabel.frame = titleFrame;
    
    CGRect imageFrame = self.iconImageView.frame;
    imageFrame.origin.x = left - 16 - marginLeft;
    self.iconImageView.frame = imageFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.filenameLabel];
    [self.contentView addSubview:self.iconImageView];
}

- (void)setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    if (_isDirectory) {
        self.iconImageView.image = [[UIImage imageNamed:_isExpanded ? @"folder-open" : @"folder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        self.iconImageView.image = [[UIImage imageNamed:@"file"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

- (UILabel *)filenameLabel {
    if (!_filenameLabel) {
        CGSize size = self.contentView.frame.size;
        _filenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(filenameX, filenameY, size.width - 16.0, rowHeight - 16.0)];
        [_filenameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

        [_filenameLabel setTextColor:textColor];
        [_filenameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return _filenameLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(filenameX, rowHeight/2 - 8, 16.0, 16.0)];
        [_iconImageView setTintColor:textColor];
    }
    return _iconImageView;
}
@end
