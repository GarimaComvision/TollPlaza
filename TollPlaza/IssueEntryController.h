//
//  IssueEntryController.h
//  TollPlaza
//
//  Created by Ramneek Sharma on 19/06/17.
//  Copyright © 2017 Harendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface IssueEntryController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UITextViewDelegate>
@property (strong)NSString *typeofIssue;
@property (nonatomic)CLLocationCoordinate2D customlocation;
@end
