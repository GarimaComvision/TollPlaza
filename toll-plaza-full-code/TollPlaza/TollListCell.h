//
//  TollListCell.h
//  TollPlaza
//
//  Created by Ravi Rajan on 4/13/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TollListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTollName;
@property (weak, nonatomic) IBOutlet UILabel *lblTollPrice;

@end
