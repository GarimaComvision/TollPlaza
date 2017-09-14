//
//  MPaymentController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 21/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MPaymentController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic)NSString *totalamount3;
@property (nonatomic)NSString *vnumber1;
@property (nonatomic)NSString *psource2;
@property (nonatomic)NSString *pdestination2;
@property (nonatomic)NSArray *tollarray2;
@end
