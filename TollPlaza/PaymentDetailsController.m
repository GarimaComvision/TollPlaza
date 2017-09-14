//
//  PaymentDetailsController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 13/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "PaymentDetailsController.h"
#import "PaymentController.h"
#import "MPaymentController.h"
#import "SHKActivityIndicator.h"
#import "HttpConnectionClass.h"
#import "BDViewController.h"
#import "AppUtils.h"
#import "RegisterProfileController.h"

@interface PaymentDetailsController ()
{
    NSMutableArray *paytypeArray;
}
@property (weak, nonatomic) IBOutlet UITextField *tamount;
@property (weak, nonatomic) IBOutlet UITextField *vehnumber;
@property (weak, nonatomic) IBOutlet UITableView *paytypesview;
@property (weak, nonatomic) IBOutlet UITextField *ptype;



@end




@implementation PaymentDetailsController

@synthesize bdvc;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    self.vehnumber.delegate = self;
    self.ptype.delegate = self;
    
    [self.tamount setText: _totalamount1];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
       // Do any additional setup after loading the view.
    
    paytypeArray = [[NSMutableArray alloc] init];
    
    [ paytypeArray insertObject:@"Airtel Money / Wallets" atIndex:0];
    [ paytypeArray insertObject:@"Credit Card" atIndex:1];
    [ paytypeArray insertObject:@"Debit Card" atIndex:2];
     [ paytypeArray insertObject:@"Netbanking" atIndex:3];
    [ paytypeArray insertObject:@"UPI" atIndex:3];
     
    self.paytypesview.delegate = self;
    self.paytypesview.dataSource = self;
    
     _paytypesview.hidden = YES;
    
}

#pragma mark - TableView datasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return paytypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationListCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationListCell"];
    }
    
    cell.textLabel.text = [paytypeArray objectAtIndex:indexPath.row] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    _paytypesview.hidden = YES;
    _ptype.text = [paytypeArray objectAtIndex:indexPath.row];
}

#pragma mark - TEXTFIELD Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _ptype){
        [self.view endEditing:YES];
        _paytypesview.hidden = !_paytypesview.hidden;
        return NO;
    }
    _paytypesview.hidden = YES;
        return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
       [textField resignFirstResponder];
}


- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)proceedPressed:(id)sender {
    
    if([_ptype.text isEqualToString:@"Airtel Money / Wallets"])
    {
        NSString *vnum = _vehnumber.text;
        
        UIStoryboard* mainStoryBoard;
        mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        
        MPaymentController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MPaymentController"];
        pd.totalamount3 = _totalamount1;
        pd.vnumber1 = vnum;
        pd.tollarray2 = _tolllist;
        pd.psource2 = _psource;
        pd.pdestination2 = _pdestination;
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:pd animated:YES];
        
    }
//    else if([_ptype.text isEqualToString:@"Billdesk"]){
//
//        
//        [self payNowClicked:sender];
//    
//    }
    
    else if([_ptype.text isEqualToString:@"Credit Card"] || [_ptype.text isEqualToString:@"Debit Card"]){
            NSString *vnum = _vehnumber.text;
        
            UIStoryboard* mainStoryBoard;
            mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        
            PaymentController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PaymentController"];
            pd.totalamount2 = _totalamount1;
            pd.vnumber = vnum;
            pd.tollarray1 = _tolllist;
            pd.psource1 = _psource;
            pd.pdestination1 = _pdestination;
            //[self.navigationController popViewControllerAnimated:YES];
            [self.navigationController pushViewController:pd animated:YES];
    }
    
    else if([_ptype.text isEqualToString:@"Netbanking"] || [_ptype.text isEqualToString:@"UPI"])
    {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This payment option is a work in progress\nKindly choose another option" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
         [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3.0];
        
    }
    
//    NSString *vnum = _vehnumber.text;
//    
//                UIStoryboard* mainStoryBoard;
//                mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    
//                PaymentController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PaymentController"];
//                pd.totalamount2 = _totalamount1;
//                pd.vnumber = vnum;
//                pd.tollarray1 = _tolllist;
//                pd.psource1 = _psource;
//                pd.pdestination1 = _pdestination;
//                [self.navigationController popViewControllerAnimated:YES];
//                [self.navigationController pushViewController:pd animated:YES];
    
    // [self payNowClicked:sender];
    
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    if(textField == _vehnumber){
        if(_vehnumber.text.length == 10 && (![text isEqualToString:@""]))
            return NO;
    }
   
    if(textField == _ptype){
        return NO;
    }
    return YES;


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)payNowClicked:(id)sender
{
//    NSString *email = [ AppUtils getValueFromLocalDbForKey:@"userEmail"];
//    
//    //[self.amountField resignFirstResponder];
//    
//    
//    
//    
//           NSString *resop=@"METLIFSALE|ARP253|NA|1|VJB|NA|NA|INR|NA|R|METLIFSALE|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|http://122.169.118.65/billdesk/pg_dump.php|4171381948";
//        NSString *message2 = @"AIRMTST|BDTEST0000000003|NA|2.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://pgi.billdesk.com/pgidsk/pgmerc/SDKResponse. jsp|1976924613";
//        
//        message2 = @"METLIFSALE|BDTEST24052017_03|NA|2.00|NA|NA|NA|INR|NA|R|metlifsale|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498";//Visa
//    
//    NSString *msg3 = @"COMVISTOLL|12|NA|2.00|NA|NA|NA|INR|NA|R|comvistoll|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://nhtis.org/payment/billdeskpostpaymentdetails.aspx|3052811498";
//    
//    NSString *message1 = @"AIRMTST|BDTEST0000000003|NA|2.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|http://nhtis.org/payment/billdeskpostpaymentdetails.aspx|1976924613";
//    
//    NSString *sample = [NSString stringWithFormat:@"COMVISTOLL|14|NA|%@.00|NA|NA|NA|INR|NA|R|comvistoll|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498",@"2"];
//    
//    NSString *sample2 = [NSString stringWithFormat:@"METLIFSALE|BDTEST24052017_03|NA|%@.00|NA|NA|NA|INR|NA|R|metlifsale|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498",_totalamount1];
//
//    
//        bdvc=[[BDViewController alloc]initWithMessage:message2  andToken:@"NA"  andEmail:email andMobile:@"7042511418"];
//        
//        
//        bdvc.delegate=self;
//        
//        [[SHKActivityIndicator currentIndicator]displayCompleted:@"Success"];
//        bdvc.hidesBottomBarWhenPushed = YES ;
//        [self.navigationController pushViewController:bdvc animated:YES];
    
    if ([AppUtils isRegisteredUser])
    {
        NSString *email = [ AppUtils getValueFromLocalDbForKey:@"userEmail"];
        
        //[self.amountField resignFirstResponder];
        
        NSString *resop=@"METLIFSALE|ARP253|NA|1|VJB|NA|NA|INR|NA|R|METLIFSALE|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|http://122.169.118.65/billdesk/pg_dump.php|4171381948";
        NSString *message2 = @"AIRMTST|BDTEST0000000003|NA|2.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://pgi.billdesk.com/pgidsk/pgmerc/SDKResponse. jsp|1976924613";
        
        message2 = @"METLIFSALE|BDTEST24052017_03|NA|2.00|NA|NA|NA|INR|NA|R|metlifsale|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498";//Visa
        
        NSString *msg3 = @"COMVISTOLL|12|NA|2.00|NA|NA|NA|INR|NA|R|comvistoll|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://nhtis.org/payment/billdeskpostpaymentdetails.aspx|3052811498";
        
        NSString *message1 = @"AIRMTST|BDTEST0000000003|NA|2.00|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|http://nhtis.org/payment/billdeskpostpaymentdetails.aspx|1976924613";
        
        NSString *sample = [NSString stringWithFormat:@"COMVISTOLL|14|NA|%@.00|NA|NA|NA|INR|NA|R|comvistoll|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498",@"2"];
        
        NSString *sample2 = [NSString stringWithFormat:@"METLIFSALE|BDTEST24052017_03|NA|%@.00|NA|NA|NA|INR|NA|R|metlifsale|NA|NA|F|BDTEST2405201703|20557647|TEST2405201703|NA|NA|NA|NA|http://www.billdesk.com|3052811498",_totalamount1];
        
        
        bdvc=[[BDViewController alloc]initWithMessage:message2  andToken:@"NA"  andEmail:email andMobile:@"7042511418"];
        
        bdvc.delegate=self;
        
        [[SHKActivityIndicator currentIndicator]displayCompleted:@"Success"];
        bdvc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:bdvc animated:YES];
        
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"You can't go ahead without registration"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Register"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [self goToRegisterView];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Okay"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    
}

-(void)paymentStatus:(NSString*)message
{
    //NSLog(@"payment status is %@",[NSString stringWithFormat:@"http://122.169.118.65/billdesk/paymentresponse.php?msg=%@", [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]);
    //NSLog(@"payment status is [%@]",[NSString stringWithFormat:@"http://192.167.1.11/billdesk/paymentresponse.php?msg=%@", [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]);
    [self.navigationController popToViewController:self animated:YES];
    NSLog(@"payment status response [%@]",message);
    //[self showAlert:message];
    NSArray *responseComponents=[message componentsSeparatedByString:@"|"];
    if([responseComponents count]>=25)
    {
        NSString *statusCode=(NSString*)[responseComponents objectAtIndex:14];
        [self showAlert:statusCode];
    }
    else
    {
        [self showAlert:@"Something went wrong"];
        
    }
}

-(void)showAlert:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Payment status" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(NSString *)createJsonObject:(NSString *)serverStr
{
    
    NSArray *mostOuter = [serverStr componentsSeparatedByString:@"^"];
    NSString *token = [mostOuter objectAtIndex:1];
    NSArray *outerList = [[mostOuter objectAtIndex:0] componentsSeparatedByString:@"|"];
    NSLog(@"token is %@",token);
    NSLog(@"outerList is %@",outerList);
    NSArray *rawData = [[outerList objectAtIndex:7]componentsSeparatedByString:@"~"];
    NSLog(@"rawData is %@",rawData);
    
    return token;
    
}
- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}
-(void)goToRegisterView {
    UIStoryboard*  mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterProfileController *registerVC =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"RegisterProfileController"];
    
    [self presentViewController:registerVC animated:YES completion:nil];
}


//- (void)keyboardFrameWillChange:(NSNotification *)notification
//{
//    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
//    
//    CGRect newFrame = self.view.frame;
//    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
//    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
//    
//    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
//    self.view.frame = newFrame;
//    
//    [UIView commitAnimations];
//}

- (IBAction)ptype:(UITextField *)sender {
}
@end

