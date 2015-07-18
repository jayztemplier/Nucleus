//
//  ViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 15/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "ViewController.h"
#import "NTreeViewController.h"
#import "NEditorViewController.h"
#import "NTreeItem.h"
#import "NRepositoriesViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NTreeViewController *treeViewController;
@property (nonatomic, strong) NEditorViewController *editorViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _treeViewController = [[NTreeViewController alloc] initWithTreeItem:nil];
    _treeViewController.view.frame = CGRectMake(0, 0, 280, CGRectGetHeight(self.view.bounds));
    _treeViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self addChildViewController:_treeViewController];
    [self.view addSubview:_treeViewController.view];
    
    _editorViewController = [[NEditorViewController alloc] init];
    _editorViewController.view.frame = CGRectMake(CGRectGetWidth(_treeViewController.view.frame), 0,
                                                  CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_treeViewController.view.frame), CGRectGetHeight(self.view.bounds));
    _editorViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self addChildViewController:_editorViewController];
    [self.view addSubview:_editorViewController.view];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kSelectedFileChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NTreeItem *item = note.userInfo[@"treeItem"];
        _editorViewController.filePath = item.path;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRepoPressed:(id)sender
{
    NRepositoriesViewController *controller = [[NRepositoriesViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}


@end
