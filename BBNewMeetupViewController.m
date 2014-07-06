//
//  BBNewMeetupViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBNewMeetupViewController.h"


@interface BBNewMeetupViewController () {
//CLLocationManager allows us to get our location
//Geocoder & placemark allow us to convert GPS coordinates into user-readable address
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;
}

@property (strong, nonatomic) IBOutlet UILabel *latitudeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *meetupName;
@property (weak, nonatomic) IBOutlet UITextField *locationName;


- (IBAction)getCurrentLocation:(id)sender;

@end

@implementation BBNewMeetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Instantiation of private instance variables
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)getCurrentLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    [self setupNewEvent];
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

- (void)createLocationObject:(CLLocation *)currentLocation
{
    NSNumber *latitudeLocation = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
    NSNumber *longitudeLocation = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
    NSString *meetingName = self.meetupName.text;
    NSString *locationName = self.locationName.text;
    
    BBMeetupLocation *newLocation = [[BBMeetupLocation alloc]
                                     initWithMeetingName:meetingName
                                     withLocationName:locationName
                                     withStartDate:[NSDate date]
                                     withEndDate:[[NSDate date] dateByAddingTimeInterval:60*60]
                                     withLatidue:latitudeLocation
                                     withLongitude:longitudeLocation];
    [BBMeetupLocation sendLocationToParse:newLocation];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    //Obtaining the location
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    //Setting the lat/long to the UILabels
    if (currentLocation != nil) {
        self.longitudeValueLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeValueLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [self createLocationObject:currentLocation];
    }
    
    //Stop LocationManager
    [locationManager stopUpdatingLocation];
    
    //Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.addressValueLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@", placemark.subThoroughfare, placemark.thoroughfare, placemark.postalCode, placemark.locality, placemark.administrativeArea, placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

-(void)setupNewEvent{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = self.meetupName.text;
        event.location = self.locationName.text;
        event.startDate = [NSDate date]; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
    }];
}

@end
