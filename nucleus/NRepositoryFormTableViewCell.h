//
//  NRepositoryFormTableViewCell.h
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRepositoryFormTableViewCell;
@protocol NRepositoryFormTableViewCellDelegate <NSObject>
- (void)cell:(NRepositoryFormTableViewCell *)cell didPressCloneRepositoryAt:(NSString *)url;
@end

@interface NRepositoryFormTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, weak) id<NRepositoryFormTableViewCellDelegate> delegate;
@end
