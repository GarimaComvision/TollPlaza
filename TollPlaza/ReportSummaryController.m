//
//  ReportSummaryController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "ReportSummaryController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppUtils.h"
#import "UIImageView+AFNetworking.h"
#import "UserIndexController.h"
#import "ReportViewCell.h"


@interface ReportSummaryController ()
{
    int currentSegment;
}
@property (weak, nonatomic) IBOutlet UILabel *reportedcount;
@property (weak, nonatomic) IBOutlet UILabel *resolvedcount;
@property (weak, nonatomic) IBOutlet UILabel *assignedcount;
@property (weak, nonatomic) IBOutlet UILabel *notacceptedcount;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlCount;

@end

@implementation ReportSummaryController

NSString *salt1 = @"<RSAKeyValue><Modulus>nDbi8tghVbW+w1S0heTUm05ve2ur38pWCP5l7AzcpDRuIzLEAKqRop6GKAfFmoHUJQ3WYDLYWxpaFD66DrtrjEAVWkcbuRvTFdVl+/QV2mZ+7eqAJsgScp7R9uELnnewEwZ8fShtAfboLoPIGGWoAuD8XLU8Tf0Yd4WLR/orH30=</Modulus><Exponent>AQAB</Exponent><P>2MzQHeuZdM6jhCKwkEh9YgshgokTaARXS1iit7Bnh5nz44IxhP2U+6NhZUzs4g0eZ1eF4SeLJmGJlHciASHcZw==</P><Q>uHWzMsqfoCMB4E3AWErU7BaFVc8jv2V9MF8dOPdhHi5+q9+NMFKFKLyDkw05Peu/uH4WIjVRQ67H3cg3oQO2ew==</Q><DP>wwGvLUqPFL8N27vsP0vE5ByI/sZXm1dUQeSvMDTPWuyCsKCZ9Dq3+ISkBZ9k74vHTkMunDCafGJ9gvqJrqULfw==</DP><DQ>NDo/LtZoM/M1iMj6+QTXHLGTtyQbPwoBVDzaDVMd0Gnhu9BkLZZv1YTqzCwmVP33Hsm0gqMOC1flh0o1VgWzGQ==</DQ><InverseQ>HEaO6q+67rUtbJLXzgxo+U9iEmf3gL1Gl9pSN0diPUjRWZNxiEEPcGj2+YLIVdSfllT8PBnp4YnqzTRab1F+Nw==</InverseQ><D>BUmZpUa/MMVVBbaMb7XGFZsAcDq90ISjzzNYTtMoZy1YP+bcKBZIlY5eaVaRj9yndMctoAfWxbHCXuZ/+EWTMgMfo0cnrD9PX9Icw8cGWKl+dW/hnA8wBCHSJX/MEi3EEO0ABVnrkEXg2rzdfqtw0gmbbOm/fgkI9i+iPnyKWG8=</D></RSAKeyValue>";

ReportViewCell *cell;
ReportViewCell *cell1;
int rnumber=1;
NSString *hash1=@"";
NSString *sessionid1=@"";
NSString *mobilenumber1=@"";
NSInteger noofreports;
NSCache *imageCache;
NSCache *nhaiCache;

NSMutableDictionary *genissue;

int  genpoor =0;
int genpotholes=0;
int gensafety=0;
int genfastag=0;
int genmanagement=0;

int repcount;
int rescount;
int asscount;
int notcount;

int loadcount;

NSArray *reportlist;
NSArray *allreportlist;

UIAlertView *alert;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    imageCache = [[NSCache alloc] init];
    nhaiCache = [[NSCache alloc] init];

     repcount=0;
     rescount=0;
     asscount=0;
     notcount=0;
    
     loadcount=0;
   
        [self loadreports];
       
    [_segmentControl setSelectedSegmentIndex:4];
    [_segmentControlCount setTintColor:[UIColor clearColor]];
    [_segmentControlCount setUserInteractionEnabled:NO];
    [_segmentControlCount setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}
                                forState:UIControlStateNormal];
    [_segmentControlCount setWidth:[_segmentControl widthForSegmentAtIndex:0] forSegmentAtIndex:0];
    [_segmentControlCount setWidth:[_segmentControl widthForSegmentAtIndex:1] forSegmentAtIndex:1];
    [_segmentControlCount setWidth:[_segmentControl widthForSegmentAtIndex:2] forSegmentAtIndex:2];
    [_segmentControlCount setWidth:[_segmentControl widthForSegmentAtIndex:3] forSegmentAtIndex:3];
    [_segmentControlCount setWidth:[_segmentControl widthForSegmentAtIndex:4] forSegmentAtIndex:4];

    self.reporttableview.delegate = self;
    self.reporttableview.dataSource = self;
    
    genissue = [[NSMutableDictionary alloc] init];

    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reportlist.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ReportViewCell";
    tableView.rowHeight = 450;
   
         cell = (ReportViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell1 = (ReportViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([reportlist count] >0)
    {
       
            NSDictionary *report = [reportlist objectAtIndex:indexPath.row];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReportViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.parent_table setUserInteractionEnabled:NO];

        cell.reportnumber.text = [NSString stringWithFormat:@"Report %d", indexPath.row + 1];
            cell.issuetypelabel.text = [NSString stringWithFormat:@"%@", [report objectForKey:@"IssueType"]];
        
        if([cell.issuetypelabel.text containsString:@"Poor"])
        {
            genpoor++;
        }
        else if([cell.issuetypelabel.text containsString:@"Potholes"])
            
        {
            genpotholes++;
        }
        
        else if([cell.issuetypelabel.text containsString:@"Safety"])
            
        {
            gensafety++;
        }
        
        else if ([cell.issuetypelabel.text containsString:@"Fastag"])
        {
            genfastag++;
        }
        
        else
        {
            genmanagement++;
        }
        
            cell.locationaddresslabel.text = [NSString stringWithFormat:@"%@", [report objectForKey:@"Location"]];
            cell.reporteddatelabel.text = [NSString stringWithFormat:@"%@", [report objectForKey:@"ReportedDate"]];
            cell.reportstatuslabel.text = [NSString stringWithFormat:@"%@", [report objectForKey:@"Status"]];
            cell.commentslabel.text = [NSString stringWithFormat:@"%@", [report objectForKey:@"UserRemarks"]];
        
        if([[report objectForKey:@"Status"] isEqualToString:@"Resolved"])
        {
            cell.reportstatuslabel.textColor = [UIColor greenColor];
            
        }
        
        NSString *imagename = [report objectForKey:@"ImageEvidence"];
        
        UIImage *image = [imageCache objectForKey:imagename];
       
                   cell.evidenceimageview.image=image;
        NSLog(@"Image set: %@", imagename);
        
            rnumber++;
    }
 return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Open individual report summary and send data for calculation of USI
        ReportViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.reportstatuslabel.text containsString:@"Resolved"]){
    
    [genissue setValue:[NSNumber numberWithInt:genpoor] forKey:@"Poor"];
    
    [genissue setValue:[NSNumber numberWithInt:genpotholes] forKey:@"Potholes"];
    
    [genissue setValue:[NSNumber numberWithInt:gensafety] forKey:@"Safety"];
    
    [genissue setValue:[NSNumber numberWithInt:genfastag] forKey:@"Fastag"];
    
    [genissue setValue:[NSNumber numberWithInt:genmanagement] forKey:@"Management"];
        
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UserIndexController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"UserIndexController"];
    
    pd.issuetypename = cell.issuetypelabel.text;
    
    pd.issuereporteddatename = cell.reporteddatelabel.text;
    
    pd.issueresolveddatename = cell.resolveddatelabel.text;
    
    NSDictionary *currreport=[reportlist objectAtIndex:indexPath.row];
    
    pd.issuenhairemarks = [currreport objectForKey:@"NhaiRemarks"];
        
        NSString *str = [[reportlist objectAtIndex:indexPath.row] objectForKey:@"NhaiEvidence"];
        
    UIImage *image = [nhaiCache objectForKey:[currreport objectForKey:@"NhaiEvidence"]];
    
    pd.issuenhaievidence = image;
;;    
    [self.navigationController pushViewController:pd animated:YES];

    }

}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:
(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:
(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // instead of XXX.XXX.XXX, add the host URL,
        // if this didn't work, print out the error you receive.
        if ([challenge.protectionSpace.host isEqualToString:@"nhtis.org"]) {
            NSLog(@"Allowing bypass...");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:
                                           challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential
                 forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void) loadimages
{
    int i=0;

    if([reportlist count] >0)
    {
        while([reportlist count] >0 && [reportlist count] >i){
        
        NSDictionary *report = [reportlist objectAtIndex:i];
        
        [self randomizeString];
        [self hashed_string];
        
        mobilenumber1 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"https://nhtis.org/api/ver1/ImsDft?mobile=",mobilenumber1,@"&evidence=",[report objectForKey:@"ImageEvidence"],@"&type=IMAGE&session=",sessionid1,@"&hash=",hash1];
        
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
            
            manager.requestSerializer =[AFHTTPRequestSerializer serializer];
            // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",@"image/.jpg",nil];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/.jpg",nil];
            //  NSDictionary *parameters = @{@"SessionId": sessionid1, @"Mobile": mobilenumber1, @"Hash" : hash1};
            
            NSString *imagename = [report objectForKey:@"ImageEvidence"];

        
            [manager GET:url parameters:nil
                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                     NSLog(@"Response: %@", responseObject);
                     
                     
                     
//                     CGRect rect = CGRectMake(0,0,100,100);
//                     UIGraphicsBeginImageContext( rect.size );
//                     [responseObject drawInRect:rect];
//                     UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//                     UIGraphicsEndImageContext();
//                     
//                     NSData *imageData = UIImagePNGRepresentation(picture1);
//                     UIImage *img=[UIImage imageWithData:imageData];
                     
                     
                     
                     NSLog(@"Image added to cache: %@", imagename);
                     if(responseObject ==nil){}
                     else{[imageCache setObject:responseObject forKey:imagename];
                     self.reporttableview.reloadData;
                         
                        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.5];
                    
                     }
                     
                     
                 } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
            
            i++;
            
        }
   
    }
 
}
- (void) loadnhaiimages
{
    int i=0;
    
    if([reportlist count] >0)
    {
        while([reportlist count] >0 && [reportlist count] >i){
            
            NSDictionary *report = [reportlist objectAtIndex:i];
            
            [self randomizeString];
            [self hashed_string];
            
            mobilenumber1 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"https://nhtis.org/api/ver1/ImsDft?mobile=",mobilenumber1,@"&evidence=",[report objectForKey:@"NhaiEvidence"],@"&type=IMAGE&session=",sessionid1,@"&hash=",hash1];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
            
            manager.requestSerializer =[AFHTTPRequestSerializer serializer];
            // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",@"image/.jpg",nil];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/.jpg",nil];
            //  NSDictionary *parameters = @{@"SessionId": sessionid1, @"Mobile": mobilenumber1, @"Hash" : hash1};
            
            if (![[report objectForKey:@"NhaiEvidence"] containsString:@""]) {
                
            
            NSString *imagename = [report objectForKey:@"NhaiEvidence"];
            
            
            [manager GET:url parameters:nil
                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                     NSLog(@"Response: %@", responseObject);
                     
                     
                     
                     //                     CGRect rect = CGRectMake(0,0,100,100);
                     //                     UIGraphicsBeginImageContext( rect.size );
                     //                     [responseObject drawInRect:rect];
                     //                     UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
                     //                     UIGraphicsEndImageContext();
                     //
                     //                     NSData *imageData = UIImagePNGRepresentation(picture1);
                     //                     UIImage *img=[UIImage imageWithData:imageData];
                     
                     
                     
                     NSLog(@"NHaiImage added to cache: %@", imagename);
                     if(responseObject ==nil){}
                     else{[nhaiCache setObject:responseObject forKey:imagename];
                         self.reporttableview.reloadData;
                         
                         [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.5];
                         
                     }
                     
                     
                 } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
            
            i++;
            
        }
        else
        {
            i++;
        }
    }
    }
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

- (void) loadreports
{
    [self randomizeString];
    [self hashed_string];
    
    mobilenumber1 = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    
    
    alert = [[UIAlertView alloc] initWithTitle:@"Loading Reports\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil]; //display without any btns
    
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    
    indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    indicator.color = [UIColor blueColor];
    
    //indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height/2);
    [indicator startAnimating];
    [alert setValue:indicator forKey:@"accessoryView"];
    [indicator setHidden:NO];
    [alert show];

    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
    NSString *url = @"https://nhtis.org/api/ver1/GfdSC";
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",nil];
    
    NSDictionary *parameters = @{@"SessionId": sessionid1, @"Mobile": mobilenumber1, @"Hash" : hash1};
    
    [manager POST:url parameters:parameters
          success:^(NSURLSessionDataTask *operation, id responseObject) {
              NSLog(@"Response: %@", responseObject);
              
       //       [indicator stopAnimating];
       //       [indicator setHidden:YES];
//              ;

             noofreports = [responseObject count];
              
              
              
          //   [self.reportedcount setText: [@(noofreports) stringValue]];
              
              reportlist = responseObject;
              allreportlist = responseObject;
              
              if(loadcount==0){
              
                  NSInteger f= 0;
                  
                  while(f<[reportlist count])
                  {
                       NSDictionary *report = [reportlist objectAtIndex:f];
                      
                      if([[report objectForKey:@"Status"] isEqualToString:@"Resolved"])
                      {
                          
                          rescount++;
                      }
                      
                      else if([[report objectForKey:@"Status"] isEqualToString:@"Reported"])
                      {
                          repcount++;
                      }
                      
                      else if([[report objectForKey:@"Status"] isEqualToString:@"Assigned"])
                      {
                          asscount++;
                      }
                      else
                      {
                          notcount++;
                      }
                      
                      f++;

                      
                  }
                  
                  loadcount=1;
                  
                  [_segmentControlCount setTitle:[@(repcount) stringValue] forSegmentAtIndex:0];
                  [_segmentControlCount setTitle:[@(rescount) stringValue] forSegmentAtIndex:1];
                  [_segmentControlCount setTitle:[@(asscount) stringValue] forSegmentAtIndex:2];
                  [_segmentControlCount setTitle:[@(notcount) stringValue] forSegmentAtIndex:3];
                  [_segmentControlCount setTitle:[@(noofreports) stringValue] forSegmentAtIndex:4];

                  
//                  [self.reportedcount setText: [@(repcount) stringValue]];
//                  
//                  [self.resolvedcount setText: [@(rescount) stringValue]];
//                  
//                  [self.assignedcount setText: [@(asscount) stringValue]];
//                  
//                  [self.notacceptedcount setText: [@(notcount) stringValue]];

                  
                  }
              
              
             [self loadimages];
              [self loadnhaiimages];
              
              
          } failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [indicator stopAnimating];
          }];

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
    
    sessionid1 = output;
}

- (void)hashed_string
{
    const char *cstr = [salt1 cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:salt1.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    hash1=output;
}
- (IBAction)segmentControlClicked:(id)sender {
    
    NSString* filter = @"%K CONTAINS[cd] %@";
  

    if (_segmentControl.selectedSegmentIndex == 0) {
        
        if(currentSegment == (int)_segmentControl.selectedSegmentIndex && currentSegment)
        {
            reportlist = allreportlist;
        }
        else
        {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"Status", @"Reported"];
            
            reportlist = [allreportlist filteredArrayUsingPredicate:predicate];
            currentSegment =(int) _segmentControl.selectedSegmentIndex;

        }
    
    }
    else if(_segmentControl.selectedSegmentIndex == 1)
    {
        
        if(currentSegment == _segmentControl.selectedSegmentIndex)
        {
            reportlist = allreportlist;

        }
        else
        {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"Status", @"Resolved"];
            
            reportlist = [allreportlist filteredArrayUsingPredicate:predicate];
            currentSegment = (int)_segmentControl.selectedSegmentIndex;

        }
    }
    else if(_segmentControl.selectedSegmentIndex == 2)
    {
        
        if(currentSegment == _segmentControl.selectedSegmentIndex)
        {
            reportlist = allreportlist;

        }
        else
        {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"Status", @"Assigned"];
            
            reportlist = [allreportlist filteredArrayUsingPredicate:predicate];
            currentSegment = (int)_segmentControl.selectedSegmentIndex;

        }
    }
    else if(_segmentControl.selectedSegmentIndex == 3)
    {
        
        if(currentSegment == _segmentControl.selectedSegmentIndex)
        {
            reportlist = allreportlist;

        }
        else
        {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"Status", @"Rejected"];
            
            reportlist = [allreportlist filteredArrayUsingPredicate:predicate];
            currentSegment = (int)_segmentControl.selectedSegmentIndex;

        }
    }
    else
    {
        reportlist = allreportlist;
        currentSegment = (int)_segmentControl.selectedSegmentIndex;


    }
    
    [_reporttableview reloadData];
}


@end
