//
//  MPaymentController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 21/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "MPaymentController.h"
#import "AppUtils.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
#import "GenerateReceiptController.h"
#import "ViewController.h"

@interface MPaymentController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *otpfield;


@end


NSString  *refnum1;
NSString *hash3=@"";
NSString *sessionid3=@"";
NSString *mobilenumber3=@"";
NSString *jsonString1;
NSString *vehclass1;
NSString *transtatus1;


NSString *mRecievedSessionId;
NSString *mRecievedErrorCode;
NSString *mRecievedMessage;
NSString *mRecievedCode;
NSString *mTransactionRef;
NSString *tranid;

NSString *salt3 = @"<RSAKeyValue><Modulus>nDbi8tghVbW+w1S0heTUm05ve2ur38pWCP5l7AzcpDRuIzLEAKqRop6GKAfFmoHUJQ3WYDLYWxpaFD66DrtrjEAVWkcbuRvTFdVl+/QV2mZ+7eqAJsgScp7R9uELnnewEwZ8fShtAfboLoPIGGWoAuD8XLU8Tf0Yd4WLR/orH30=</Modulus><Exponent>AQAB</Exponent><P>2MzQHeuZdM6jhCKwkEh9YgshgokTaARXS1iit7Bnh5nz44IxhP2U+6NhZUzs4g0eZ1eF4SeLJmGJlHciASHcZw==</P><Q>uHWzMsqfoCMB4E3AWErU7BaFVc8jv2V9MF8dOPdhHi5+q9+NMFKFKLyDkw05Peu/uH4WIjVRQ67H3cg3oQO2ew==</Q><DP>wwGvLUqPFL8N27vsP0vE5ByI/sZXm1dUQeSvMDTPWuyCsKCZ9Dq3+ISkBZ9k74vHTkMunDCafGJ9gvqJrqULfw==</DP><DQ>NDo/LtZoM/M1iMj6+QTXHLGTtyQbPwoBVDzaDVMd0Gnhu9BkLZZv1YTqzCwmVP33Hsm0gqMOC1flh0o1VgWzGQ==</DQ><InverseQ>HEaO6q+67rUtbJLXzgxo+U9iEmf3gL1Gl9pSN0diPUjRWZNxiEEPcGj2+YLIVdSfllT8PBnp4YnqzTRab1F+Nw==</InverseQ><D>BUmZpUa/MMVVBbaMb7XGFZsAcDq90ISjzzNYTtMoZy1YP+bcKBZIlY5eaVaRj9yndMctoAfWxbHCXuZ/+EWTMgMfo0cnrD9PX9Icw8cGWKl+dW/hnA8wBCHSJX/MEi3EEO0ABVnrkEXg2rzdfqtw0gmbbOm/fgkI9i+iPnyKWG8=</D></RSAKeyValue>";

@implementation MPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
     self.otpfield.delegate = self;
    
    [self sendornot];
    
    
    // Do any additional setup after loading the view.
}

- (void)hashed_string
{
    const char *cstr = [salt3 cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:salt3.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }\
    
    hash3=output;
}

-(void)sendornot
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"An OTP will be sent to your registered mobile number. Do you wish to proceed?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            [alertView dismissWithClickedButtonIndex:nil animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1: {
            
            [self sendotp];
            

        }
            
           }
}



- (void) sendotp
{
    [self hashed_string];
    [self randomizeString];
    
    mobilenumber3 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    
    vehclass1= [AppUtils getValueFromLocalDbForKey:@"userVehicle"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
    NSString *url = @"https://nhtis.org/api/ver1/OdMXq";
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",@"text/html",@"text/json",nil];
    
    
    
    
    NSDictionary *parameters = @{@"sessionId": sessionid3, @"actorId": mobilenumber3,@"plazaId": @"1", @"amount": @"1",@"vehcleType" : vehclass1, @"Hash" : hash3 };
    
    NSLog(@"JSON data : %@", parameters);
    
    [manager POST:url parameters:parameters
          success:^(NSURLSessionDataTask *operation, id responseObject) {
              NSLog(@"Response: %@", responseObject);
              
              mTransactionRef = [responseObject objectForKey:@"TransactionRef"];
              mRecievedSessionId = [responseObject objectForKey:@"sessionId"];
              mRecievedErrorCode = [responseObject objectForKey:@"errorCode"];
              mRecievedMessage = [responseObject objectForKey:@"messageText"];
              mRecievedCode = [responseObject objectForKey:@"code"];
              if ([mRecievedErrorCode isEqualToString:@"000"])
              {
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OTP Sent !!!" message:@"Enter the OTP you receive via SMS" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                  alert.tag = 1;
                  
                  [alert show];
                  
                  
                  
                  [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
              }
              else
              {
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OTP not Sent !!!" message:mRecievedMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                  alert.tag = 1;
                  
                  [alert show];
                  
                  
                  
                  [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
                  

              }
              
             
              
              
              
              
              
              
          } failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OTP not sent !!!" message:@"Retry after some time" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
              alert.tag = 1;
              
              [alert show];
              
              
              
              [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
              
              
              
              
          }];
}

- (IBAction)proceedPressed:(id)sender {
    if([_otpfield.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OTP !!!" message:@" OTP Required" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        alert.tag = 1;
        
        [alert show];
        
        
        
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
        

    }
    else{
    [self hashed_string];
    [self randomizeString];
    
    mobilenumber3 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    
    vehclass1= [AppUtils getValueFromLocalDbForKey:@"userVehicle"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
    NSString *url = @"https://nhtis.org/api/ver1/FTrwQ";
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",@"text/html",@"text/json",nil];
    
    
    
    
    NSDictionary *parameters = @{@"sessionId": sessionid3, @"ucode": _otpfield.text,@"TransactionRef":mTransactionRef , @"Hash" : hash3 };
    
    NSLog(@"JSON data : %@", parameters);
    
    [manager POST:url parameters:parameters
          success:^(NSURLSessionDataTask *operation, id responseObject) {
              NSLog(@"Response: %@", responseObject);
              
            tranid = [responseObject objectForKey:@"TransactionId"];
              NSString *msg = [responseObject objectForKey:@"messageText"];
              
              NSString *fcode =  [responseObject objectForKey:@"errorCode"];
              
              if([fcode isEqualToString:@"000"])
              {
                  if(!([tranid length]==12))
                  {
                      for(NSInteger i = [tranid length];i<12;i++)
                      {
                         tranid =  [tranid stringByAppendingString:@"0"];
                      }
                  }
                  
                  [self completepayment];
                  
              }
              
              else
              {
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment not completed !!!" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                  alert.tag = 1;
                  
                  [alert show];
                  
                  
                  
                  [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];

              }
              
              
              
              
              
          } failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment not completed !!!" message:@"Retry after some time" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
              alert.tag = 1;
              
              [alert show];
              
              
              
              [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
              
              
              
              
          }];

    }
}


- (void) completepayment
{
    [self hashed_string];
    [self randomizeString];
    
    mobilenumber3 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    
    vehclass1= [AppUtils getValueFromLocalDbForKey:@"userVehicle"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
    NSString *url = @"https://nhtis.org/api/ver1/kRdFcG";
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",@"text/html",nil];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDictionary *dictJsonData = [NSDictionary dictionaryWithObjectsAndKeys:[_tollarray1 mutableCopy],nil];
    
    NSError *error = nil;
    
    
    NSMutableArray *newtollist = [[NSMutableArray alloc] init];
    
    
    for(NSDictionary *toll in _tollarray2)
    {
        NSMutableDictionary *toll1 = [toll mutableCopy];
        
        [toll1 removeObjectForKey:@"TollLocation"];
        
        [newtollist addObject:toll1];
    }
    
    NSLog(@"Toll List Array: %@",newtollist);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newtollist options:NSJSONWritingPrettyPrinted error:&error];
    
    if (jsonData && !error)
    {
        jsonString1  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSDictionary *parameters = @{@"SessionId": sessionid3, @"Mobile": mobilenumber3, @"TransactionNo": tranid, @"TransactionDate": [dateFormatter stringFromDate:[NSDate date]],@"VehicleNumber" : _vnumber1, @"PaymentType": @"Airtel", @"TotalAmount": _totalamount3,@"VehicleClass" : vehclass1, @"Hash" : hash3,@"PaymentDetails" : newtollist };
    
    NSLog(@"JSON data : %@", parameters);
    
    [manager POST:url parameters:parameters
          success:^(NSURLSessionDataTask *operation, id responseObject) {
              NSLog(@"Response: %@", responseObject);
              
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment Success !!!" message:@"Transaction Completed, Storing Receipt details" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
              alert.tag = 1;
              
              [alert show];
              
              
              
              [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
              
              [self storereceipt];
              
              ViewController *selectedViewController;
              selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
              
              selectedViewController.mapType = @"Enroute";
              [self.navigationController popViewControllerAnimated:YES];
              
              [self.navigationController pushViewController:selectedViewController animated:YES];
              
              
              
              
              
              
          } failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Testing !!!" message:@"Storing Receipt details" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
              alert.tag = 1;
              
              [alert show];
              
              
              
              [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
              
              [self storereceipt];
              
              
              ViewController *selectedViewController;
              selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
              
              selectedViewController.mapType = @"Enroute";
              [self.navigationController popViewControllerAnimated:YES];
              
              [self.navigationController pushViewController:selectedViewController animated:YES];
              
              
              
          }];
    
}


- (void) storereceipt

{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"receipts"]){
        
        NSArray *receipts = [AppUtils getArrayFromLocalDbForKey:@"receipts"];
        
        NSMutableArray *receiptsnew = [receipts mutableCopy];
        
        NSMutableDictionary *curreceipt = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        [curreceipt setObject:tranid forKey:@"refnum"];
        [curreceipt setObject:vehclass1 forKey:@"vehclass"];
        [curreceipt setObject:_vnumber1 forKey:@"vehnum"];
        [curreceipt setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"transdate"];
        [curreceipt setObject:_totalamount3 forKey:@"amount"];
        [curreceipt setObject:_psource2 forKey:@"source"];
        [curreceipt setObject:_pdestination2 forKey:@"destination"];
        
        [receiptsnew addObject:curreceipt];
        
        
        [defaults setObject:receiptsnew forKey:@"receipts"];
        [defaults synchronize];
        
        
        
    }
    
    else
    {
        NSMutableArray *receipts = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *curreceipt = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        [curreceipt setObject:tranid forKey:@"refnum"];
        [curreceipt setObject:vehclass1 forKey:@"vehclass"];
        [curreceipt setObject:_vnumber1 forKey:@"vehnum"];
        [curreceipt setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"transdate"];
        [curreceipt setObject:_totalamount3 forKey:@"amount"];
        [curreceipt setObject:_psource2 forKey:@"source"];
        [curreceipt setObject:_pdestination2 forKey:@"destination"];
        
        [receipts addObject:curreceipt];
        
        
        [defaults setObject:receipts forKey:@"receipts"];
        [defaults synchronize];
        
    }
    
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

- (void)randomizeString
{
    NSString *str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    NSMutableString *input = [str mutableCopy];
    NSMutableString *output = [NSMutableString string];
    
    NSUInteger len = input.length;
    
    for (NSUInteger i = 0; i < 10; i++) {
        NSInteger index = arc4random_uniform((unsigned int)input.length);
        [output appendFormat:@"%C", [input characterAtIndex:index]];
        [input replaceCharactersInRange:NSMakeRange(index, 1) withString:@""];
    }
    
    sessionid3 = output;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if(textField == _otpfield){
//        [self.view endEditing:YES];
//        _paytypesview.hidden = !_paytypesview.hidden;
//        return NO;
//    }
//    _paytypesview.hidden = YES;
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}


@end
