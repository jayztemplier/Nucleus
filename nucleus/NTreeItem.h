//
//  NTreeItem.h
//  nucleus
//
//  Created by Jeremy Templier on 16/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTreeItem : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, assign) BOOL isDirectory;
@property (nonatomic, assign) NSInteger level;
- (void)invalidate;
@end
