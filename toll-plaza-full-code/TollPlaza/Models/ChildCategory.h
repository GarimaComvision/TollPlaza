#import <Foundation/Foundation.h>

@interface ChildCategory : NSObject {

    NSNumber *categoryID;
    NSString *categoryName;

}

@property (nonatomic, copy) NSNumber *categoryID;
@property (nonatomic, copy) NSString *categoryName;

+ (ChildCategory *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
