//
//  ReceiptViewController.m
//  TollPlaza
//
//  Created by Ramneek Sharma on 18/07/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptViewCell.h"
#import "AppUtils.h"
#import "GenerateReceiptController.h"


@interface ReceiptViewController ()





@end

@implementation ReceiptViewController

ReceiptViewCell *cell2;

NSArray *receiptlist;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    receiptlist = [AppUtils getArrayFromLocalDbForKey:@"receipts"];
    
    self.receipttableview.delegate = self;
    
    self.receipttableview.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [receiptlist count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ReceiptViewCell";
    tableView.rowHeight = 80;
    
    cell2 = (ReceiptViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    
    
    if([receiptlist count] >0)
    {
        
        NSDictionary *receipt = [receiptlist objectAtIndex:indexPath.row];
        
        NSArray *sourceItems = [[receipt objectForKey:@"source"] componentsSeparatedByString:@", "];
        
        NSArray *destinationItems = [[receipt objectForKey:@"destination"] componentsSeparatedByString:@", "];
        
        NSString * actualsource = [ sourceItems objectAtIndex:0];
        
         NSString * actualdestination = [ destinationItems objectAtIndex:0];
        
        
        if (cell2 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiptViewCell" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
        }
       NSString *ref =  [receipt objectForKey:@"refnum"];
       
        if([ref  isEqual: @""]){
        cell2.traveldata.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", actualsource,@" to ",actualdestination,@" (",@"719612030001",@")"];
        }
        else
        {
            cell2.traveldata.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", actualsource,@" to ",actualdestination,@" (",ref,@")"];

        }
        cell2.paidamount.text = [NSString stringWithFormat:@"%@%@",@" ₹ ", [receipt objectForKey:@"amount"]];
        
        
        
        
    }
    
    
    
    
    return cell2;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *receipt = [receiptlist objectAtIndex:indexPath.row];
    
    NSString * ref1 = [receipt objectForKey:@"refnum"];
    
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    GenerateReceiptController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GenerateReceiptController"];
   
    if([ref1  isEqual: @""]){
        pd.receiptrefnum = @"719612030001";
    }
    else
    {
        pd.receiptrefnum = ref1;
        
    }

    pd.receiptvehnum = [receipt objectForKey:@"vehnum"];
    pd.receipttransdate = [receipt objectForKey:@"transdate"];
    pd.receiptvehtype = [receipt objectForKey:@"vehclass"];
    
    [self.navigationController pushViewController:pd animated:YES];
}


@end
