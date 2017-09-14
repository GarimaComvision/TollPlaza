//
//  PaymentController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 12/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "PaymentController.h"
#import "AppUtils.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
#import "GenerateReceiptController.h"
#import "ViewController.h"

@interface PaymentController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *payview;

@end


NSString  *refnum;
NSString *hash2=@"";
NSString *sessionid2=@"";
NSString *mobilenumber2=@"";
NSString *jsonString;
NSString *vehclass;
NSString *transtatus;

NSString *salt2 = @"<RSAKeyValue><Modulus>nDbi8tghVbW+w1S0heTUm05ve2ur38pWCP5l7AzcpDRuIzLEAKqRop6GKAfFmoHUJQ3WYDLYWxpaFD66DrtrjEAVWkcbuRvTFdVl+/QV2mZ+7eqAJsgScp7R9uELnnewEwZ8fShtAfboLoPIGGWoAuD8XLU8Tf0Yd4WLR/orH30=</Modulus><Exponent>AQAB</Exponent><P>2MzQHeuZdM6jhCKwkEh9YgshgokTaARXS1iit7Bnh5nz44IxhP2U+6NhZUzs4g0eZ1eF4SeLJmGJlHciASHcZw==</P><Q>uHWzMsqfoCMB4E3AWErU7BaFVc8jv2V9MF8dOPdhHi5+q9+NMFKFKLyDkw05Peu/uH4WIjVRQ67H3cg3oQO2ew==</Q><DP>wwGvLUqPFL8N27vsP0vE5ByI/sZXm1dUQeSvMDTPWuyCsKCZ9Dq3+ISkBZ9k74vHTkMunDCafGJ9gvqJrqULfw==</DP><DQ>NDo/LtZoM/M1iMj6+QTXHLGTtyQbPwoBVDzaDVMd0Gnhu9BkLZZv1YTqzCwmVP33Hsm0gqMOC1flh0o1VgWzGQ==</DQ><InverseQ>HEaO6q+67rUtbJLXzgxo+U9iEmf3gL1Gl9pSN0diPUjRWZNxiEEPcGj2+YLIVdSfllT8PBnp4YnqzTRab1F+Nw==</InverseQ><D>BUmZpUa/MMVVBbaMb7XGFZsAcDq90ISjzzNYTtMoZy1YP+bcKBZIlY5eaVaRj9yndMctoAfWxbHCXuZ/+EWTMgMfo0cnrD9PX9Icw8cGWKl+dW/hnA8wBCHSJX/MEi3EEO0ABVnrkEXg2rzdfqtw0gmbbOm/fgkI9i+iPnyKWG8=</D></RSAKeyValue>";

@implementation PaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    [self loadsite];
    
    self.payview.delegate = self;
    
   
    // Do any additional setup after loading the view.
}

- (void)loadsite
{
    
    
   NSString *mobilenumber1 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];

    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"http://nhtis.org/payment/paymentdetails.aspx?Mobile=",mobilenumber1,@"&vehicleno=",_vnumber,@"&amount=",_totalamount2];
    
    NSURL *url1 = [NSURL URLWithString:url];
    
           NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url1];
    [_payview loadRequest:urlRequest];
       
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *userName = [self.graphTotal stringByEvaluatingJavaScriptFromString:@"testFunction()"];
//    NSLog(@"Web response: %@",userName);
    
    NSString *successurl = @"PostPaymentDetails.aspx";
    NSString *stat = @"Success";
    
    if (webView.isLoading) {
        return;
    }
    NSURL *requestURL = [[webView request] URL];
    NSLog(@"WebView finished loading with requestURL: %@",requestURL);
    NSString *getStringFromUrl = [NSString stringWithFormat:@"%@",requestURL];
    if ([self containsString:getStringFromUrl :successurl]) {
        [self performSelector:@selector(delayedDidFinish:) withObject:getStringFromUrl afterDelay:0.0];
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        
        NSLog(@"HTML recieved: %@",html);
        
        transtatus = [webView stringByEvaluatingJavaScriptFromString: @"$('#lbmsg').text()"];
        
        refnum = [webView stringByEvaluatingJavaScriptFromString: @"$('#lbrn').text()"];
        NSLog(@"Transaction reference Number : %@",refnum);
        if ([self containsString:transtatus :stat]){
        [self completepayment];
       }
        else
        {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry !!!" message:@"Your transaction failed. Please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
            
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
            
                    }
    } else  {
//        // FAILURE ALERT
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry !!!" message:@"Your transaction failed. Please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        alert.tag = 1;
//        [alert show];
        
        return;
    }
    
    
}

- (void) completepayment
{
    [self hashed_string];
    [self randomizeString];
    
    mobilenumber2 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    
  vehclass= [AppUtils getValueFromLocalDbForKey:@"userVehicle"];
    
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
    
    
    for(NSDictionary *toll in _tollarray1)
    {
        NSMutableDictionary *toll1 = [toll mutableCopy];
        
        [toll1 removeObjectForKey:@"TollLocation"];
        
        [newtollist addObject:toll1];
    }
    
     NSLog(@"Toll List Array: %@",newtollist);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newtollist options:NSJSONWritingPrettyPrinted error:&error];
    
    if (jsonData && !error)
    {
       jsonString  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSDictionary *parameters = @{@"SessionId": sessionid2, @"Mobile": mobilenumber2, @"TransactionNo": refnum, @"TransactionDate": [dateFormatter stringFromDate:[NSDate date]],@"VehicleNumber" : _vnumber, @"PaymentType": @"WorldLine", @"TotalAmount": _totalamount2,@"VehicleClass" : vehclass, @"Hash" : hash2,@"PaymentDetails" : newtollist };
    
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

        
        [curreceipt setObject:refnum forKey:@"refnum"];
        [curreceipt setObject:vehclass forKey:@"vehclass"];
        [curreceipt setObject:_vnumber forKey:@"vehnum"];
        [curreceipt setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"transdate"];
        [curreceipt setObject:_totalamount2 forKey:@"amount"];
        [curreceipt setObject:_psource1 forKey:@"source"];
        [curreceipt setObject:_pdestination1 forKey:@"destination"];
        
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
        
        
        [curreceipt setObject:refnum forKey:@"refnum"];
        [curreceipt setObject:vehclass forKey:@"vehclass"];
        [curreceipt setObject:_vnumber forKey:@"vehnum"];
        [curreceipt setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"transdate"];
        [curreceipt setObject:_totalamount2 forKey:@"amount"];
        [curreceipt setObject:_psource1 forKey:@"source"];
        [curreceipt setObject:_pdestination1 forKey:@"destination"];
        
        [receipts addObject:curreceipt];
        
        
        [defaults setObject:receipts forKey:@"receipts"];
        [defaults synchronize];

    }
    
}

- (void)delayedDidFinish:(NSString *)getStringFromUrl {
    
//        NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
//        [mutDictTransactionDetails setObject:strMIHPayID forKey:@"Transaction_ID"];
//        [mutDictTransactionDetails setObject:@"Success" forKey:@"Transaction_Status"];
//        
//        [self navigateToPaymentStatusScreen:mutDictTransactionDetails];
    
    
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

- (BOOL)containsString: (NSString *)string : (NSString*)substring {
    return [string rangeOfString:substring].location != NSNotFound;
}

- (IBAction)backTapped:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Incomplete"
                                                    message:@"Your transaction is in progress.Select YES if you want to cancel the payment and go back"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

    
    
}

- (void)hashed_string
{
    const char *cstr = [salt2 cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:salt2.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }\
    
    hash2=output;
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
    
    sessionid2 = output;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            [alertView dismissWithClickedButtonIndex:nil animated:YES];
            break;
        case 1: {
            ViewController *selectedViewController;
            selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
           
                selectedViewController.mapType = @"Enroute";
            [self.navigationController popViewControllerAnimated:YES];
           
            [self.navigationController pushViewController:selectedViewController animated:YES];
            
            break;}
    }
}



@end

