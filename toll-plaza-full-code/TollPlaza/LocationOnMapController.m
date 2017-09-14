//
//  LocationOnMapController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "LocationOnMapController.h"
#import "IssueEntryController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppSinglton.h"
#import "MVPlaceSearchTextField.h"

@interface LocationOnMapController ()<PlaceSearchTextFieldDelegate,UITextFieldDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *newlocation;

@end

@implementation LocationOnMapController

CLLocationCoordinate2D coordinate2={0,0};

GMSMarker *current;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    [self setPreferenceForView];
    _newlocation.placeSearchDelegate = self;
    _mapview.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate1
{
    current.map.clear;
    
    coordinate2 = coordinate1;
    
    GMSMarker *london = [GMSMarker markerWithPosition:coordinate2];
    //london.
    london.title = @"Custom Location";
    london.icon = [UIImage imageNamed:@"marker"];
    london.map = _mapview;
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate2.latitude
                                                            longitude:coordinate2.longitude
                                                                 zoom:13];
    [_mapview setCamera:camera];
    _mapview.myLocationEnabled = YES;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinate2.latitude, coordinate2.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:",response);
        GMSAddress* addressObj =response.results[0];
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            NSString *addr = @"";
            addr= [NSString stringWithFormat:@"%@%@%@",addressObj.lines[0],@",",addressObj.lines[1]];
            
            [self.newlocation setText: addr ];
        }
        
    }];

    current = london;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
    
        
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     [self.navigationController popViewControllerAnimated:YES];
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.customlocation = coordinate2;
    issueEntry.typeofIssue = _typeofIssue1;
    
    [self.navigationController pushViewController:issueEntry animated:YES];
    
    
    
}

- (IBAction)searchTapped:(id)sender {
    
   
//   // CLLocationCoordinate2D center=[self getLocationFromAddressString:_newlocation.];
//    
//    GMSMarker *london = [GMSMarker markerWithPosition:center];
//    //london.
//    london.title = @"Custom Location";
//    london.icon = [UIImage imageNamed:@"marker"];
//    london.map = _mapview;
//    
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:center.latitude
//                                                            longitude:center.longitude
//                                                                 zoom:17];
//    [_mapview setCamera:camera];
//    _mapview.myLocationEnabled = YES;
    
}

//-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
//    double latitude = 0, longitude = 0;
//    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//    if (result) {
//        NSScanner *scanner = [NSScanner scannerWithString:result];
//        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
//            [scanner scanDouble:&latitude];
//            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
//                [scanner scanDouble:&longitude];
//            }
//        }
//    }
//    CLLocationCoordinate2D center;
//    center.latitude=latitude;
//    center.longitude = longitude;
//    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
//    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
//    return center;
//    
//}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    //responseDict.coordinate
    current.map.clear;
       coordinate2   = responseDict.coordinate;
        
    GMSMarker *london = [GMSMarker markerWithPosition:coordinate2];
    //london.
    london.title = @"Custom Location";
    london.icon = [UIImage imageNamed:@"marker"];
    london.map = _mapview;
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate2.latitude
                                                            longitude:coordinate2.longitude
                                                                 zoom:13];
    [_mapview setCamera:camera];
    _mapview.myLocationEnabled = YES;

    current = london;

}


-(void)setPreferenceForView {
    
//    double currentLatitude = [[[AppSinglton sharedManager] getLatitude] doubleValue];
//    double currentLongitude = [[[AppSinglton sharedManager] getLoongitude] doubleValue];
    self.mapview.delegate=self;
    current.map.clear;
    double latitude = _customlocation1.latitude;
    double longitude = _customlocation1.longitude;
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    GMSMarker *london = [GMSMarker markerWithPosition:coordinate];
    //london.
    london.title = @"Current Location";
    london.icon = [UIImage imageNamed:@"marker"];
    london.map = _mapview;

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:13];
    [_mapview setCamera:camera];
    _mapview.myLocationEnabled = YES;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude, longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:",response);
        GMSAddress* addressObj =response.results[0];
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            NSString *addr = @"";
            addr= [NSString stringWithFormat:@"%@%@%@",addressObj.lines[0],@",",addressObj.lines[1]];
            
            [self.newlocation setText: addr ];
        }
        
    }];

    current = london;
    coordinate=_customlocation1;

}


@end
