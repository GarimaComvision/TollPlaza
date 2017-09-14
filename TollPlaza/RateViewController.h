//
//  RateViewController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 11/08/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface RateViewController : UIViewController <RateViewDelegate>
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
