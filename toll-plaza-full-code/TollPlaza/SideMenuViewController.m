//
//  SideMenuViewController.m
//  LPL
//
//  Created by Devendra Singh on 18/03/16.
//  Copyright © 2016 Devendra Singh. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuListCell.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
#import "AppUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "UIViewController+MMDrawerController.h"

#import "NearByListController.h"
#import "NearByController.h"
#import "RegisterProfileController.h"
#import "StaticPageViewController.h"
#import "homeViewController.h"
#import "SelectIssueController.h"
#import "ReportSummaryController.h"


@interface SideMenuViewController () <UIAlertViewDelegate>
{
    NSArray *arrySideElement;
    NSArray *arrayImagesSideElement;
    NSArray *arryStoryBoardIds;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConst;
@property (weak, nonatomic) IBOutlet UITableView *tblCategoryList;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserPhone;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblUserName setText:[AppUtils getValueFromLocalDbForKey:@"userName"]];
    [self.lblUserPhone setText:[AppUtils getValueFromLocalDbForKey:@"userMobile"]];
    // Do any additional setup after loading the view.
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    arrySideElement = @[@"Toll Plaza with in 100km", @"Nearby", @"Toll Plazas enroute",@"Report an Issue",@"Report Summary", @"1033 incident Management HelpLine", @"Profile", @"Disclaimer", @"About Us"];
        
        arrayImagesSideElement =@[@"toll_100Km",@"nearBy",@"toll_enroute",@"reportissue",@"reportsummary",@"help_phone",@"profile",@"disclaimer",@"about_us"];
            arryStoryBoardIds = [NSArray arrayWithObjects:@"MyOrders",@"MyReportsHome",@"SelectAddress",@"MyCart",@"Call",@"FeedbackPage",@"SubmitaBug", @"Share", @"Rate Us", @"BlogList", @"OffersList", @"AccountDetails", @"AboutUs", @"LogOut", nil];
      
    
    [self.tblCategoryList reloadData];
    //initData
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma maark - tableview delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
    //return [self.homeScreenData.categoriesShownInHomePage count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.arrCategories count];
    return [arrySideElement count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SideMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuList"];    
    [cell.lblCatName setText:[NSString stringWithFormat:@"%@",[arrySideElement objectAtIndex:indexPath.row]]];
    [cell.imgViewCategory setImage:[UIImage imageNamed:[arrayImagesSideElement objectAtIndex:indexPath.row]]];
    cell.backgroundColor = [UIColor clearColor];
    cell.mainView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.mainView.layer.borderWidth = 1.0f;
    
    return cell;
    
}
// 196,62,35

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == 2){
        ViewController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
        if(indexPath.row == 2)
            selectedViewController.mapType = @"Enroute";
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
        
    }
    if(indexPath.row == 1){
        NearByController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NearByController"];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
        
    }
    
    
    if(indexPath.row == 3){
        SelectIssueController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SelectIssueController"];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
    }
    
    if(indexPath.row == 5){
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CallSlected"
                                                                object:nil];
        }];
        
    }
    
    if(indexPath.row == 4){
        ReportSummaryController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ReportSummaryController"];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
        
    }
    
    if(indexPath.row == 6){
        RegisterProfileController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RegisterProfileController"];
        selectedViewController.profileMode = @"Edit";
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
        
    }
    
    if(indexPath.row == 7  ||indexPath.row == 8){
        StaticPageViewController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"StaticPageViewController"];
        if (indexPath.row==7) {
            selectedViewController.contentType=@"Disclaimer";
        }
        else if (indexPath.row==8) {
            selectedViewController.contentType=@"About Us";
        }
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController pushViewController:selectedViewController animated:YES];
        
    }
    
}



@end
