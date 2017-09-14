//
//  ViewController.m
//  SwiftTest
//
//  Created by canvasm on 2/20/17.
//  Copyright © 2017 canvasm. All rights reserved.
//

#import "NearByListController.h"
#import "NearByPlaceCell.h"
#import <MapKit/MapKit.h>
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "AppSinglton.h"
#import "SVProgressHUD.h"
#define MIN_HEIGHT     100

@interface NearByListController (){
    NSArray *places;
    NSString *currentContactNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewNearByOptions;
@property (weak, nonatomic) IBOutlet UILabel *contactTextLabel;
@property (weak, nonatomic) IBOutlet UIView *contactPopUpView;

- (IBAction)callToCurrentNumber:(id)sender;
- (IBAction)hideCallPopUp:(id)sender;

@end

@implementation NearByListController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden=YES;
    places = [[NSArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadSearch];
   
}

-(void) loadSearch {
     [self queryGooglePlacesForType:_searcPlaceType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return places.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 30;
    CGFloat width = tableView.frame.size.width - 95;
    NSDictionary *dict = [places objectAtIndex:indexPath.row];
    height = height + [self findHeightForText:[dict valueForKey:@"name"] havingWidth:width andFont:[UIFont systemFontOfSize:17.0]];
    
    height = height + [self findHeightForText:[dict valueForKey:@"vicinity"] havingWidth:width andFont:[UIFont systemFontOfSize:17.0]];
    
    return (height > MIN_HEIGHT) ? height : MIN_HEIGHT;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NearByPlaceCell";
    NearByPlaceCell *cell = (NearByPlaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[NearByPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    NSDictionary *dict = [places objectAtIndex:indexPath.row];
    cell.lblTitle.text =[dict valueForKey:@"name"];
    cell.lblAddress.text =[dict valueForKey:@"vicinity"];
    cell.btnCall.tag = indexPath.row;
    [cell.btnCall addTarget:self action:@selector(contactBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)contactBtnTapped : (UIButton*)clickedBtn {
    [SVProgressHUD showWithStatus:@"Getting Data..." maskType:SVProgressHUDMaskTypeGradient];
    NSInteger clickedIndex = clickedBtn.tag;
     NSDictionary *dict = [places objectAtIndex:clickedIndex];
    NSString* place_id = [dict valueForKey:@"place_id"];

    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyCO4ggSITaVEVBpFF3frbkPeTHKsJ2vTXo", place_id];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", url);
    
    //Formulate the string as a URL object.
    NSURL *placeDetailsRequest = [NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    
    NSData* data = [NSData dataWithContentsOfURL: placeDetailsRequest];
    // dispatch_sync(dispatch_get_main_queue(), ^{
    [self fetchedPlaceData:data];
    [SVProgressHUD dismiss];


    
}




- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return size.height;;
}

- (IBAction)fineNearByTapped:(id)sender {
      _viewNearByOptions.hidden = !_viewNearByOptions.hidden;
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)petroPumpClicked:(id)sender {
    //fuel
    if([_searcPlaceType isEqualToString:@"gas_station"])
        return;
    _searcPlaceType = @"gas_station";
    [self loadSearch];
    
}
- (IBAction)hospitalsClicked:(id)sender {
    //hospital
    if([_searcPlaceType isEqualToString:@"hospital"])
        return;
    _searcPlaceType = @"hospital";
    [self loadSearch];
}
- (IBAction)restaurantsClicked:(id)sender {
    //restaurant
    if([_searcPlaceType isEqualToString:@"restaurant"])
        return;
    _searcPlaceType = @"restaurant";
    [self loadSearch];
}
- (IBAction)atmTapped:(id)sender {
    //atm
    if([_searcPlaceType isEqualToString:@"atm"])
        return;
    _searcPlaceType = @"atm";
    [self loadSearch];
}


#pragma mark - getDatta

-(void)queryGooglePlacesForType: (NSString *)placeType
{
    //Build the url string to send to Google
    [SVProgressHUD showWithStatus:@"Getting Data..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *currentLatitude = [[AppSinglton sharedManager] getLatitude];
    NSString *currentLongitude = [[AppSinglton sharedManager] getLoongitude];
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&types=%@&rankby=distance&key=AIzaSyCO4ggSITaVEVBpFF3frbkPeTHKsJ2vTXo", currentLatitude, currentLongitude, placeType];
    
//     NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=28.579194, 77.059175&types=%@&rankby=distance&key=AIzaSyCO4ggSITaVEVBpFF3frbkPeTHKsJ2vTXo", placeType];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];     // Retrieve the results of the URL.
    
    NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
    // dispatch_sync(dispatch_get_main_queue(), ^{
    [self fetchedData:data];
    [SVProgressHUD dismiss];
    // });
}

-(void)showContactWithNumber: (NSString*)contactNumber {
    if(!contactNumber){
        [self showAlertWithTitle:@"Not found" andMessage:@"Contact number not available." andAction:NO];
        return;
    }
    [UIView transitionWithView:_contactPopUpView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _contactPopUpView.hidden=NO;
                    }
                    completion:NULL];
    _contactTextLabel.text = [NSString stringWithFormat:@"Are you sure to call %@?", contactNumber];
    currentContactNumber = contactNumber;
    
}

-(void)fetchedPlaceData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    [self showContactWithNumber:[[json objectForKey:@"result"] objectForKey : @"formatted_phone_number"]];
   
    //Write out the data to the console.
    NSLog(@"Google Data: %@", json);
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    places = [json objectForKey:@"results"];
    [self.tblView reloadData];
    [self addPinsOnMap];
    //Write out the data to the console.
    NSLog(@"Google Data: %@", json);
}

-(void)addPinsOnMap {
    if([places count]<1)
        return;
    //mapView
    for (int i=0; i<[places count]; i++)
    {
        CLLocationCoordinate2D theCoordinate1;
        NSDictionary *placeInfoDict = [places objectAtIndex:i];
        //cell.lblTitle.text =[dict valueForKey:@"name"];
       // cell.lblAddress.text =[dict valueForKey:@"vicinity"];
        
       theCoordinate1.latitude  = [[[[placeInfoDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        theCoordinate1.longitude = [[[[placeInfoDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        
         MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = theCoordinate1;
        annotationPoint.title      = [placeInfoDict valueForKey:@"name"];
        [_mapView addAnnotation:annotationPoint];
        
    }
    CLLocationCoordinate2D userLocation;
    userLocation.latitude  = [[[AppSinglton sharedManager] getLatitude] doubleValue];
    userLocation.longitude = [[[AppSinglton sharedManager] getLoongitude] doubleValue];
    MKCoordinateRegion mapRegion;
    mapRegion.center = userLocation;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    //Set the region of your mapview so the user location is in center and update
    [self.mapView setRegion:mapRegion];
}


- (IBAction)callToCurrentNumber:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] || [[device model] isEqualToString:@"iPad"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", currentContactNumber]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
        
    }
    [UIView transitionWithView:_contactPopUpView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _contactPopUpView.hidden=YES;
                    }
                    completion:NULL];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andAction:(BOOL)actionNeeded {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             if(actionNeeded){
                             }
                         }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)hideCallPopUp:(id)sender {
    [UIView transitionWithView:_contactPopUpView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _contactPopUpView.hidden=YES;
                    }
                    completion:NULL];
}
@end
