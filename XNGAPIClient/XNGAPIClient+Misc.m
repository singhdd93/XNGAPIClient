#import "XNGAPIClient+Misc.h"

@implementation XNGAPIClient (Misc)

- (void)getIndustriesForLanguage:(NSString *)language
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters;
    if (language.length > 0) {
        parameters = @{@"languages" : language};
    }
    NSString *path = @"v1/misc/industries";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

@end
