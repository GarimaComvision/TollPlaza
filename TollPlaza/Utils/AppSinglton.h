//
//  AppSinglton.h
//  OutFit
//
//  Created by Ravi Rajan on 2/23/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface AppSinglton : NSObject{}
+ (id)sharedManager;
-(void)setLatitude :(NSString*)latitude andLongitude:(NSString*)longitude;
-(NSString*)getLatitude;
-(NSString*)getLoongitude;
- (void)startLocationTracking;
-(void)setVehiclesType:(NSArray*)vehiclesArr;
-(NSArray*)getVehiclesType;
-(void)setEnrouteTollInfoData : (NSArray*)tollInfoArr;

@end
