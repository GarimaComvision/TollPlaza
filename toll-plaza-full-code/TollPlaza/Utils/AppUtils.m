//
//  AppUtils.m
//  OutFit
//
//  Created by Ravi Rajan on 2/19/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import "AppUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
#import "AppSinglton.h"

@interface AppUtils ()
@end

@implementation AppUtils


+(UIAlertController *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    return alertController;
}


+(void)setValueInLocalDb:(NSString*)value forKey:(NSString*)key {
    NSUserDefaults *userDb = [NSUserDefaults standardUserDefaults];
    [userDb setObject:value forKey:key];
    [userDb synchronize];
}

+(NSString*)getValueFromLocalDbForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}



+(NSString*)getUserId {
    return [self getValueFromLocalDbForKey:@"userId"];
}

+(NSArray*)getArrayFromLocalDbForKey : (NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}



+(UIImage*)getImageFromUrlString: (NSString*)urlString{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
}




+(float)deviceHeight{
    return  [[UIScreen mainScreen] bounds].size.height;
}

+(float)deviceWidth{
    return  [[UIScreen mainScreen] bounds].size.width;
}

+(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(void)getVehiclesList{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:@"http://nhtis.org/IOS/api/ver1/vhXmy" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [[AppSinglton sharedManager] setVehiclesType:[responseObject objectForKey:@"VehicleTypes"]];
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
    }];
    
}

+ (CGSize)calculateSize:(NSString*)txtToCalculate
                ForFont:(UIFont*)font andWidth:(float)width {
    
    CGSize expectedLabelSize= CGSizeZero;
    if(txtToCalculate!=nil){
        CGSize maximumLabelSize =  CGSizeMake(width, FLT_MAX);
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:txtToCalculate attributes:@
                                             { NSFontAttributeName:font
                                             }];
        
        CGSize boundingBox = [attributedText boundingRectWithSize:maximumLabelSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size;
        expectedLabelSize = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    return expectedLabelSize;
}

/*
 {
 VehicleTypes =     (
 {
 VehicleCode = V0001;
 VehicleName = "Car/Jeep/Van";
 },
 {
 VehicleCode = V0002;
 VehicleName = LCV;
 },
 {
 VehicleCode = V0003;
 VehicleName = Truck;
 },
 {
 VehicleCode = V0004;
 VehicleName = BUS;
 },
 {
 VehicleCode = V0005;
 VehicleName = MAV;
 },
 {
 VehicleCode = V0006;
 VehicleName = OSV;
 }
 );
 }

 
 */






@end
