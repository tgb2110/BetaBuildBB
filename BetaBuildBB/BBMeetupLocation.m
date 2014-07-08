//
//  BBMeetupLocation.m
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import "BBMeetupLocation.h"

@implementation BBMeetupLocation

- (instancetype)init
{
    return [self initWithUserPointer:@""
                         MeetingName:@""
                    withLocationName:@""
                       withStartDate:[NSDate date]
                         withEndDate:[NSDate date]
                         withLatidue:@0
                       withLongitude:@0];
}

-(instancetype)initWithUserPointer:(NSString *)userPointer
                       MeetingName:(NSString *)meetingName
                  withLocationName:(NSString *)locationName
                     withStartDate:(NSDate *)startDate
                       withEndDate:(NSDate *)endDate
                       withLatidue:(NSNumber *)latitude
                     withLongitude:(NSNumber *)longitude {
    self = [super init];
    if (self) {
        _userPointer = userPointer;
        _meetingName = meetingName;
        _locationName = locationName;
        _startDate = startDate;
        _endDate = endDate;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
    
}

+(void)sendLocationToParse:(BBMeetupLocation *)newLocation
{
    PFObject *locationToStore = [PFObject objectWithClassName:@"BBMeetupLocation"];
    PFUser *currentUser = [PFUser currentUser];
    
    
    locationToStore[@"userPointer"] = currentUser.objectId;
    locationToStore[@"meetingName"] = newLocation.meetingName ;
    locationToStore[@"locationName"] = newLocation.locationName;
    locationToStore[@"startDate"] = newLocation.startDate;
    locationToStore[@"endDate"] = newLocation.endDate;
    locationToStore[@"longitudeValue"] = newLocation.longitude;
    locationToStore[@"latitudeValue"] = newLocation.latitude;
    locationToStore[@"userPointer"] = newLocation.userPointer;
    
    [locationToStore saveInBackground];
    
}


@end
