//
//  PaymentDetailsController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 13/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDViewController.h"


@interface PaymentDetailsController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,LibraryPaymentStatusProtocol>

{
    UIToolbar* keyboardDoneButtonView;
    BDViewController *bdvc;
    NSArray *msg;
}

@property (nonatomic)NSString *totalamount1;
@property (nonatomic)NSString *psource;
@property (nonatomic)NSString *pdestination;
@property (nonatomic)NSArray *tolllist;
@property (strong, nonatomic)  BDViewController *bdvc;
+(BDViewController*)getBDViewController;
- (IBAction)payNowClicked:(id)sender;
-(NSString *)createJsonObject:(NSString *)serverStr;


@end
