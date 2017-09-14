//
//  WithinKMViewController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 3/17/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "WithinKMViewController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "NearByListController.h"
#import <MapKit/MapKit.h>

@interface WithinKMViewController ()
@property (weak, nonatomic) IBOutlet UIView *nearByOptions;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation WithinKMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    homeViewController* homeViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    [homeViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
    [navController setViewControllers: @[homeViewController] animated: YES];
    
    self.revealViewController.frontViewController = navController;
    
    
}

-(void)gotoViewController:(NSString*)placeType{
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    NearByListController* nearByListVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NearByListController"];
    nearByListVC.searcPlaceType = placeType;
    [self.navigationController pushViewController:nearByListVC animated:YES];
}

- (IBAction)fineNearByTapped:(id)sender {
    _nearByOptions.hidden = !_nearByOptions.hidden;
}

- (IBAction)restaurantTapped:(id)sender {
    [self gotoViewController:@"restaurant"];
}
- (IBAction)petroTapped:(id)sender {
    [self gotoViewController:@"gas_station"];
}
- (IBAction)atmTapped:(id)sender {
    [self gotoViewController:@"atm"];
}
- (IBAction)hospitalsTapped:(id)sender {
    [self gotoViewController:@"hospital"];
}

@end
