//
//  NSyntaxHighlightTextStorage.h
//  nucleus
//
//  Created by Jeremy Templier on 21/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPSyntaxHighlighter;
@interface NSyntaxHighlightTextStorage : NSTextStorage
{
    NSMutableAttributedString *_backingStore;
}

@property (nonatomic, strong) RPSyntaxHighlighter *syntaxHighlighter;
@property (nonatomic, strong) NSString *syntaxLanguage;
@end
