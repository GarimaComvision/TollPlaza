//
//  IssueEntryController.m
//  TollPlaza
//
//  Created by Comvision on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "IssueEntryController.h"
#import "SelectIssueController.h"
#import "LocationOnMapController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppSinglton.h"
#import <GoogleMaps/GMSAddress.h>
#import <AFNetworking/AFNetworking.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppUtils.h"


@interface IssueEntryController ()
@property (weak, nonatomic) IBOutlet UITextField *issuetype;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UIScrollView *thumbsview;
@property (weak, nonatomic) IBOutlet UITextField *issuelocation;

@end




@implementation IssueEntryController

int xOffset;
int i;

NSString *salt = @"<RSAKeyValue><Modulus>nDbi8tghVbW+w1S0heTUm05ve2ur38pWCP5l7AzcpDRuIzLEAKqRop6GKAfFmoHUJQ3WYDLYWxpaFD66DrtrjEAVWkcbuRvTFdVl+/QV2mZ+7eqAJsgScp7R9uELnnewEwZ8fShtAfboLoPIGGWoAuD8XLU8Tf0Yd4WLR/orH30=</Modulus><Exponent>AQAB</Exponent><P>2MzQHeuZdM6jhCKwkEh9YgshgokTaARXS1iit7Bnh5nz44IxhP2U+6NhZUzs4g0eZ1eF4SeLJmGJlHciASHcZw==</P><Q>uHWzMsqfoCMB4E3AWErU7BaFVc8jv2V9MF8dOPdhHi5+q9+NMFKFKLyDkw05Peu/uH4WIjVRQ67H3cg3oQO2ew==</Q><DP>wwGvLUqPFL8N27vsP0vE5ByI/sZXm1dUQeSvMDTPWuyCsKCZ9Dq3+ISkBZ9k74vHTkMunDCafGJ9gvqJrqULfw==</DP><DQ>NDo/LtZoM/M1iMj6+QTXHLGTtyQbPwoBVDzaDVMd0Gnhu9BkLZZv1YTqzCwmVP33Hsm0gqMOC1flh0o1VgWzGQ==</DQ><InverseQ>HEaO6q+67rUtbJLXzgxo+U9iEmf3gL1Gl9pSN0diPUjRWZNxiEEPcGj2+YLIVdSfllT8PBnp4YnqzTRab1F+Nw==</InverseQ><D>BUmZpUa/MMVVBbaMb7XGFZsAcDq90ISjzzNYTtMoZy1YP+bcKBZIlY5eaVaRj9yndMctoAfWxbHCXuZ/+EWTMgMfo0cnrD9PX9Icw8cGWKl+dW/hnA8wBCHSJX/MEi3EEO0ABVnrkEXg2rzdfqtw0gmbbOm/fgkI9i+iPnyKWG8=</D></RSAKeyValue>";

NSString *hash=@"";
NSString *sessionid=@"";
NSString *mobilenumber=@"";
NSString *locationcode=@"";
NSString *locationaddress=@"";
NSMutableString *images;
NSMutableString *videos;
NSString *issuetype=@"";

NSMutableArray *imagelist ;
NSMutableArray *videolist ;

CLLocationCoordinate2D coordinate={0,0};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    i=0;
    NSString *name = _issuelocation.text;
    if([name isEqual:@""]&& _customlocation.latitude==0){
        [self setPreferenceForView];
    }
    else if (_customlocation.latitude!=0)
    {
        [self setPreferenceForView1];
    }
    
    [self.issuetype setText: _typeofIssue];
    
    _comments.delegate = self;
  _thumbsview.delegate = self;
    xOffset = 0;
    
    imagelist =  [[NSMutableArray alloc] init];
    videolist =  [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)setPreferenceForView {
    
        double currentLatitude = [[[AppSinglton sharedManager] getLatitude] doubleValue];
        double currentLongitude = [[[AppSinglton sharedManager] getLoongitude] doubleValue];
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLatitude
//                                                                longitude:currentLongitude
//                                                                     zoom:10];
    
    coordinate.latitude=currentLatitude;
    coordinate.longitude=currentLongitude;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(currentLatitude, currentLongitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:",response);
                    GMSAddress* addressObj =response.results[0];
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            NSString *addr = @"";
           addr= [NSString stringWithFormat:@"%@%@%@",addressObj.lines[0],@",",addressObj.lines[1]];
            locationaddress = addr;
             [self.issuelocation setText: addr ];
        }
        
    }];
    
//        [_mapView setCamera:camera];
//        _mapView.myLocationEnabled = YES;
    
}

-(void)setPreferenceForView1 {
    
//    double currentLatitude = [[[AppSinglton sharedManager] getLatitude] doubleValue];
//    double currentLongitude = [[[AppSinglton sharedManager] getLoongitude] doubleValue];
    //        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLatitude
    //                                                                longitude:currentLongitude
    //                                                                     zoom:10];
    
    coordinate=_customlocation;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(_customlocation.latitude, _customlocation.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:",response);
        GMSAddress* addressObj =response.results[0];
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            NSString *addr = @"";
            addr= [NSString stringWithFormat:@"%@%@%@",addressObj.lines[0],@",",addressObj.lines[1]];
            locationaddress = addr;
            [self.issuelocation setText: addr ];
        }
        
    }];
    
    //        [_mapView setCamera:camera];
    //        _mapView.myLocationEnabled = YES;
    
}


- (IBAction)plusTapped:(id)sender {
    
    
    LocationOnMapController *selectedViewController;
    selectedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LocationOnMapController"];
    selectedViewController.typeofIssue1= _typeofIssue;
    selectedViewController.customlocation1=coordinate;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:selectedViewController animated:YES];
    
}

- (IBAction)galleryTapped:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (IBAction)cameraTapped:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
   // [picker release];
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    UIImageView *imageview = [[UIImageView alloc]
//                              initWithFrame:CGRectMake(xOffset, 0, 100, 100)];
//
//        [imageview setImage:image];
//    [imageview setContentMode:UIViewContentModeScaleAspectFit];
//    [self.thumbsview addSubview:imageview];
//    xOffset  = xOffset +110;
//    _thumbsview.contentSize = CGSizeMake(xOffset,100);
//    [self dismissModalViewControllerAnimated:YES];
//}

- (IBAction)videoTapped:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerCameraCaptureModeVideo;
    picker.delegate = self;
    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
    [picker setVideoMaximumDuration:10.0f];
    picker.mediaTypes = mediaTypes;
    [self presentModalViewController:picker animated:YES];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker

        didFinishPickingMediaWithInfo :(NSDictionary *)info
                 {
                     if(info[UIImagePickerControllerMediaType]==kUTTypeImage)
                     {
                         UIImageView *imageview = [[UIImageView alloc]
                                                   initWithFrame:CGRectMake(xOffset, 0, 100, 100)];
                         NSURL *chosenimage = [info objectForKey:UIImagePickerControllerReferenceURL];
                         UIImage *image = info[UIImagePickerControllerOriginalImage];
                         [imageview setImage:image];
                         [imageview setContentMode:UIViewContentModeScaleAspectFit];
                         [self.thumbsview addSubview:imageview];
                         xOffset  = xOffset +110;
                         _thumbsview.contentSize = CGSizeMake(xOffset,100);
                         [self dismissModalViewControllerAnimated:YES];
                         
                         [self randomizeString];
                         [self hashed_string];
                         
                         mobilenumber = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
                         
                         
                         NSData *data = UIImageJPEGRepresentation(image, 100.0);
                         
                         NSData *imageData = [NSData dataWithContentsOfURL:chosenimage];
                         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                         AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
                         NSString *url = @"https://nhtis.org/api/ver1/vfgAs";
                         [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
                         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",nil];
                         [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                             
                             NSDictionary *jsonHeaders = @{
                                                           @"Content-Type"        : @"multipart/form-data",
                                                           @"Accept"              : @"multipart/form-data",
                                                           };
//                             [formData appendPartWithHeaders:jsonHeaders body:nil];
                             
                            
//                            [formData appendPartWithFileURL:chosenimage name:@"file"  error:nil];
                             
                             [formData appendPartWithFileData:data
                                                         name:@"file"
                                                     fileName:@"photoName" mimeType:@"image/jpeg"];
                             [formData appendPartWithFormData:[sessionid dataUsingEncoding:NSUTF8StringEncoding]
                                                         name:@"SessionId"];
                             
                             [formData appendPartWithFormData:[hash dataUsingEncoding:NSUTF8StringEncoding]
                                                         name:@"Hash"];
                             
                             [formData appendPartWithFormData:[ mobilenumber dataUsingEncoding:NSUTF8StringEncoding]
                                                         name:@"Mobile"];
                             
//                             [formData appendPartWithFormData:[ @"photoName" dataUsingEncoding:NSUTF8StringEncoding]
//                                                         name:@"filename"];
                             
                         } success:^(NSURLSessionDataTask *operation, id responseObject) {
                             NSLog(@"Response: %@", responseObject);
                             
                             int i=0;
                            
                             NSString *imagename = [responseObject valueForKey:@"Message"];
                                                                 //You can use them accordingly
                             NSLog(@"Image name: %@", imagename);
//                             while([imagelist count] > 0 && [imagelist count] > i)
//                             {
//                                 i++;
//                             }
                             i= [imagelist count];
                        [imagelist insertObject:imagename atIndex:i];
                             
                             NSLog(@"Image List: %@", imagelist);
                             
                             
                         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                         }];

                     }
                     else{
                       NSURL *chosenMovie1 = [info objectForKey:UIImagePickerControllerMediaURL];
                     
                     UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie1 path], nil, nil, nil);
                   
                     MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:chosenMovie1];
                     UIImage *thumbnail = [player thumbnailImageAtTime:52.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                     [player stop];
                     
    UIImageView *imageview = [[UIImageView alloc]
                              initWithFrame:CGRectMake(xOffset, 0, 100, 100)];
    
    [imageview setImage:thumbnail];
    [imageview setContentMode:UIViewContentModeScaleAspectFit];
    [self.thumbsview addSubview:imageview];
    xOffset  = xOffset +110;
    _thumbsview.contentSize = CGSizeMake(xOffset,100);
                         [self dismissModalViewControllerAnimated:YES];
                     
                     
                     [self randomizeString];
                     [self hashed_string];
                     
                     mobilenumber = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
                     
                     NSData *videoData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
                     
                     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                     AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
                     NSString *url = @"https://nhtis.org/api/ver1/gdAKt";
                     [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
                     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",nil];
                     [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         NSDictionary *jsonHeaders = @{
                                                       @"Content-Type"        : @"multipart/form-data",
                                                       @"Accept"              : @"multipart/form-data",
                                                       };
                         //                             [formData appendPartWithHeaders:jsonHeaders body:nil];
                         
                         
                         //                            [formData appendPartWithFileURL:chosenimage name:@"file"  error:nil];
                         
                         [formData appendPartWithFileData:videoData
                                                     name:@"file"
                                                 fileName:@"videoName" mimeType:@"video/mov"];
                         [formData appendPartWithFormData:[sessionid dataUsingEncoding:NSUTF8StringEncoding]
                                                     name:@"SessionId"];
                         
                         [formData appendPartWithFormData:[hash dataUsingEncoding:NSUTF8StringEncoding]
                                                     name:@"Hash"];
                         
                         [formData appendPartWithFormData:[ mobilenumber dataUsingEncoding:NSUTF8StringEncoding]
                                                     name:@"Mobile"];
                         
                         //                             [formData appendPartWithFormData:[ @"photoName" dataUsingEncoding:NSUTF8StringEncoding]
                         //                                                         name:@"filename"];
                         
                     } success:^(NSURLSessionDataTask *operation, id responseObject) {
                         NSLog(@"Response: %@", responseObject);
                         NSString *videoname = [responseObject valueForKey:@"Message"];
                         //You can use them accordingly
                         NSLog(@"Video name: %@", videoname);

                         int i=0;
                         
                         
                        
                         while([videolist count] > 0 && [videolist count] > i)
                         {
                             i++;
                         }
                         
                         [videolist insertObject:videoname atIndex:i];
                         
                         NSLog(@"Video List: %@", videolist);

                         
                         
                     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                     }];
                     }

}

- (void)hashed_string
{
    const char *cstr = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:salt.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }\
    
    hash=output;
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
    
    sessionid = output;
}


- (IBAction)submitTapped:(id)sender {
    
   locationcode = [NSString stringWithFormat:@"%f%@%f",coordinate.latitude,@",",coordinate.longitude];
    [self randomizeString];
    [self hashed_string];
    
    mobilenumber = [AppUtils getValueFromLocalDbForKey:@"userMobile"];
    issuetype = _typeofIssue;
    
    NSString *remarks = _comments.text;
    
    int j=0;
    int k=0;
    
     images = [NSMutableString stringWithCapacity:1000];
    videos = [NSMutableString stringWithCapacity:1000];
     while([imagelist count] > 0 && [imagelist count] > j) {
        [images appendFormat:@"%@%@", [imagelist objectAtIndex:j],@","];
         j++;
    }
    
    while([videolist count] > 0 && [videolist count] > k) {
        [videos appendFormat:@"%@%@", [videolist objectAtIndex:k],@","];
        k++;
    }
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; securityPolicy.allowInvalidCertificates = YES; [securityPolicy setValidatesDomainName:NO]; manager.securityPolicy = securityPolicy;
    NSString *url = @"https://nhtis.org/api/ver1/XkAER";
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"application/json",nil];
    
    NSDictionary *parameters = @{@"SessionId": sessionid, @"Mobile": mobilenumber, @"LocationCode": locationcode, @"Location": locationaddress,@"IssueType" : issuetype, @"ImageEvidence": images, @"VideoEvidence": videos,@"UserRemarks" : remarks, @"Hash" : hash};
    
    [manager POST:url parameters:parameters
     success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
         [self.navigationController popViewControllerAnimated:YES];
         
         
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    

}

@end
