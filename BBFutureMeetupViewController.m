//
//  BBFutureMeetupViewController.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBFutureMeetupViewController.h"
#import "BBMeetupLocation.h"

@interface BBFutureMeetupViewController ()

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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)captureEventAndParse
{
    
    NSString *futureMeetupName = self.futureMeetup.title;
    NSString *futureMeetupLocationName = self.futureMeetup.location;
    NSDate *futureMeetupStartDate = self.futureMeetup.startDate;
    NSDate *futureMeetupEndDate = self.futureMeetup.endDate;
    
    //  should take current lat long and save for use when creating meetupLocation
    
    BBMeetupLocation *futureMeetupLocation = [[BBMeetupLocation alloc]
                                              initWithMeetingName:futureMeetupName
                                              withLocationName:futureMeetupLocationName
                                              withStartDate:futureMeetupStartDate
                                              withEndDate:futureMeetupEndDate
                                              withLatidue:@0
                                              withLongitude:@0];
    
    [BBMeetupLocation sendLocationToParse:futureMeetupLocation];
    
    NSLog(@"%@",self.futureMeetup);
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
