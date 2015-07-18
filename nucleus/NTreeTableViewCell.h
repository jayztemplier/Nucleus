//
//  NTreeTableViewCell.h
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTreeTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isExpanded;
- (void)setupWithName:(NSString *)name treeLevel:(NSInteger)level directory:(BOOL)isDirectory;
@end
