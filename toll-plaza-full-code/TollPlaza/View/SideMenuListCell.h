//
//  SideMenuListCell.h
//  fernsnpetals
//
//  Created by Aditya Aggarwal on 27/01/15.
//  Copyright (c) 2015 FnP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCategory;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *lblCatName;
@end
