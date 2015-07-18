//
//  NRepositoryFormTableViewCell.m
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NRepositoryFormTableViewCell.h"

@implementation NRepositoryFormTableViewCell

- (IBAction)clonePressed:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cell:didPressCloneRepositoryAt:)]) {
        [_delegate cell:self didPressCloneRepositoryAt:self.urlTextField.text];
    }
}

@end
