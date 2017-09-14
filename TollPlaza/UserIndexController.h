//
//  UserIndexController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 18/08/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"


@interface UserIndexController : UIViewController <UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet RateView *rateView1;

@property (nonatomic)NSDictionary *genissues;


@property (nonatomic)NSString *issuetypename;
@property (nonatomic)NSString *issuereporteddatename;
@property (nonatomic)NSString *issueresolveddatename;
@property (nonatomic)NSString *issuenhairemarks;
@property (nonatomic)UIImage *issuenhaievidence;



@end
