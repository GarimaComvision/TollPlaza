#import "ChildCategory.h"

@implementation ChildCategory

@synthesize categoryID;
@synthesize categoryName;

//- (void)dealloc {
//
//    [categoryID release], categoryID = nil;
//    [categoryName release], categoryName = nil;
//
//    [super dealloc];
//
//}

+ (ChildCategory *)instanceFromDictionary:(NSDictionary *)aDictionary {

    ChildCategory *instance = [[ChildCategory alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"CategoryID"]) {
        [self setValue:value forKey:@"categoryID"];
    } else if ([key isEqualToString:@"CategoryName"]) {
        [self setValue:value forKey:@"categoryName"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
