//
//  homeViewController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 2/22/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "AppSinglton.h"
#import "UIViewController+MMDrawerController.h"

@interface homeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *callView;
@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCallPopUp)
                                                 name:@"CallSlected"
                                               object:nil];
    
   // [self newtap];
    
   // [[AppSinglton sharedManager] startLocationTracking];
    // Do any additional setup after loading the view.
    
    
}

-(void)showCallPopUp {
   
    [UIView transitionWithView:_callView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                         _callView.hidden=NO;
                    }
                    completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callCrossTaped:(id)sender {
    [UIView transitionWithView:_callView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _callView.hidden=YES;
                    }
                    completion:NULL];
}

- (IBAction)callViewOkTaped:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] || [[device model] isEqualToString:@"iPad"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:1033"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
        
    }
    [UIView transitionWithView:_callView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _callView.hidden=YES;
                    }
                    completion:NULL];

}

- (IBAction)menuTap:(id)sender {
    
    [self newtap];
    
    }

-(void)newtap
{
    
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
