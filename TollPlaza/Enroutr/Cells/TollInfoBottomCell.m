//
//  TollInfoBottomCell.m
//  TollPlaza
//
//  Created by Ravi Rajan on 4/15/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "TollInfoBottomCell.h"

@interface TollInfoBottomCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblHelpLineDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblEmergencyDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblContractorName;
@property (weak, nonatomic) IBOutlet UILabel *lblContractorContactDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblHighwayAdminDetails;

@end

@implementation TollInfoBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDataWithInfo :(NSDictionary*)tollDetailInfo{
    self.lblHelpLineDetails.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"HelpLineNumber"]];
    self.lblEmergencyDetails.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"EmergencyServices"]];
    self.lblContractorName.text =[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"ConcessionaireDetail"]] ;
    self.lblContractorContactDetails.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"InchargeDetail"]];
    self.lblHighwayAdminDetails.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"HighwayAdmin"]];
}

@end
