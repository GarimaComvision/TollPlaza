#import "SideMenuList.h"

#import "CategoryDetail.h"

@implementation SideMenuList

@synthesize categoryDetail;
@synthesize objectType;
@synthesize statusCode;
@synthesize statusMessage;

//- (void)dealloc {
//
//    [categoryDetail release], categoryDetail = nil;
//    [objectType release], objectType = nil;
//    [statusCode release], statusCode = nil;
//    [statusMessage release], statusMessage = nil;
//
//    [super dealloc];
//
//}

+ (SideMenuList *)instanceFromDictionary:(NSDictionary *)aDictionary {

    SideMenuList *instance = [[SideMenuList alloc] init];
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

    if ([key isEqualToString:@"category_detail"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CategoryDetail *populatedMember = [CategoryDetail instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.categoryDetail = myMembers;

        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"category_detail"]) {
        [self setValue:value forKey:@"categoryDetail"];
    } else if ([key isEqualToString:@"object_type"]) {
        [self setValue:value forKey:@"objectType"];
    } else if ([key isEqualToString:@"status_code"]) {
        [self setValue:value forKey:@"statusCode"];
    } else if ([key isEqualToString:@"status_message"]) {
        [self setValue:value forKey:@"statusMessage"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}



@end
