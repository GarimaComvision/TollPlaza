//
//  ReceiptViewController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 18/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *receipttableview;


@end
