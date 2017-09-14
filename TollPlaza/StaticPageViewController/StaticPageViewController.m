//
//  StaticPageViewController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 3/12/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "StaticPageViewController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "Constant.h"
@interface StaticPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topHeading;
@property (weak, nonatomic) IBOutlet UILabel *centerHeading;
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation StaticPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden=YES;
    _topHeading.text=self.contentType;
    if([self.contentType isEqualToString:@"About Us"]){
        _centerHeading.text = @NHAI;
        _txtView.text = @ABOUT_US_CONTENT;
    }
    else{
        _centerHeading.text = @DISCLAIMER;
        _txtView.text = @DISCLAIMER_US_CONTENT;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
