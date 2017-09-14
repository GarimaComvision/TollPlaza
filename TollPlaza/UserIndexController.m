//
//  UserIndexController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 18/08/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "UserIndexController.h"

@interface UserIndexController ()
@property (weak, nonatomic) IBOutlet UILabel *issuenameval;
@property (weak, nonatomic) IBOutlet UILabel *issuereporteddatevalue;
@property (weak, nonatomic) IBOutlet UILabel *issueresolveddatevalue;
@property (weak, nonatomic) IBOutlet UILabel *nhairemarksvalue;
@property (weak, nonatomic) IBOutlet UIImageView *nhaievidenceimage;
@property (weak, nonatomic) IBOutlet UIScrollView *reportscrollview;
@property (weak, nonatomic) IBOutlet UILabel *ratingval;





@end

@implementation UserIndexController

NSMutableDictionary *issuethreshold;
float weightage = 0.15;

float userweightage = 0.05;
float userrating = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rateView1.notSelectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView1.halfSelectedImage = [UIImage imageNamed:@"star_highlighted.png"];
    self.rateView1.fullSelectedImage = [UIImage imageNamed:@"star_highlighted.png"];
    self.rateView1.rating = 0;
    self.rateView1.editable = YES;
    self.rateView1.maxRating = 5;
    self.rateView1.delegate = self;
    
    _reportscrollview.delegate = self;
    
    issuethreshold = [ [ NSMutableDictionary alloc] init];
    
 
    
    [issuethreshold setValue:@"30" forKey:@"poor"];
    [issuethreshold setValue:@"7" forKey:@"potholes"];
    [issuethreshold setValue:@"3" forKey:@"safety"];
    [issuethreshold setValue:@"7" forKey:@"fastag"];
    [issuethreshold setValue:@"7" forKey:@"management"];
    
    
    [self.issuenameval setText: _issuetypename];
    
     [self.issuereporteddatevalue setText: _issuereporteddatename];
    
     [self.issueresolveddatevalue setText: _issueresolveddatename];
    
     [self.nhairemarksvalue setText: _issuenhairemarks];
    
    if (_issuenhaievidence) {
        self.nhaievidenceimage.image=_issuenhaievidence;

    }

}

-(void)loadevidence
{

}


 //Add to bottom
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    self.ratingval.text = [NSString stringWithFormat:@"Rating: %d / 5", (int)rating];
    
    userrating = rating;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)subtap:(id)sender {
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Feedback Sent" message:[NSString stringWithFormat:@"You rated %d out of 5", (int)userrating] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.tag = 1;
    
    [alert show];
    
    
    
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
