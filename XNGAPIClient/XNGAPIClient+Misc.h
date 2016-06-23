#import "XNGAPIClient.h"

@interface XNGAPIClient (Misc)
- (void)getIndustriesForLanguage:(NSString *)language
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure;
@end
