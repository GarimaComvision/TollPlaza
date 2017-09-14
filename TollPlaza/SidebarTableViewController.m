//
//  SidebarTableViewController.m

//
//  Created by Ravi Rajan on 7/25/16.
//  Copyright © 2016 dmondo. All rights reserved.
//


#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "NearByListController.h"
#import "NearByController.h"
#import "ViewController.h"
#import "RegisterProfileController.h"
#import "StaticPageViewController.h"
#import "homeViewController.h"
#import "SideTableViewCell.h"
#import "WithinKMViewController.h"
#import "AppUtils.h"



@interface SidebarTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * menuItems;
    NSArray * menuImages;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserMobile;
@end

@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblUserName setText:[AppUtils getValueFromLocalDbForKey:@"userName"]];
    [self.lblUserMobile setText:[AppUtils getValueFromLocalDbForKey:@"userMobile"]];
    
     menuItems = @[@"Toll Plaza with in 100km", @"Nearby", @"Toll Plazas enroute",@"Report an Issue",@"Report Summary", @"1033 incident Management HelpLine", @"Profile", @"Disclaimer", @"About Us"];
     menuImages =   @[@"toll_100Km",@"nearBy",@"toll_enroute",@"reportissue",@"reportsummary",@"help_phone",@"profile",@"disclaimer",@"about_us"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
//    menuItems = @[@"Home"];
//    menuImages =   @[@"Home1.png",@"Portfolio1.png",@"Services1.png",@"Fund Picks1.png",@"Investor Education1.png",@"Tools1.png",@"Top Scheme1.png",@"Gallery1.png",@"About Us1.png",@"Facebook1.png",@"Locate Us1.png",@"Exit1.png"];
    
    
    //[_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return menuItems.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"slideOptionCell";
    SideTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.mainView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.mainView.layer.borderWidth = 1.0f;
    cell.cellLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.cellImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuImages objectAtIndex:indexPath.row]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        
        
        SWRevealViewController *revealViewController = self.revealViewController;
        
        ViewController *selectedViewController;
        
        
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
        
    }
    if(indexPath.row == 1){
        
        SWRevealViewController *revealViewController = self.revealViewController;
        
        UIViewController *selectedViewController;
        
    
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NearByController"];
        
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
    }

    
    if(indexPath.row == 2){
        
        
        SWRevealViewController *revealViewController = self.revealViewController;
        
        ViewController *selectedViewController;
        
        
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
        
        selectedViewController.mapType = @"Enroute";
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
        
    }
    if(indexPath.row == 3){
        
        SWRevealViewController *revealViewController = self.revealViewController;
 
        homeViewController *selectedViewController;
        selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"homeViewController"];
        selectedViewController.stringType=@"call";
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];

      
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
        
    }

    
    
    
    
    if(indexPath.row == 4 ){
        
       
        SWRevealViewController *revealViewController = self.revealViewController;
        RegisterProfileController *selectedViewController;
                    selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RegisterProfileController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        selectedViewController.profileMode = @"Edit";
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        
    }

    if(indexPath.row == 5  ||indexPath.row == 6){
        
        SWRevealViewController *revealViewController = self.revealViewController;
        
        StaticPageViewController *selectedViewController;
                  selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"StaticPageViewController"];
        if (indexPath.row==5) {
            selectedViewController.contentType=@"Disclaimer";
        }
       else if (indexPath.row==6) {
            selectedViewController.contentType=@"About Us";
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        [selectedViewController.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
        [navController setViewControllers: @[selectedViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        
        [self.navigationController pushViewController:selectedViewController animated:YES];
        if ( revealViewController )
        {
            [revealViewController revealToggleEnd];
        }
        return;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{                return 56.0;
}



@end
