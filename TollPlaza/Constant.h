//
//  Constant.h
//  OutFit
//
//  Created by Ravi Rajan on 2/9/17.
//  Copyright © 2017 Ravi Rajan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

#define SINGLETON_FOR_CLASS(classname)\
+ (id) shared##classname {\
static dispatch_once_t pred = 0;\
static id _sharedObject = nil;\
dispatch_once(&pred, ^{\
_sharedObject = [[self alloc] init];\
});\
return _sharedObject;\
}

#define ABOUT_US_CONTENT     "The National Highways Authority of India was constituted by an act of Parliament, the National Highways Authority of India Act, 1988. It is responsible for the development, maintenance and management of National Highways entrusted to it and for matters connected or incidental thereto. NHAI enters into Concession Agreements for design, construction, operation and maintenance of highway by DBFOT Concessionaires. The Concessionaire build NH stretches and during operation and maintenance of the said stretch collects and ratains the toll (user fee). In case of streches developed on Govt. / NHAI Funds, NHAI engages OMT Concessionaire / User-Fee Collection Contractors. \n\n During operation and maintenance of tolled stretches of National Highways (NHs), the DBFOT Concessionaires/ OMT Concessionaire / User Fee Collection Contractors have been mandated to collect user fee (toll) from road users. The applicable user-fee (toll) rates for various categories of vahicles shall be displayed at the respective Toll Plaza. Toll Information System (TIS) has been devised to put in place a mechanism, whereby the road users can ascertain through public domain the exact user fee (toll) rates for a particular plaza OR a particular journey between two stations through a selected route. In addition it will also help disseminate information aboput the concessions/ discounts to local and frequent users, provision of various facilities on toll road, important telephone numbers, etc.  "//YES


#define NHAI     "National Highway Authority of India"

#define DISCLAIMER      "Disclaimer"

#define DISCLAIMER_US_CONTENT     "While the information contained in the app is periodically updated, no guarantee is given that the information provided in this app is complete, and up-to-date. Although this mobile app may include links providing direct access to other internet resources, including Web sites, NHAI/ MoRTH is not responsible for the accuracy or content of information contained in these sites, as well."


@end
