//
//  TollInfoTableInnerCell.m
//  TollPlaza
//
//  Created by Ravi Rajan on 4/15/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "TollInfoTableInnerCell.h"

@interface TollInfoTableInnerCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblSingleJourneyPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblReturnJourneyPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthlyPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCommercialPrice;

@end

@implementation TollInfoTableInnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDataWithInfo :(NSDictionary*)tollDetailInfo{
    if([[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]] isEqualToString:@""])
        self.lblVehicleInfo.text = @"N.A";
    else
        self.lblVehicleInfo.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"VehicleType"]];
    
    if([[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]] isEqualToString:@""])
        self.lblSingleJourneyPrice.text = @"N.A";
    else
        self.lblSingleJourneyPrice.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"SingleJourney"]];
    
    if([[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]] isEqualToString:@""])
        self.lblReturnJourneyPrice.text = @"N.A";
    else
        self.lblReturnJourneyPrice.text =[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"ReturnJourney"]] ;
    
    if([[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]] isEqualToString:@""])
        self.lblMonthlyPrice.text = @"N.A";
    else
        self.lblMonthlyPrice.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"MonthlyPass"]];
    
    if([[NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]] isEqualToString:@""])
        self.lblCommercialPrice.text = @"N.A";
    else
        self.lblCommercialPrice.text = [NSString stringWithFormat:@"%@", [tollDetailInfo valueForKey:@"CommercialVehicle"]];
    
}

@end
