//
//  ResetPinController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 3/26/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "ResetPinController.h"
#import "AppUtils.h"

@interface ResetPinController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFldMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtFldEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPin;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPin;

@end

@implementation ResetPinController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heightPin.constant = -10;
    [self addTollBarWithKeyBoard];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}


-(void)addTollBarWithKeyBoard{
    UIToolbar *keyboardmyCustobBtnView = [[UIToolbar alloc] init];
    [keyboardmyCustobBtnView sizeToFit];
    UIBarButtonItem *myCustobBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(doneClicked:)];
    [keyboardmyCustobBtnView setItems:[NSArray arrayWithObjects:myCustobBtn, nil]];
    self.txtFldMobile.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldMobile.inputAccessoryView = keyboardmyCustobBtnView;
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)resetTapped:(id)sender {
    if(![_txtFldMobile.text length])
        [self showAlertWithTitle:@"Mobile" andMessage:@"Mobile required" andAction:NO];
    
    else if([_txtFldMobile.text length]>10 || [_txtFldMobile.text length]<10)
        [self showAlertWithTitle:@"Invalid" andMessage:@"Entered mobile is invalid" andAction:NO];
    
    else if(![_txtFldEmail.text length])
        [self showAlertWithTitle:@"Email" andMessage:@"Email required" andAction:NO];
    
    else if(![AppUtils isValidEmail:_txtFldEmail.text])
        [self showAlertWithTitle:@"Invalid" andMessage:@"Email Id is invalid" andAction:NO];
    
    else
        [self resetPin];
    
}

-(void)resetPin {
    if(_txtFldPin.hidden){
        if([self isMobileValid] && [self isEmailValid]){
            _heightPin.constant = 40;
            _txtFldPin.hidden = NO;
        }else{
            [self showAlertWithTitle:@"Invalid" andMessage:@"Invalid Details" andAction:NO];
        }
    }else{
        if(!([_txtFldPin.text length] == 4) )
            [self showAlertWithTitle:@"PIN" andMessage:@"Invalid Pin" andAction:NO];
        else{
            [AppUtils setValueInLocalDb:_txtFldPin.text forKey:@"userPin"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(BOOL) isMobileValid {
    return [[AppUtils getValueFromLocalDbForKey:@"userMobile"] isEqualToString:_txtFldMobile.text];
}

-(BOOL) isEmailValid {
    return [[AppUtils getValueFromLocalDbForKey:@"userEmail"] isEqualToString:_txtFldEmail.text];
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


#pragma mark - TEXTFIELD Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
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
