//
//  SelectIssueController.m
//  TollPlaza
//
//  Created by Comvision on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "SelectIssueController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "IssueEntryController.h"

@interface SelectIssueController ()

@end

@implementation SelectIssueController

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
    [self.navigationController popViewControllerAnimated:YES];

  }

- (IBAction)poorTapped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.typeofIssue = @"Poor Workmanship of Construction";
   
    [self.navigationController pushViewController:issueEntry animated:YES];
}

- (IBAction)tollTapped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.typeofIssue = @"Complain against Toll Plaza management";
    [self.navigationController pushViewController:issueEntry animated:YES];
}

- (IBAction)safetyTapped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.typeofIssue = @"Safety hazard during construction";
    [self.navigationController pushViewController:issueEntry animated:YES];
}

- (IBAction)fastagTapped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.typeofIssue = @"Complain against Fastag facility/Lane";
    [self.navigationController pushViewController:issueEntry animated:YES];
}

- (IBAction)potTapped:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    IssueEntryController* issueEntry = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IssueEntryController"];
    issueEntry.typeofIssue = @"Potholes and other maintenance issues";
    [self.navigationController pushViewController:issueEntry animated:YES];
}


@end
