//
//  NRepositoriesViewController.m
//  nucleus
//
//  Created by Jeremy Templier on 17/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "NRepositoriesViewController.h"
#import <ObjectiveGit/ObjectiveGit.h>
#import "NRepositoryFormTableViewCell.h"
#import "NRepositoryTableViewCell.h"

@interface NRepositoriesViewController () <NRepositoryFormTableViewCellDelegate, NRepositoryTableViewCellDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation NRepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Repositories";
    UIBarButtonItem *bi1 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    bi1.style = UIBarButtonItemStyleBordered;
    bi1.width = 45;
    self.navigationItem.leftBarButtonItem = bi1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NRepositoryFormTableViewCell" bundle:nil] forCellReuseIdentifier:@"newRepositoryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NRepositoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"repositoryCell"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _dataSource = [userDefaults objectForKey:@"repositories"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 94;
    } else {
        return 116;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataSource ? _dataSource.count : 0;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NRepositoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repositoryCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *info = self.dataSource[indexPath.row];
        cell.nameLabel.text = info[@"title"];
        
        NSURL* appDocsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL* localURL = [NSURL URLWithString:info[@"title"] relativeToURL:appDocsDir];
        NSError *error = nil;
        GTRepository *repo = [GTRepository repositoryWithURL:localURL error:&error];
        if (error) {
            NSLog(@"%@", error);
            cell.commitLabel.text = @"Error";
        } else {
            GTReference* head = [repo headReferenceWithError:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            GTCommit* commit = [repo lookUpObjectBySHA:head.targetOID.SHA error:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            static NSDateFormatter *dateFormatter;
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateStyle = NSDateFormatterMediumStyle;
                dateFormatter.timeStyle = NSDateFormatterShortStyle;
            }
            cell.commitLabel.text = [NSString stringWithFormat:@"%@, %@\n%@", commit.author.name, [dateFormatter stringFromDate:commit.commitDate],commit.messageSummary];
        }
        return cell;
    } else {
        NRepositoryFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newRepositoryCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

- (void)cell:(NRepositoryFormTableViewCell *)cell didPressCloneRepositoryAt:(NSString *)url {
    [self fetchRepositoryAtURL:url];
}

- (void)cellDidPressDeleteRepository:(NRepositoryTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *repo = self.dataSource[indexPath.row];
    if (repo) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSURL* appDocsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL* localURL = [NSURL URLWithString:repo[@"title"] relativeToURL:appDocsDir];
        if ([fileManager fileExistsAtPath:localURL.path]) {
            [fileManager removeItemAtURL:localURL error:nil];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *repos = [self.dataSource mutableCopy];
        [repos removeObject:repo];
        [userDefaults setObject:repos forKey:@"repositories"];
        [userDefaults synchronize];
        _dataSource = repos;
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rootTreeChanged" object:self];
    }
}

- (void)fetchRepositoryAtURL:(NSString *)repoURL {
    GTRepository* repo = nil;
    //test @"https://github.com/jayztemplier/010-PrettyKit.git"
    NSString* url = repoURL;
    if (!url) {
        return;
    }
    NSError* error = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* appDocsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* localURL = [NSURL URLWithString:url.lastPathComponent relativeToURL:appDocsDir];
    if (![fileManager fileExistsAtPath:localURL.path isDirectory:nil]) {
        repo = [GTRepository cloneFromURL:[NSURL URLWithString:url] toWorkingDirectory:localURL options:@{GTRepositoryCloneOptionsTransportFlags: @YES} error:&error transferProgressBlock:^(const git_transfer_progress * __nonnull a, BOOL * __nonnull b) {
            NSLog(@"%d/%d", a->received_objects, a->total_objects);
        } checkoutProgressBlock:^(NSString *path, NSUInteger completedSteps, NSUInteger totalSteps) {
            NSLog(@"%d/%d", completedSteps, totalSteps);
        }];
        if (error) {
            NSLog(@"%@", error);
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Repository already cloned" message:@"We already have a repository with the same name on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!error) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *repos = [userDefaults objectForKey:@"repositories"];
        if (!repos) {
            repos = @[];
        }
        repos = [repos arrayByAddingObject:@{@"title" : url.lastPathComponent, @"url" : repoURL} ];
        [userDefaults setObject:repos forKey:@"repositories"];
        [userDefaults synchronize];
        _dataSource = repos;
        
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rootTreeChanged" object:self];
    }
}

- (void)donePressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
