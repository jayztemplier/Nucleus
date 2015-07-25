//
//  NDiffViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 23/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NDiffViewController.h"
#import "NDiffLinesTableViewCell.h"
#import "NDiffFileTableViewCell.h"

@interface NDiffViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *filesTableView;
@property (nonatomic, strong) UITableView *chunksTableView;
@property (nonatomic, strong) GTDiff *diffObject;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSString *selectedFile;
@end

@implementation NDiffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIToolbar *toolbar = [self setupToolbar];
    CGFloat filePanelWidth = 320.f;
    _filesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, toolbar.frame.size.height, filePanelWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _filesTableView.dataSource = self;
    _filesTableView.delegate = self;
    [_filesTableView registerNib:[UINib nibWithNibName:@"NDiffFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"fileCell"];
    
    _chunksTableView = [[UITableView alloc] initWithFrame:CGRectMake(filePanelWidth, toolbar.frame.size.height, CGRectGetWidth(self.view.bounds) - filePanelWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _chunksTableView.dataSource = self;
    _chunksTableView.delegate = self;
    _chunksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_chunksTableView registerNib:[UINib nibWithNibName:@"NDiffLinesTableViewCell" bundle:nil] forCellReuseIdentifier:@"chunkCell"];

    [self.view addSubview:_filesTableView];
    [self.view addSubview:_chunksTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_repositoryURL) {
        return;
    }
    NSError *error;
    GTRepository *repository = [GTRepository repositoryWithURL:_repositoryURL error:&error];
    _diffObject = [GTDiff diffWorkingDirectoryToHEADInRepository:repository options:nil error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    NSMutableDictionary *cache = [[NSMutableDictionary alloc] initWithCapacity:_diffObject.deltaCount];
    
    [_diffObject enumerateDeltasUsingBlock:^(GTDiffDelta *delta, BOOL *stop) {
        GTDiffPatch *patch = [delta generatePatch:nil];
        NSMutableArray *hunks = [[NSMutableArray alloc] initWithCapacity:patch.hunkCount];
        [patch enumerateHunksUsingBlock:^(GTDiffHunk *hunk, BOOL *stop) {
            [hunks addObject:hunk];
        }];
        cache[delta.newFile.path] = @{@"delta": delta, @"patch" : patch, @"hunks" : hunks};
    }];
    _dataSource = cache;
    [_filesTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedFile:(NSString *)selectedFile {
    if (![_selectedFile isEqualToString:selectedFile]) {
        _selectedFile = selectedFile;
        [_chunksTableView reloadData];
    }
}

- (UIToolbar *)setupToolbar {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    UIBarButtonItem *branches = [[UIBarButtonItem alloc] initWithTitle:@"Branches" style:UIBarButtonItemStylePlain target:self action:@selector(fetchPressed)];
    UIBarButtonItem *fetch = [[UIBarButtonItem alloc] initWithTitle:@"Fetch" style:UIBarButtonItemStylePlain target:self action:@selector(fetchPressed)];
    UIBarButtonItem *pull = [[UIBarButtonItem alloc] initWithTitle:@"Pull" style:UIBarButtonItemStylePlain target:self action:@selector(pullPressed)];
    UIBarButtonItem *push = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(pushPressed)];
    [toolBar setItems:@[branches, fetch, pull, push]];
    [self.view addSubview:toolBar];
    return toolBar;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _filesTableView) {
        return 1;
    } else if (tableView == _chunksTableView && _selectedFile) {
        NSDictionary *info = _dataSource[_selectedFile];
        if (info && info[@"patch"]) {
            GTDiffPatch *patch = info[@"patch"];
            return patch.hunkCount;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _filesTableView) {
        return _dataSource ? [[_dataSource allKeys] count] : 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chunksTableView) {
        NSDictionary *info = _dataSource[_selectedFile];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        if (info && info[@"hunks"]) {
            GTDiffHunk *hunk = info[@"hunks"][indexPath.section];
            [hunk enumerateLinesInHunk:nil usingBlock:^(GTDiffLine *diffLine, BOOL *stop) {
                NSMutableString *lineStr = [[NSMutableString alloc] init];
                UIColor *color = [UIColor whiteColor];
                if (diffLine.oldLineNumber == -1) {
                    [lineStr appendString:@"++"];
                    color = [UIColor greenColor];
                } else if (diffLine.newLineNumber == -1) {
                    [lineStr appendString:@"--"];
                    color = [UIColor redColor];
                }
                [lineStr appendString:diffLine.content];
                [lineStr appendString:@"\n"];
                
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:lineStr attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSBackgroundColorAttributeName : color}];
                [attrString appendAttributedString:str];
            }];
        }
        return [attrString size].height;
    }
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _filesTableView) {
        NDiffFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
        NSString *filename = [_dataSource allKeys][indexPath.row];
        cell.filenameLabel.text = filename;
        return cell;
    } else if (tableView == _chunksTableView) {
        NDiffLinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chunkCell"];
        NSDictionary *info = _dataSource[_selectedFile];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        if (info && info[@"hunks"]) {
            GTDiffHunk *hunk = info[@"hunks"][indexPath.section];
            [hunk enumerateLinesInHunk:nil usingBlock:^(GTDiffLine *diffLine, BOOL *stop) {
                NSMutableString *lineStr = [[NSMutableString alloc] init];
                UIColor *color = [UIColor whiteColor];
                if (diffLine.oldLineNumber == -1) {
                    [lineStr appendString:@"++"];
                    color = [UIColor greenColor];
                } else if (diffLine.newLineNumber == -1) {
                    [lineStr appendString:@"--"];
                    color = [UIColor redColor];
                }
                [lineStr appendString:diffLine.content];
                [lineStr appendString:@"\n"];
                
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:lineStr attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSBackgroundColorAttributeName : color}];
                [attrString appendAttributedString:str];
            }];
        }
        cell.textView.attributedText = attrString;
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _chunksTableView) {
        NSDictionary *info = _dataSource[_selectedFile];
        if (info && info[@"hunks"]) {
            GTDiffHunk *hunk = info[@"hunks"][section];
            return hunk.header;
        }
    }
    return @"";
}
#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _filesTableView) {
        NSString *filename = [_dataSource allKeys][indexPath.row];
        self.selectedFile = filename;
    }
}

#pragma mark - Actions
- (void)fetchPressed {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)pullPressed {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)pushPressed {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
