//
//  BBFutureMeetupViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBFutureMeetupViewController.h"
#import "BBMeetupLocation.h"

@interface BBFutureMeetupViewController () {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (strong, nonatomic) EKEvent *futureMeetup;

@end

@implementation BBFutureMeetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            self.futureMeetup  = [EKEvent eventWithEventStore:eventStore];
            
            EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            
            // set the addController's event store to the current event store.
            addController.eventStore = eventStore;
            addController.event = self.futureMeetup;
            
            // present EventsAddViewController as a modal view controller
            [self presentViewController:addController animated:YES completion:nil];
            
            addController.editViewDelegate = self;
            //[addController release];
            
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    
    
    switch (action)
    {
        case EKEventEditViewActionSaved:
            NSLog(@"Meetup scheduled");
            break;
        case EKEventEditViewActionCancelled:
            NSLog(@"Meetup canceled");
            break;
        case EKEventEditViewActionDeleted:
            NSLog(@"Meetup Deleted");
            break;
        default:
            break;
    }
    [self captureEventAndParse];
    [locationManager stopUpdatingLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)captureEventAndParse
{
    // SET PROPERTY CURRENT LOCATION TO CURRENT LOCATION
    
    NSString *futureMeetupName = self.futureMeetup.title;
    NSString *futureMeetupLocationName = self.futureMeetup.location;
    NSDate *futureMeetupStartDate = self.futureMeetup.startDate;
    NSDate *futureMeetupEndDate = self.futureMeetup.endDate;
    
    //  should take current lat long and save for use when creating meetupLocation
    
    NSNumber *meetingLatitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
    NSNumber *meetingLongitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
    
    BBMeetupLocation *futureMeetupLocation = [[BBMeetupLocation alloc]
                                              initWithUserPointer:[PFUser currentUser].objectId
                                              MeetingName:futureMeetupName
                                              withLocationName:futureMeetupLocationName
                                              withStartDate:futureMeetupStartDate
                                              withEndDate:futureMeetupEndDate
                                              withLatidue:meetingLatitude
                                              withLongitude:meetingLongitude];
    
    [BBMeetupLocation sendLocationToParse:futureMeetupLocation];
    
    NSLog(@"%@",self.futureMeetup);
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    //Error message
    NSLog(@"didFailWithError: %@", error);
    
    //Error alertView
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    //Stop LocationManager
    [locationManager stopUpdatingLocation];
}


@end

