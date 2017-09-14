//
//  AppSinglton.m
//  OutFit
//
//  Created by Ravi Rajan on 2/23/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "AppSinglton.h"
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
#define DISTANCE_FILTER  500.0

@interface AppSinglton () <CLLocationManagerDelegate>{
    NSString *userLatitude;
    NSString *userLongtude;
    BOOL isLocationUpdates;
    CLLocation *currentLocation;
    NSArray *vehiclesArray;
    NSMutableArray *enrouteTollsInfo;
}


@property (nonatomic,retain) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastTimestamp;

@end

@implementation AppSinglton

+ (id)sharedManager {
    static AppSinglton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        AppSinglton *instance = sharedMyManager;
        instance.locationManager = [CLLocationManager new];
        instance.locationManager.delegate = instance;
        instance.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // you can use kCLLocationAccuracyHundredMeters to get better battery life
        instance.locationManager.distanceFilter = 50;
        instance.locationManager.pausesLocationUpdatesAutomatically = NO; // this is important
        if ([instance.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            [instance.locationManager setAllowsBackgroundLocationUpdates:YES];
        }

        //_userMainWardoCategory :[[NSMutableArray alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        enrouteTollsInfo = [[NSMutableArray alloc] init];
       // someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}


-(void)setLatitude :(NSString*)latitude andLongitude:(NSString*)longitude{
    userLatitude = latitude;
    userLongtude = longitude;
}
-(NSString*)getLatitude
{
    return userLatitude;
}
-(NSString*)getLoongitude {
     return userLongtude;
}


- (void)startLocationTracking {
    [self startLocationUpdates];
//    if([CLLocationManager locationServicesEnabled]){
//        
//        NSLog(@"Location Services Enabled");
//        
//        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Permission Denied"
//                                                              message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Cancel"
//                                                    otherButtonTitles:@"Settings",nil];
//            [alert show];
//            return;
//        }
//        //[self.locationManager startUpdatingLocation];
//        
//        
//        
//    }else{
//        UIAlertView*   alert = [[UIAlertView alloc] initWithTitle:@"Location not detected"
//                                                          message:@"Location services are turned off on your device. Please go to settings and enable location services to use this feature or manually select a location."
//                                                         delegate:self
//                                                cancelButtonTitle:@"Cancel"
//                                                otherButtonTitles:@"Settings",nil];
//        [alert show];
//    }
    
    
    
}


- (void)startLocationUpdates
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are disabled in settings.");
    }
    else
    {
        // for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        // for iOS 9
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = locations.lastObject;
    NSLog(@"Current location: %@ %@", @(mostRecentLocation.coordinate.latitude), @(mostRecentLocation.coordinate.longitude));
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
    
    if (!self.lastTimestamp || interval >= 60)
    {
        self.lastTimestamp = now;
        isLocationUpdates=true;
        currentLocation = mostRecentLocation;
        NSString *currentLatitude = [NSString stringWithFormat:@"%f",mostRecentLocation.coordinate.latitude];
        NSString *currentLongitude = [NSString stringWithFormat:@"%f",mostRecentLocation.coordinate.longitude];
        [self setLatitude:currentLatitude andLongitude:currentLongitude];
       // [self.locationManager stopUpdatingLocation];
        [self calculateTollDistanceFromCurrentLocation];
        NSLog(@"Sending current location to web service.");
    }
}

- (void)handleUIApplicationDidEnterBackgroundNotification:(NSNotification *)note
{
    NSLog(@"%f",(self.locationManager.location.coordinate.latitude));
    [self switchToBackgroundMode:YES];
    
}

- (void)handleUIApplicationWillEnterForegroundNotification :(NSNotification *)note
{
    [self switchToBackgroundMode:NO];
    
}

// called when the app is moved to the background (user presses the home button) or to the foreground
//
- (void)switchToBackgroundMode:(BOOL)background
{
    [self.locationManager startUpdatingLocation];
}


-(void)calculateTollDistanceFromCurrentLocation {
    if(enrouteTollsInfo.count <1){
       // [self.locationManager startUpdatingLocation];
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc] init];
    BOOL isTollFound = NO;
    for(NSDictionary *tollInfo in enrouteTollsInfo){
        
        NSString *strCoordinate = tollInfo[@"TollLocation"];
        strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // convert string into actual latitude and longitude values
        NSArray *components = [strCoordinate componentsSeparatedByString:@","];
        
        double latitude = [components[0] doubleValue];
        double longitude = [components[1] doubleValue];

        
        CLLocation *preferedLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [currentLocation distanceFromLocation:preferedLocation];
        if(distance <= DISTANCE_FILTER){
            dict = tollInfo;
            isTollFound = YES;
            break;
            //set Alert
        }
    }
    if(isTollFound){
        [enrouteTollsInfo removeObject:dict];
        [self getTollMessageForID: [[dict objectForKey:@"TollId"] integerValue]];
    }
    //[self.locationManager startUpdatingLocation];
}

-(void)setLocalAlertWithMessage:(NSString*)msg{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = msg;
    //localNotification.soundName = sound;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)getTollMessageForID : (NSInteger)tollID{
    NSDictionary* jsonInputParms=[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"sfdg6565tyfgfgfgsad", @"SessionId",
                                  [NSNumber numberWithInteger:tollID], @"TollId",
                                  nil];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:@"http://nhtis.org/IOS/api/ver1/KsLDh" parameters:jsonInputParms progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        {
//            AlertMessage = "Welcome To Bhagwada Toll.";
//        }
        [SVProgressHUD dismiss];
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            [self showAlertWithMessage:[responseObject objectForKey:@"AlertMessage"] andTitle:@"ALERT"];
            //App is in foreground. Act on it.
        }else{
            
            [self setLocalAlertWithMessage:[responseObject objectForKey:@"AlertMessage"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
    }];
    
    
}



-(void)showAlertWithMessage:(NSString*)message andTitle:(NSString*)title{
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
      
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
}



-(void)setVehiclesType:(NSArray*)vehiclesArr{
    vehiclesArray = vehiclesArr;
    
}
-(NSArray*)getVehiclesType{
    return vehiclesArray;
}


-(void)setEnrouteTollInfoData : (NSArray*)tollInfoArr{
    enrouteTollsInfo = [tollInfoArr mutableCopy];
}
@end
