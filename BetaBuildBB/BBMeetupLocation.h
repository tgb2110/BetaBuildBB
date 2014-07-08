//
//  BBMeetupLocation.h
//  BetaBuildBB
//
//  Created by Troy Barrett on 7/5/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BBMeetupLocation : NSObject

@property (strong, nonatomic) NSString *userPointer;
@property (strong, nonatomic) NSString *meetingName;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

-(instancetype)initWithUserPointer:(NSString *)userPointer
                       MeetingName:(NSString *)meetingName
                  withLocationName:(NSString *)locationName
                     withStartDate:(NSDate *)startDate
                       withEndDate:(NSDate *)endDate
                       withLatidue:(NSNumber *)latitude
                     withLongitude:(NSNumber *)longitude;


+(void)sendLocationToParse:(BBMeetupLocation *)newLocation;

@end
