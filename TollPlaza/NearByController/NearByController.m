//
//  NearByController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 3/13/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "NearByController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "NearByListController.h"
@interface NearByController ()

@end

@implementation NearByController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nearByTapped:(id)sender {
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
- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoViewController:(NSString*)placeType{
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    NearByListController* nearByListVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NearByListController"];
    nearByListVC.searcPlaceType = placeType;
       [self.navigationController pushViewController:nearByListVC animated:YES];
}

@end
