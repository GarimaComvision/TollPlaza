#import "CategoryDetail.h"

#import "ChildCategory.h"

@implementation CategoryDetail

@synthesize categoryID;
@synthesize categoryName;
@synthesize childCategories;

//- (void)dealloc {
//
//    [categoryID release], categoryID = nil;
//    [categoryName release], categoryName = nil;
//    [childCategories release], childCategories = nil;
//
//    [super dealloc];
//
//}

+ (CategoryDetail *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CategoryDetail *instance = [[CategoryDetail alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"Child_Categories"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                ChildCategory *populatedMember = [ChildCategory instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.childCategories = myMembers;

        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"CategoryID"]) {
        [self setValue:value forKey:@"categoryID"];
    } else if ([key isEqualToString:@"CategoryName"]) {
        [self setValue:value forKey:@"categoryName"];
    } else if ([key isEqualToString:@"Child_Categories"]) {
        [self setValue:value forKey:@"childCategories"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
