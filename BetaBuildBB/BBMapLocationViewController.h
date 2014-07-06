//
//  BBMapLocationViewController.h
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BBMeetupLocation.h"

@interface BBMapLocationViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapOutlet;
@property (strong, nonatomic) BBMeetupLocation *locationToBeParsed;
@property (nonatomic) CLLocation *coordinate;

@end
