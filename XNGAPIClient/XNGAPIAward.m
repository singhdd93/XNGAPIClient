#import "XNGAPIAward.h"

@implementation XNGAPIAward

-(instancetype)initWithName:(NSString *)awardName dateAwarded:(NSString *)awardYear url:(NSURL *)awardURL {
    self = [super init];
    if (self) {
        self.name = awardName;
        self.year = awardYear;
        self.url = awardURL;
    }
    return self;
}

-(NSDictionary *)awardAsDictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.name) {
        dict[@"name"] = self.name;
    }

    if (self.year) {
        dict[@"date_awarded"] = self.year;
    }

    if (self.url.absoluteString) {
        dict[@"url"] = self.url.absoluteString;
    }
    
    return [dict copy];
}

@end
