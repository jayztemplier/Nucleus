//
//  NTreeItem.m
//  nucleus
//
//  Created by Jeremy Templier on 16/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NTreeItem.h"

@implementation NTreeItem

- (void)invalidate {
    _children = nil;
}

- (NSString *)name {
    return [self.path lastPathComponent];
}

- (NSArray *)children {
    if (self.isDirectory && !_children) {
        _children = [self listFileAtPath:self.path];
    }
    return _children;
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    int count;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *tree = [NSMutableArray array];
    BOOL isDirectory;
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSString *filePath = [path stringByAppendingPathComponent:[directoryContent objectAtIndex:count]];
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        NTreeItem *item = [NTreeItem new];
        item.path = filePath;
        item.isDirectory = isDirectory;
        item.level = self.level + 1;
        [tree addObject:item];
    }
    return tree;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NRTreeItem: %@ - %@", self.isDirectory ? @"[D]" : @"[F]", self.name];
}

@end
