//
//  NDiffFileTableViewCell.m
//  nucleus
//
//  Created by Jeremy Templier on 23/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NDiffFileTableViewCell.h"

@implementation NDiffFileTableViewCell

- (void)awakeFromNib {
    _stageButton.layer.borderWidth = 1.f;
    _stageButton.layer.borderColor = _stageButton.tintColor.CGColor;
    _stageButton.layer.cornerRadius = 3.f;
}

- (IBAction)stagePressed:(id)sender {
}
@end
