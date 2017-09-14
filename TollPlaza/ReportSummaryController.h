//
//  ReportSummaryController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportSummaryController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reporttableview;


@end
