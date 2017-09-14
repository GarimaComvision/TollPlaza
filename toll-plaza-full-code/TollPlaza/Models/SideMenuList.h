#import <Foundation/Foundation.h>

@interface SideMenuList : NSObject {

    NSArray *categoryDetail;
    NSString *objectType;
    NSString *statusCode;
    NSString *statusMessage;

}

@property (nonatomic, copy) NSArray *categoryDetail;
@property (nonatomic, copy) NSString *objectType;
@property (nonatomic, copy) NSString *statusCode;
@property (nonatomic, copy) NSString *statusMessage;

+ (SideMenuList *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
