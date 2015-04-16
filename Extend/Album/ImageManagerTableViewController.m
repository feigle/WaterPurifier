//
//  ImageManagerTableViewController.m
//  VideoMonitor
//
//  Created by Andy on 14-8-29.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "ImageManagerTableViewController.h"
#import "PPImageScrollingTableViewCell.h"

@interface ImageManagerTableViewController ()<PPImageScrollingTableViewCellDelegate>

@property (strong, nonatomic) NSArray *images;

@end

@implementation ImageManagerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PPImageScrollingTableView";
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    
    self.tableView.frame = CGRectMake(0, 20+64, MRScreenWidth, MRScreenHeight);
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[PPImageScrollingTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.images = @[
                    @{ @"category": @"Category A",
                       @"images":
                           @[
                               @{ @"name":@"sample_1.jpeg", @"title":@"A-0"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"A-1"},
                               @{ @"name":@"sample_3.jpeg", @"title":@"A-2"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"A-3"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"A-4"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"A-5"}
                               ]
                       },
                    @{ @"category": @"Category B",
                       @"images":
                           @[
                               @{ @"name":@"sample_3.jpeg", @"title":@"B-0"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"B-1"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"B-2"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"B-3"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"B-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"B-5"}
                               ]
                       },
                    @{ @"category": @"Category C",
                       @"images":
                           @[
                               @{ @"name":@"sample_6.jpeg", @"title":@"C-0"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"C-1"},
                               @{ @"name":@"sample_3.jpeg", @"title":@"C-2"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"C-3"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"C-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"C-5"}
                               ]
                       },
                    @{ @"category": @"Category D",
                       @"images":
                           @[
                               @{ @"name":@"sample_3.jpeg", @"title":@"D-0"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"D-1"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"D-2"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"D-3"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"D-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"D-5"}
                               ]
                       },
                    @{ @"category": @"Category E",
                       @"images":
                           @[
                               @{ @"name":@"sample_3.jpeg", @"title":@"D-0"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"D-1"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"D-2"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"D-3"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"D-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"D-5"}
                               ]
                       }

                    ];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(BOOL)shouldAutorotate

{
    return NO;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *cellData = [self.images objectAtIndex:[indexPath section]];
    PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [customCell setBackgroundColor:[UIColor grayColor]];
    [customCell setDelegate:self];
    [customCell setImageData:cellData];
    [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor whiteColor]];
    [customCell setTag:[indexPath section]];
    [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [customCell setImageTitleLabelWitdh:90 withHeight:45];
    [customCell setCollectionViewBackgroundColor:[UIColor darkGrayColor]];
    
    return customCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - PPImageScrollingTableViewCellDelegate

- (void)scrollingTableViewCell:(PPImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex
{
    
    NSDictionary *images = [self.images objectAtIndex:categoryRowIndex];
    NSArray *imageCollection = [images objectForKey:@"images"];
    NSString *imageTitle = [[imageCollection objectAtIndex:[indexPathOfImage row]]objectForKey:@"title"];
    NSString *categoryTitle = [[self.images objectAtIndex:categoryRowIndex] objectForKey:@"category"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"Image %@",imageTitle]
                                                    message:[NSString stringWithFormat: @"in %@",categoryTitle]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
