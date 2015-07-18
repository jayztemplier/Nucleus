//
//  NTreeViewController.h
//  nucleus
//
//  Created by Jeremy Templier on 15/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectedFileChangedNotificationName @"selectedFileChanged"
#define kTreeChangedNotificationName @"rootTreeChanged"

@class NTreeItem;
@interface NTreeViewController : UIViewController
- (instancetype)initWithTreeItem:(NTreeItem *)treeItem;
- (void)refresh;
@end
