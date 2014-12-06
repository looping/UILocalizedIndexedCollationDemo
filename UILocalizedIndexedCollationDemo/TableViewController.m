//
//  TableViewController.m
//  UILocalizedIndexedCollation
//
//  Created by Looping on 12/6/14.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "TableViewController.h"

@interface Blog : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *date;

- (NSString *)sortByTitle;
- (NSString *)sortByAuthor;

@end

@implementation Blog

- (NSString *)sortByTitle {
    return _title;
}

- (NSString *)sortByAuthor {
    return _author;
}

@end

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    [self setObjects:[self genData]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (NSArray *)genData {
    NSMutableArray *blogs = [@[] mutableCopy];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"title";
        blog.subtitle = @"subtitle";
        blog.content = @"content";
        blog.author = @"author";
        
        blog;
    })];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"Apple";
        blog.subtitle = @"Think Different";
        blog.content = @"iMac, iPod, iPhone, iPad ...";
        blog.author = @"Jobs & Wozniak & Wayne";
        
        blog;
    })];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"中文";
        blog.subtitle = @"副标题";
        blog.content = @"这是一篇没有实质性内容的文章";
        blog.author = @"无名";
        
        blog;
    })];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"阿里巴巴";
        blog.subtitle = @"让天下没有难做的生意";
        blog.content = @"淘宝，支付宝，阿里云 ...";
        blog.author = @"马云 & ...";
        
        blog;
    })];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"Google";
        blog.subtitle = @"Don't Be Evil";
        blog.content = @"Don't Get Caught Being Evil!";
        blog.author = @"Page & Brin";
        
        blog;
    })];
    
    [blogs addObject:({
        Blog *blog = [Blog new];
        blog.title = @"Microsoft";
        blog.subtitle = @"Let everyone have a computer";
        blog.content = @"Equipment and Service, Be What's Next, One Microsoft ...";
        blog.author = @"Gates & Allen";
        
        blog;
    })];
    
    return blogs;
}

- (void)setObjects:(NSArray *)objects {
    SEL selector = @selector(sortByTitle);
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    _dataSource = mutableSections;
    
    [self.tableView reloadData];
}

#pragma mark - Dismiss

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource ? _dataSource.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_dataSource[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Blog *blog = _dataSource[indexPath.section][indexPath.row];
    
    cell.textLabel.text = blog.title;
    cell.detailTextLabel.text = blog.subtitle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((NSArray *)_dataSource[section]).count ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
