//
//  EnterPinViewController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 12/24/16.
//  Copyright © 2016 Ravi Rajan. All rights reserved.
//

#import "EnterPinViewController.h"
#import "AppDelegate.h"
#import "RegisterProfileController.h"
#import "ResetPinController.h"
#import "homeViewController.h"
#import "AppUtils.h"
#import "MMDrawerController.h"
#import "SideMenuViewController.h"

@interface EnterPinViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFldPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPin4;
@property (nonatomic,retain)homeViewController *vcHomeGM;
@property (nonatomic,retain) SideMenuViewController *leftController;
@property (nonatomic,retain)UINavigationController *navController;

@end

@implementation EnterPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.txtFldPin1.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldPin1.inputAccessoryView = keyboardmyCustobBtnView;
    
    self.txtFldPin2.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldPin2.inputAccessoryView = keyboardmyCustobBtnView;
    
    
    self.txtFldPin3.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldPin3.inputAccessoryView = keyboardmyCustobBtnView;
    
    
    self.txtFldPin4.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldPin4.inputAccessoryView = keyboardmyCustobBtnView;
}

- (IBAction)resetPinClicked:(id)sender {
    UIStoryboard*  mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ResetPinController *resetPinVC =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"ResetPinController"];
    
    [self presentViewController:resetPinVC animated:YES completion:nil];
}

- (IBAction)registerClicked:(id)sender {
    UIStoryboard*  mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterProfileController *registerVC =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"RegisterProfileController"];
    
    [self presentViewController:registerVC animated:YES completion:nil];
}




#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Begin End");
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    
    if(theTextField == _txtFldPin1){
        if([string length] ==1){
            _txtFldPin1.text = string;
            [_txtFldPin1 resignFirstResponder];
            [_txtFldPin2 becomeFirstResponder];
            return NO;
        }else{
            return YES;
        }
        
    }else
        if(theTextField == _txtFldPin2){
            if([string length] ==1){
                _txtFldPin2.text = string;
                [_txtFldPin2 resignFirstResponder];
                [_txtFldPin3 becomeFirstResponder];
                return NO;
            }else{
                return YES;
            }
        }
        else
            
            
            if(theTextField == _txtFldPin3){
                if([string length] ==1){
                    _txtFldPin3.text = string;
                    [_txtFldPin3 resignFirstResponder];
                    [_txtFldPin4 becomeFirstResponder];
                    return NO;
                }else{
                    return YES;
                }
            }
            else if(theTextField == _txtFldPin4){
                if([string length] ==1){
                    _txtFldPin4.text = string;
                    [_txtFldPin4 resignFirstResponder];
                    [self validatePin];
                    return NO;
                }else{
                    return YES;
                }
            }else{
                
            }
    return YES;
}


-(void)validatePin {
    NSString *pin = [NSString stringWithFormat:@"%@%@%@%@",_txtFldPin1.text,_txtFldPin2.text,_txtFldPin3.text,_txtFldPin4.text];
    if([[AppUtils getValueFromLocalDbForKey:@"userPin"] isEqualToString:pin]){
        [self gotoMainView];
    }else{
        [self showAlertWithTitle:@"Invalid" andMessage:@"Incorrect Pin..." andAction:NO];
    }
   
}

-(void)gotoMainView {
    //Setting Home Screen as a initail view Controller
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.leftController = [mystoryboard instantiateViewControllerWithIdentifier:@"sideMenu"];
    self.vcHomeGM =[mystoryboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    MMDrawerController *controller = [[MMDrawerController alloc]initWithCenterViewController:self.vcHomeGM leftDrawerViewController:self.leftController];
    //[controller setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width-120];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    NSString* strheight = [NSString stringWithFormat:@"%0.0f",screenHeight];
    if ([strheight isEqualToString:@"736"]) {
        [controller setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width-200];
    }
    else{
        [controller setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width-120];
    }
    
    [controller setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [controller setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.navigationController pushViewController:controller animated:YES];
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

@end
