//
//  ViewController.m
//  SuperHeroPedia
//
//  Created by William Lundy on 10/12/15.
//  Copyright © 2015 William Lundy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *heroes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSDictionary *hero  =   [NSDictionary dictionaryWithObjectsAndKeys:@"Batman", @"name",
//                             @32, @"age", nil];
//    
//    NSDictionary *heroTwo  =   [NSDictionary dictionaryWithObjectsAndKeys:@"Captain America", @"name",
//                             @95, @"age", nil];
//    
//    NSDictionary *heroThree  =   @{@"name":@"Iron Man",
//                                    @"age":@40};
//    
//    self.heroes = [NSArray arrayWithObjects:hero, heroTwo, heroThree, nil];
    
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mmios8week/superheroes.json"];
    NSError *error;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.heroes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [task resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *hero = [self.heroes objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [hero objectForKey:@"name"];
    cell.detailTextLabel.text = hero[@"description"];
    
    NSURL *url = [NSURL URLWithString:hero[@"avatar_url"]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:data];
            [cell layoutSubviews];
        });
    }];
    
    [task resume];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.heroes.count;
}

@end
