//
//  BBAllMeetupsTableViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBAllMeetupsTableViewController.h"
#import "BBMeetupCell.h"
#import "BBMeetupLocation.h"
#import "BBMapLocationViewController.h"

@interface BBAllMeetupsTableViewController ()

@end

@implementation BBAllMeetupsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _meetupsArray = [NSArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"BBMeetupLocation"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _meetupsArray = objects;
        [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.meetupsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    BBMeetupCell *cell = (BBMeetupCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BBMeetupCell" owner:self options:nil];
        cell = [nib objectAtIndex:0]; // custom cell
    }
    
    PFObject *location = self.meetupsArray[indexPath.row];
    
    cell.user.text = location[@"userPointer"];
    cell.meetupName.text = location[@"meetingName"];
    cell.meetupLocation.text = location[@"locationName"];
    cell.startDate.text = [NSString stringWithFormat:@"%@", location[@"startDate"]];
    cell.endDate.text = [NSString stringWithFormat:@"%@", location[@"endDate"]];
    cell.latitude.text = [NSString stringWithFormat:@"%@",location[@"latitudeValue"]];
    cell.longitude.text = [NSString stringWithFormat:@"%@", location[@"longitudeValue"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 171;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBMeetupCell *cell = (BBMeetupCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"locationSegue" sender:cell];
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BBMapLocationViewController *newVC = segue.destinationViewController;
    
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    PFObject *currentObject = self.meetupsArray[ip.row];
    
    BBMeetupLocation *locationTobeDisplayed = [[BBMeetupLocation alloc]
                                               initWithMeetingName:currentObject[@"meetingName"]
                                               withLocationName:currentObject[@"locationName"]
                                               withStartDate:currentObject[@"startDate"]
                                               withEndDate:currentObject[@"endDate"]
                                               withLatidue:currentObject[@"latitudeValue"]
                                               withLongitude:currentObject[@"longitudeValue"]];
    newVC.locationToBeParsed = locationTobeDisplayed;
}

@end
