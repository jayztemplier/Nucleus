//
//  NDiffFileTableViewCell.h
//  nucleus
//
//  Created by Jeremy Templier on 23/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDiffFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UIButton *stageButton;
- (IBAction)stagePressed:(id)sender;
@end
