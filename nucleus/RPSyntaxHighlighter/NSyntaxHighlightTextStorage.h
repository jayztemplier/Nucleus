//
//  NSyntaxHighlightTextStorage.h
//  nucleus
//
//  Created by Jeremy Templier on 21/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSyntaxHighlightTextStorage : NSTextStorage
{
    NSMutableAttributedString *_backingStore;
}
@end
