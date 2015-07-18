//
//  NRepositoryTableViewCell.m
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NRepositoryTableViewCell.h"

@implementation NRepositoryTableViewCell

- (IBAction)deletePressed:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidPressDeleteRepository:)]) {
        [_delegate cellDidPressDeleteRepository:self];
    }
}

@end
