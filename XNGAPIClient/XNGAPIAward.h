#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNGAPIAward : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *year;
@property (nonatomic) NSURL *url;

-(instancetype)initWithName:(NSString *)awardName dateAwarded:(NSString *)awardYear url:(NSURL *)awardURL;
-(NSDictionary *)awardAsDictionary;
@end

NS_ASSUME_NONNULL_END
