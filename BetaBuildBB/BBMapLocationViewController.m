//
//  BBMapLocationViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBMapLocationViewController.h"

@interface BBMapLocationViewController ()

@end

@implementation BBMapLocationViewController


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
    
    
    
    double latitudeDouble =[self.locationToBeParsed.latitude doubleValue];
    double longitudeDouble = [self.locationToBeParsed.longitude doubleValue];
    
    self.coordinate = [[CLLocation alloc]initWithLatitude:latitudeDouble longitude:longitudeDouble];
    
    [self updateMapView:self.coordinate];
    [self plotLocationPin];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)updateMapView:(CLLocation *)location {
    
    // create a region and pass it to the Map View
    MKCoordinateRegion region;
    region.center.latitude = self.coordinate.coordinate.latitude;
    region.center.longitude = self.coordinate.coordinate.longitude;
    region.span.latitudeDelta = .5;
    region.span.longitudeDelta = .5;
    
    [self.mapOutlet setRegion:region animated:YES];
    
}
-(void)plotLocationPin {
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    double latitudeDouble = [self.locationToBeParsed.latitude doubleValue];
    double longitudeDouble = [self.locationToBeParsed.longitude doubleValue];
    point.coordinate = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble);
    point.title = self.locationToBeParsed.meetingName;
    point.subtitle = self.locationToBeParsed.locationName;
    [self.mapOutlet addAnnotation:point];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end