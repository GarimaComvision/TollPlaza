//
//  TollInfoUpperCell.m
//  TollPlaza
//
//  Created by Ravi Rajan on 4/15/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "TollInfoUpperCell.h"

@interface TollInfoUpperCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTollName;
@property (weak, nonatomic) IBOutlet UILabel *lblTollDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTollStrech;
@property (weak, nonatomic) IBOutlet UILabel *lblTollState;
@property (weak, nonatomic) IBOutlet UILabel *lblTollLength;
@property (weak, nonatomic) IBOutlet UILabel *lblTollValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTollEffectiveDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTollEffectDateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTollRevisionDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTollRevisionDateValue;

@end

@implementation TollInfoUpperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDataWithInfo :(NSDictionary*)tollDetailInfo{
    
    self.lblTollName.text = [tollDetailInfo valueForKey:@"TollName"];
    self.lblTollDistance.text = [NSString stringWithFormat:@"%@ - %@ in %@", [tollDetailInfo valueForKey:@"TollLocation"],[tollDetailInfo valueForKey:@"TollNH"],[tollDetailInfo valueForKey:@"TollState"]];
    self.lblTollState.text = [tollDetailInfo valueForKey:@"Stretch"];
    self.lblTollValue.text = [tollDetailInfo valueForKey:@"TollableLength"];
    self.lblTollEffectDateValue.text = [tollDetailInfo valueForKey:@"FeeEffectiveDate"];
    self.lblTollRevisionDateValue.text = [tollDetailInfo valueForKey:@"DueDate"];
}
@end
