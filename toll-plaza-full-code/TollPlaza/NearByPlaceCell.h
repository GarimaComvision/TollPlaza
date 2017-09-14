//
//  NearByPlaceCell.h
//  SwiftTest
//
//  Created by canvasm on 2/20/17.
//  Copyright © 2017 canvasm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByPlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIView *viewCallContainer;

@end
