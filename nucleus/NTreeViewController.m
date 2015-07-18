//
//  NTreeViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 15/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NTreeViewController.h"
#import "RATreeView.h"
#import "NEditorViewController.h"
#import "NTreeItem.h"
#import "NTreeTableViewCell.h"

@interface NTreeViewController () <RATreeViewDelegate, RATreeViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NTreeItem *treeItem;
@property (nonatomic, strong) RATreeView *treeView;
@end

@implementation NTreeViewController

- (instancetype)initWithTreeItem:(NTreeItem *)treeItem {
    self = [super init];
    if (self) {
        _treeItem = treeItem;
        if (!_treeItem) {
            NSURL* appDocsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            _treeItem = [NTreeItem new];
            _treeItem.path = appDocsDir.path;
            _treeItem.isDirectory = YES;
            _treeItem.level = 1;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.treeView];
    _dataSource = self.treeItem.children;
    [[NSNotificationCenter defaultCenter] addObserverForName:kTreeChangedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self refresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RATreeView *)treeView {
    if (!_treeView) {
        _treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
        _treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.estimatedRowHeight = 30;
        _treeView.rowHeight = 30;
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        _treeView.separatorColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.5];
        [_treeView setBackgroundColor:[UIColor colorWithRed:0.187 green:0.187 blue:0.187 alpha:1]];
        [_treeView registerClass:[NTreeTableViewCell class] forCellReuseIdentifier:@"treeCell"];
    }
    return _treeView;
}

- (void)refresh {
    [_treeItem invalidate];
    _dataSource = self.treeItem.children;
    [self.treeView reloadData];
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(NTreeItem *)item
{
    return 30;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(NTreeItem *)item
{
    return YES;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(NTreeItem *)item
{
    NTreeTableViewCell *cell = (NTreeTableViewCell *)[treeView cellForItem:item];
    cell.isExpanded = YES;
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(NTreeItem *)item
{
    NTreeTableViewCell *cell = (NTreeTableViewCell *)[treeView cellForItem:item];
    cell.isExpanded = NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(NTreeItem *)item {
    if (!item.isDirectory) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedFileChangedNotificationName object:self userInfo:@{@"treeItem": item}];
    }
}

//- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
//{
//    if (editingStyle != UITableViewCellEditingStyleDelete) {
//        return;
//    }
//    
//    RADataObject *parent = [self.treeView parentForItem:item];
//    NSInteger index = 0;
//    
//    if (parent == nil) {
//        index = [self.data indexOfObject:item];
//        NSMutableArray *children = [self.data mutableCopy];
//        [children removeObject:item];
//        self.data = [children copy];
//        
//    } else {
//        index = [parent.children indexOfObject:item];
//        [parent removeChild:item];
//    }
//    
//    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
//    if (parent) {
//        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
//    }
//}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(NTreeItem *)item
{
    NSInteger level = [self.treeView levelForCellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];    
    NTreeTableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:@"treeCell"];
    [cell setupWithName:item.name treeLevel:level directory:item.isDirectory];
    cell.isExpanded = expanded;
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(NTreeItem *)item
{
    if (item == nil) {
        return [self.dataSource count];
    }
    return [item.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(NTreeItem *)item
{
    if (item == nil) {
        return [self.dataSource objectAtIndex:index];
    }
    
    return item.children[index];
}

@end
