//
//  NRepositoryTableViewCell.h
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NRepositoryTableViewCell;
@protocol NRepositoryTableViewCellDelegate <NSObject>
- (void)cellDidPressDeleteRepository:(NRepositoryTableViewCell *)cell;
@end

@interface NRepositoryTableViewCell : UITableViewCell

@property (weak, nonatomic) id<NRepositoryTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitLabel;
@end
