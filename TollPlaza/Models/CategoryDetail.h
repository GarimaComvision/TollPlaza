#import <Foundation/Foundation.h>

@interface CategoryDetail : NSObject {

    NSNumber *categoryID;
    NSString *categoryName;
    NSArray *childCategories;

}

@property (nonatomic, copy) NSNumber *categoryID;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSArray *childCategories;

+ (CategoryDetail *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
