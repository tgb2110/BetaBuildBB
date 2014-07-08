//
//  BBAllOneMapViewController.h
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/8/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BBMeetupLocation.h"

@interface BBAllOneMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapOutlet;
- (IBAction)userFilter:(id)sender;

@property (strong, nonatomic) NSArray *meetupsArray;
@property (strong, nonatomic) NSMutableArray *BBMeetupLocationObjects;

@end
