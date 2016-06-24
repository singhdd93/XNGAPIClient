#import <Foundation/Foundation.h>

@interface XNGAPIObjectAward : NSObject
@property(nonatomic) NSString *name;
@property(nonatomic) NSDate *date;
@property(nonatomic) NSURL *url;

-(instancetype)initWithName:(NSString*)awardName dateAwarded:(NSDate*)awardDate url:(NSURL*)awardURL;
-(NSDictionary*)awardAsDictionary;
@end
