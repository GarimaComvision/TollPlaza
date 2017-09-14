//
//  ReportViewCell.h
//  TollPlaza
//
//  Created by Comvision on 28/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reportnumber;
@property (weak, nonatomic) IBOutlet UILabel *issuetypelabel;
@property (weak, nonatomic) IBOutlet UILabel *reporteddatelabel;
@property (weak, nonatomic) IBOutlet UIImageView *evidenceimageview;
@property (weak, nonatomic) IBOutlet UILabel *locationaddresslabel;
@property (weak, nonatomic) IBOutlet UILabel *commentslabel;
@property (weak, nonatomic) IBOutlet UILabel *resolveddatelabel;
@property (weak, nonatomic) IBOutlet UILabel *reportstatuslabel;

@end
