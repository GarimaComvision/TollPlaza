//
//  PaymentController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 12/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface PaymentController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic)NSString *totalamount2;
@property (nonatomic)NSString *vnumber;
@property (nonatomic)NSString *psource1;
@property (nonatomic)NSString *pdestination1;
@property (nonatomic)NSArray *tollarray1;
@end
