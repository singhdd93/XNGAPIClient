#import <Foundation/Foundation.h>

@interface XNGAPIObjectAward : NSObject
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *year;
@property(nonatomic) NSString *url;

-(instancetype)initWithName:(NSString*)awardName dateAwarded:(NSString*)awardYear url:(NSString*)awardURL;
-(NSDictionary*)awardAsDictionary;
@end
