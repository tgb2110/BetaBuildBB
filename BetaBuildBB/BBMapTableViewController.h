//
//  BBMapTableViewController.h
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BBMeetupLocation.h"
#import "BBMeetupCell.h"

@interface BBMapTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleField;

@property (strong, nonatomic) IBOutlet MKMapView *mapOutlet;

@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSArray *meetupsArray;

@property (strong, nonatomic) BBMeetupLocation *locationToBeParsed;

@property (nonatomic) CLLocation *coordinate;

- (IBAction)add:(id)sender;

@end
