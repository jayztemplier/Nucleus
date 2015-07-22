//
//  NEditorViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 15/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NEditorViewController.h"
#import "RPSyntaxHighlighter.h"
#import "RPLanguages.h"

#define USE_NATIVE_EDITOR YES

@interface NEditorViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIWebView *editorWebView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *language;
@end

@implementation NEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (USE_NATIVE_EDITOR) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];

//        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
//        NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
//        [textStorage addLayoutManager:textLayout];
//        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
//        [textLayout addTextContainer:textContainer];
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20,20,self.view.bounds.size.width-20,self.view.bounds.size.height-20)
//                                                   textContainer:textContainer];
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor blackColor];
        _textView.delegate = self;
        [self.view addSubview:_textView];
    } else {
        [self.view addSubview:self.editorWebView];
    }
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self loadFile:_filePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFile:(NSString *)filePath {
    NSString* htmlFilePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *code = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (USE_NATIVE_EDITOR) {
        NSString *extension = [[filePath componentsSeparatedByString:@"."] lastObject];
        _language = [RPLanguages languageForFileExtension:extension];
        if (code) {
            __weak __typeof__(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSAttributedString *attrString = [RPSyntaxHighlighter highlightCode:code withLanguage:weakSelf.language];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.textView.attributedText = attrString;
                });
            });

        } else {
            _textView.text = @"";
        }
    } else {
        if (code) {
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{CODE}}" withString:code];
        } else {
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{CODE}}" withString:@""];
        }
        [self.editorWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@""]];
    }
}

- (void)setFilePath:(NSString *)filePath {
    if (filePath && ![_filePath isEqualToString:filePath]) {
        _filePath = filePath;
        [self loadFile:_filePath];
    }
}

- (NSString *)aceJSFilepath {
    static NSString *aceFilepath;
    if (!aceFilepath) {
        aceFilepath = [[NSBundle mainBundle] pathForResource:@"ace" ofType:@"js"];
    }
    return aceFilepath;
}

- (UIWebView *)editorWebView {
    if (!_editorWebView) {
        _editorWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _editorWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _editorWebView;
}

#pragma mark - Text View Delegate 
- (void)textViewDidChange:(UITextView *)textView {
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAttributedString *attrString = [RPSyntaxHighlighter highlightCode:textView.text withLanguage:weakSelf.language];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.textView.attributedText.string isEqualToString:attrString.string]) {
                NSRange selectedRange = weakSelf.textView.selectedRange;
                weakSelf.textView.scrollEnabled = NO;
                weakSelf.textView.attributedText = attrString;
                weakSelf.textView.selectedRange = selectedRange;
                weakSelf.textView.scrollEnabled = YES;
            }
        });
    });
}
@end
