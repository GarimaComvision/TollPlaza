//
//  AppUtils.h
//  OutFit
//
//  Created by Ravi Rajan on 2/19/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtils : NSObject{
    
}

+(UIAlertController *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString*)message;
+(void)setValueInLocalDb:(NSString*)value forKey:(NSString*)key;
+(NSString*)getValueFromLocalDbForKey:(NSString*)key;
+(NSString*)getUserId;
+(NSArray*)getArrayFromLocalDbForKey : (NSString*)key;
+(UIImage*)getImageFromUrlString: (NSString*)urlString;
+(float)deviceHeight;
+(float)deviceWidth;
+(BOOL)isValidEmail:(NSString *)checkString;
+(BOOL)isRegisteredUser;
+(void)setRegisterFlag : (BOOL)isRegister;
+(void)getVehiclesList;
+ (CGSize)calculateSize:(NSString*)txtToCalculate
                ForFont:(UIFont*)font andWidth:(float)width;
@end
