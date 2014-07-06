//
//  BBMapTableViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBMapTableViewController.h"

@interface BBMapTableViewController ()

@end

@implementation BBMapTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentUser = [PFUser currentUser];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _titleField.text = [NSString stringWithFormat:@"%@'s meetings",self.currentUser.username];
    
    _meetupsArray = [NSArray new];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"BBMeetupLocation"];
    [query whereKey:@"userPointer" equalTo:self.currentUser.objectId];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shortMeetupCell" forIndexPath:indexPath];
    
    PFObject *location = self.meetupsArray[indexPath.row];
    
    cell.textLabel.text = location[@"meetingName"];
    
    cell.detailTextLabel.text = location.objectId;
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *location = self.meetupsArray[indexPath.row];
    self.locationToBeParsed = [[BBMeetupLocation alloc]initWithMeetingName:location[@"meetingName"]
                                                          withLocationName:location[@"locationName"]
                                                             withStartDate:location[@"startDate"]
                                                               withEndDate:location[@"endDate"]
                                                               withLatidue:location[@"latitudeValue"]
                                                             withLongitude:location[@"longitudeValue"]];
    
    [self plotCurrentPoint];
}

- (void)plotCurrentPoint
{
    double latitudeDouble =[self.locationToBeParsed.latitude doubleValue];
    double longitudeDouble = [self.locationToBeParsed.longitude doubleValue];
    
    self.coordinate = [[CLLocation alloc]initWithLatitude:latitudeDouble longitude:longitudeDouble];
    
    [self updateMapView:self.coordinate];
    [self plotLocationPin];
}

- (void)updateMapView:(CLLocation *)location
{
    // create a region and pass it to the Map View
    MKCoordinateRegion region;
    region.center.latitude = self.coordinate.coordinate.latitude;
    region.center.longitude = self.coordinate.coordinate.longitude;
    region.span.latitudeDelta = .5;
    region.span.longitudeDelta = .5;
    
    [self.mapOutlet setRegion:region animated:YES];
    
}

-(void)plotLocationPin
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    double latitudeDouble = [self.locationToBeParsed.latitude doubleValue];
    double longitudeDouble = [self.locationToBeParsed.longitude doubleValue];
    point.coordinate = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble);
    point.title = self.locationToBeParsed.meetingName;
    point.subtitle = self.locationToBeParsed.locationName;
    [self.mapOutlet addAnnotation:point];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)add:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
