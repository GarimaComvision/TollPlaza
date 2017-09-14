//
//  HttpConnectionClass.h
//  MyExpensesTab
//
//  Created by Apple on 19/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HttpConnectionClass : NSObject<NSURLConnectionDelegate> {
@private
    NSMutableData* _receivedData;
    int statusCode;
    void (^ callbackBlock)(NSString *response,int statusCode);
}

-(void) postToUrl: (NSString*) url withBody: (NSData*) body
     withCallback: (void(^) (NSString* response,int statusCode)) callback;
@end