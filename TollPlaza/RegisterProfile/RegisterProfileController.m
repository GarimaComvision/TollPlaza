//
//  RegisterProfileController.m
//  TollPlaza
//
//  Created by Ravi Rajan on 3/12/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "RegisterProfileController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "XMLReader.h"
#import "AppUtils.h"
#import "AppSinglton.h"
#import <AFNetworking/AFNetworking.h>
//#import "SVProgressHUD.h"

@interface RegisterProfileController (){
    NSArray *vehicalArr;
    NSArray *responseObj;
    NSString *soapMessage;
    NSString *currentElement;
    NSMutableData *webResponseData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    BOOL xmlResults;
   

}
@property (weak, nonatomic) IBOutlet UILabel *lblTopHeading;
@property (weak, nonatomic) IBOutlet UITextField *txtFldName;
@property (weak, nonatomic) IBOutlet UITextField *txtFldCity;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtFldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFldVehical;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckTerms;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation RegisterProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
    vehicalArr = [[AppSinglton sharedManager] getVehiclesType];
    [self localization];
    _btnCheckTerms.selected = NO;
     [self addTollBarWithKeyBoard];
    
}

-(void)localization {
    if([_profileMode isEqualToString:@"Edit"]){
        _txtFldName.text = [AppUtils getValueFromLocalDbForKey:@"userName"];
        _txtFldCity.text = [AppUtils getValueFromLocalDbForKey:@"userCity"];
        _txtFldPhone.text = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
        _txtFldEmail.text = [AppUtils getValueFromLocalDbForKey:@"userEmail"];
        _txtFldVehical.text = [AppUtils getValueFromLocalDbForKey:@"userVehicle"];
        _txtFldPassword.text = [AppUtils getValueFromLocalDbForKey:@"userPin"];
    }
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
    
    if([_profileMode isEqualToString:@"Edit"]){
        [self gotoMainView];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)gotoMainView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)termsAndConditonsTappes:(id)sender {
    _btnCheckTerms.selected = !_btnCheckTerms.selected;
}
- (IBAction)submitFormTapped:(id)sender {
//    [self doLogin];
//    return;
    if(![_txtFldName.text length])
        [self showAlertWithTitle:@"Name" andMessage:@"Name required" andAction:NO];
    
    else if(![_txtFldCity.text length])
        [self showAlertWithTitle:@"City" andMessage:@"City required" andAction:NO];
    
    //else if(![_txtFldPhone.text length])
       // [self showAlertWithTitle:@"Phone" andMessage:@"Mobile required" andAction:NO];
    
    else if(([_txtFldPhone.text length]>0) && ([_txtFldPhone.text length]>10 || [_txtFldPhone.text length] <10))
        [self showAlertWithTitle:@"Invalid Phone" andMessage:@"Mobile is Invalid" andAction:NO];
    
    else if(![_txtFldEmail.text length])
        [self showAlertWithTitle:@"Email Id" andMessage:@"Email required" andAction:NO];
    
    else if(![AppUtils isValidEmail:_txtFldEmail.text])
        [self showAlertWithTitle:@"Invalid Email Id" andMessage:@"Email Id is invalid" andAction:NO];
    
    else if(![_txtFldVehical.text length])
        [self showAlertWithTitle:@"Vehicle" andMessage:@"Please select vehicle" andAction:NO];
    
    else if(![_txtFldPassword.text length])
        [self showAlertWithTitle:@"Pin" andMessage:@"Password required" andAction:NO];
    
    else if(! _btnCheckTerms.selected)
        [self showAlertWithTitle:@"Terms & Conditions" andMessage:@"Please accept the terms and conditions.." andAction:NO];
    
    else if(![_txtFldPhone.text length]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"As you have not provide Mobile number, please note that some of the features of app will not function." delegate:self cancelButtonTitle:@"Register" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    
    else
        [self doRegister];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self doRegister];
    }
}


-(void)doRegister {
    [AppUtils setRegisterFlag:YES];
    [AppUtils setValueInLocalDb:_txtFldName.text forKey:@"userName"];
    [AppUtils setValueInLocalDb:_txtFldCity.text forKey:@"userCity"];
    [AppUtils setValueInLocalDb:_txtFldPhone.text forKey:@"userMobile"];
    [AppUtils setValueInLocalDb:_txtFldEmail.text forKey:@"userEmail"];
    [AppUtils setValueInLocalDb:_txtFldVehical.text forKey:@"userVehicle"];
    [AppUtils setValueInLocalDb:_txtFldPassword.text forKey:@"userPin"];
    if([_profileMode isEqualToString:@"Edit"]){
        [self gotoMainView];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark - TableView datasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return vehicalArr.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationListCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationListCell"];
    }

    cell.textLabel.text = [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleName"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    _tblView.hidden = YES;
    _txtFldVehical.text = [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleName"];
}

-(void)addTollBarWithKeyBoard{
    UIToolbar *keyboardmyCustobBtnView = [[UIToolbar alloc] init];
    [keyboardmyCustobBtnView sizeToFit];
    UIBarButtonItem *myCustobBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(doneClicked:)];
    [keyboardmyCustobBtnView setItems:[NSArray arrayWithObjects:myCustobBtn, nil]];
    self.txtFldPassword.inputAccessoryView = keyboardmyCustobBtnView;
    self.txtFldPhone.inputAccessoryView = keyboardmyCustobBtnView;
}

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}


#pragma mark - TEXTFIELD Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _txtFldVehical){
        [self.view endEditing:YES];
        _tblView.hidden = !_tblView.hidden;
        return NO;
    }
    _tblView.hidden = YES;
    if(textField == _txtFldEmail){
        CGRect frame = self.view.frame;
        frame.origin.y = - 50;
        self.view.frame = frame;
    }
    if(textField == _txtFldPassword){
        CGRect frame = self.view.frame;
        frame.origin.y = - 80;
        self.view.frame = frame;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    
    NSLog(@"textFieldDidEndEditing");
    [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _txtFldPhone){
        if(_txtFldPhone.text.length == 10 && (![string isEqualToString:@""]))
            return NO;
    }
    if(textField == _txtFldPassword){
        if(_txtFldPassword.text.length == 4 && (![string isEqualToString:@""]))
            return NO;
    }
    if(textField == _txtFldVehical){
        return NO;
    }
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
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



-(void)doLogin{
    /*NSDictionary *jsonInputParms = @{@"UserData":@{
                                            @"Name": @"Sandeep Hudda",
                                           @"City": @"Delhi",
                                            @"MobileNo": @"7679845670",
                                            @"EmailId": @"sandeepggg@yahoo.com",
                                            @"VehicleCode": @"V0001",
                                            @"DeviceId":@"hgsfdghfwgd",
                                            @"SessionId":@"twqretq4w54",
                                            @"Hash":@"qwhgeffgwqe65qw654e65wq4"
                                        }
                                     };*/
    
   NSDictionary *jsonInputParms = @{
        @"SessionId": @"sfdg6565tyfgfgfgsad",
        @"Origin": @"delhi",
        @"Destination": @"mumbai",
        @"Waypoints": @"Jaipur|Agra",
        @"VehicleTypeId":@"V0001",
        @"Hash":@"ashdjhsjksagsagfhsajhhfhfghfghf"
        };
 /*NSDictionary* Street=[[NSDictionary alloc] initWithObjectsAndKeys:
 jsonInputParms, @"constraints",
 nil];*/
 
   // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:@"http://nhtis.org/IOS/api/ver1/XrTsDT" parameters:jsonInputParms progress:nil success:^(NSURLSessionTask *task, id responseObject) {
       // [SVProgressHUD dismiss];
        if([[responseObject valueForKey:@"Success"] boolValue]){
            //            NSLog(@"Error: 500 Internal server error");
            //            [self showAlertWithTitle:@"" andMessage:@"Error: 500 Internal server error" andAction:NO];
            //            return;
            //Setting userID and Email in LocalDb
            NSString *userId =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"Result"] valueForKey:@"userId"]] ;
            NSString *email = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"Result"] valueForKey:@"userEmail"]];
            [AppUtils setValueInLocalDb:userId forKey:@"userId"];
            [AppUtils setValueInLocalDb:email forKey:@"userEmail"];
            
            [self showAlertWithTitle:@"Success" andMessage:[responseObject valueForKey:@"Message"] andAction:YES];
        }else{
            [self showAlertWithTitle:@"" andMessage:[responseObject valueForKey:@"Message"] andAction:NO];
        }
        //  NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
       // [SVProgressHUD dismiss];
        [self showAlertWithTitle:@"" andMessage:@"Server Error! Please try again." andAction:NO];
    }];
    
}







@end
