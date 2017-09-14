//
//  GenerateReceiptController.m
//  TollPlaza
//
//  Created by Comvision on 17/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//


#import "GenerateReceiptController.h"


@interface GenerateReceiptController ()
@property (weak, nonatomic) IBOutlet UILabel *refnumlabel;
@property (weak, nonatomic) IBOutlet UILabel *vehnumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *vehtypelabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimelabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrview;
@property (weak, nonatomic) IBOutlet UILabel *counterlabel;
@property (weak, nonatomic) IBOutlet UILabel *counterlabelval;



@end


@implementation GenerateReceiptController

int count;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    count=0;
    [self genreceipt];
    [self refreshCounter];

    // Do any additional setup after loading the view.
}

- (void)refreshCounter
{
    int vvalu= 5-count;
    [self.counterlabel setText:[NSString stringWithFormat:@"QR Code will be refreshed in %@ ",@""]];
    
    [self.counterlabelval setText:[@(vvalu) stringValue]];
 [self performSelector:@selector(counter) withObject:nil afterDelay:1];
}

- (void)genreceipt
{
    [self.refnumlabel setText: _receiptrefnum];
    [self.vehnumberlabel setText: _receiptvehnum];
    [self.vehtypelabel setText: _receiptvehtype];
    [self.datetimelabel setText: _receipttransdate];
    
    NSData *plainData = [_receiptrefnum dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [plainData base64EncodedStringWithOptions:kNilOptions];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tdate = [dateFormatter dateFromString:_receipttransdate];
    
    NSString *cdate= [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *ccdate = [dateFormatter dateFromString:cdate];
  
    NSTimeInterval secs = [ccdate timeIntervalSinceDate:tdate];
    
    NSLog(@"Transaction date: %@",_receipttransdate);
    NSLog(@"Current Date: %@",cdate);
    NSLog(@"Difference in seconds: %f",secs);
    
    NSString *qstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%f",base64String,@"|",_receiptvehnum,@"|",_receiptvehtype,@"|",_receipttransdate,@"|",secs];
    
    NSData *finaldata = [qstring dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *finalqrstring = [finaldata base64EncodedStringWithOptions:kNilOptions];
    
    NSLog(@"QR String: %@",finalqrstring );
    
    NSData *stringData = [finalqrstring dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    CIImage *qrImage = qrFilter.outputImage;
    
    float scaleX = self.qrview.frame.size.width / qrImage.extent.size.width;
    float scaleY = self.qrview.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    self.qrview.image = [UIImage imageWithCIImage:qrImage
                                                 scale:[UIScreen mainScreen].scale
                                           orientation:UIImageOrientationUp];
   

}

- (void)counter
{
    if (count==5) {
        // viewController is visible
         [self genreceipt];
        count=0;
        [self refreshCounter];
       // [self performSelector:@selector(genreceipt) withObject:nil afterDelay:5];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"QR Refreshed!!!" message:@"5 second counter" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        alert.tag = 1;
//        
       // [alert show];
        
        
        
       // [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
    }
    else if (count==-1)
    {
        return;
    }    else
    {
        count++;
        [self refreshCounter];
    }
    
    
   

}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

- (IBAction)backTapped:(id)sender {
    count=-1;
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}

@end
