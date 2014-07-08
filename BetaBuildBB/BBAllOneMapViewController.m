//
//  BBAllOneMapViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/8/14.
//
//

#import "BBAllOneMapViewController.h"
#import <Parse/Parse.h>

@interface BBAllOneMapViewController ()

@end

@implementation BBAllOneMapViewController

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
    
    PFQuery *query = [PFQuery queryWithClassName:@"BBMeetupLocation"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _meetupsArray = objects;
        NSLog(@"%@", self.meetupsArray);
        self.BBMeetupLocationObjects = [[NSMutableArray alloc]init];
        for (PFObject *currentObject in self.meetupsArray) {
            
            BBMeetupLocation *locationTobeDisplayed = [[BBMeetupLocation alloc]
                                                       initWithUserPointer:currentObject[@"userPointer"]
                                                       MeetingName:currentObject[@"meetingName"]
                                                       withLocationName:currentObject[@"locationName"]
                                                       withStartDate:currentObject[@"startDate"]
                                                       withEndDate:currentObject[@"endDate"]
                                                       withLatidue:currentObject[@"latitudeValue"]
                                                       withLongitude:currentObject[@"longitudeValue"]];
            
            [self.BBMeetupLocationObjects addObject:locationTobeDisplayed];
        }
        [self plotAllPointsInArray:self.BBMeetupLocationObjects];
    }];
}

- (void)plotAllPointsInArray:(NSArray *)BBMeetupLocations{
    for (BBMeetupLocation *singleLocation in BBMeetupLocations) {
        [self plotLocationPin:singleLocation];
    }
}

-(void)plotLocationPin:(BBMeetupLocation *)meetUp
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    double latitudeDouble = [meetUp.latitude doubleValue];
    double longitudeDouble = [meetUp.longitude doubleValue];
    point.coordinate = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble);
    point.title = meetUp.userPointer;
    point.subtitle = meetUp.locationName;
    [self.mapOutlet addAnnotation:point];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userFilter:(id)sender
{
    
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *filterByUserID =
    [NSPredicate predicateWithFormat:@"userPointer == %@", currentUser.objectId];
    NSArray *onlyUserMeetUps = [self.BBMeetupLocationObjects filteredArrayUsingPredicate:filterByUserID];
    [self.mapOutlet removeAnnotations:self.mapOutlet.annotations];
    [self plotAllPointsInArray:onlyUserMeetUps];
}
@end
