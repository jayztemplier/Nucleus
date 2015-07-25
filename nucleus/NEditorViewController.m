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
#import "NSyntaxHighlightTextStorage.h"

#define USE_NATIVE_EDITOR YES

@interface NEditorViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIWebView *editorWebView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSyntaxHighlightTextStorage* textStorage;
@property (nonatomic, strong) NSDate *lastEditedDate;
@property (nonatomic, copy) NSString *filepath;
@end

@implementation NEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (USE_NATIVE_EDITOR) {
        [self createTextView];
    } else {
        [self.view addSubview:self.editorWebView];
    }
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self loadFile:_filePath];
    [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFile:(NSString *)filePath {
    _filePath = filePath;
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
                    [weakSelf.textStorage setAttributedString:attrString];
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

- (void)createTextView
{
    _textStorage = [NSyntaxHighlightTextStorage new];
    CGRect newTextViewRect = self.view.bounds;
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    // 3. Create a text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    // 4. Create a UITextView
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:container];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textView.backgroundColor = [UIColor blackColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
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
- (void)update:(NSTimer *)timer {
    if (!_lastEditedDate) {
        return;
    }
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval timeInterval = [methodFinish timeIntervalSinceDate:_lastEditedDate];
    if (timeInterval > .5f) {
        _lastEditedDate = nil;
        [self updateSyntaxHighlight];
        [self saveFile];
    }
}

- (void)updateSyntaxHighlight {
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAttributedString *attrString = [RPSyntaxHighlighter highlightCode:weakSelf.textView.text withLanguage:weakSelf.language];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.textView.attributedText.string isEqualToString:attrString.string]) {
                [weakSelf.textStorage setAttributedString:attrString];
            }
        });
    });
}

- (void)saveFile {
    NSError *error = nil;
    [_textView.text writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error saving file: %@", error);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    _lastEditedDate = [NSDate date];
}
@end
