//
//  NEditorViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 15/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NEditorViewController.h"
#import "QEDTextView.h"

@interface NEditorViewController ()
@property (nonatomic, strong) UIWebView *editorWebView;
@property (nonatomic, strong) QEDTextView *textView;
@end

@implementation NEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView = [[QEDTextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _textView.delegate = self;
    [self.view addSubview:_textView];
    
//    [self.view addSubview:self.editorWebView];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self loadFile:_filePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFile:(NSString *)filePath {
    NSString* htmlFilePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *code = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (code) {
        _textView.text = code;
        return;

        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{CODE}}" withString:code];
    } else {
        return;
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{{CODE}}" withString:@""];
    }
    [self.editorWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@""]];
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
@end
