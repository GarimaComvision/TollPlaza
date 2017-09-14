//
//  TestController.m
//  TollPlaza
//
//  Created by Comvision on 28/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <TestController.h>

@interface TestController()
@property (weak, nonatomic) IBOutlet UITextField *inputTest;

@end

@implementation TestController
-(void) viewDidLoad   {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden =YES;
    
    [self.inputTest setText:@"Test hai"];

}

//-(void)CHECKAccess : (NSString) test
//{  [self.inputTest setText:@"Test hai"];
//
//
//}

-(IBAction)TestbuttonClick:(id)sender
{
[self.inputTest setText:@"CLicked"];
}

@end
