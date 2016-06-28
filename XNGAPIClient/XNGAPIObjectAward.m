#import "XNGAPIObjectAward.h"

@implementation XNGAPIObjectAward

-(instancetype)initWithName:(NSString*)awardName dateAwarded:(NSString*)awardYear url:(NSString*)awardURL {
    self = [super init];
    if (self) {
        self.name = awardName;
        self.year = awardYear;
        self.url = awardURL;
    }
    return self;
}

-(NSDictionary*)awardAsDictionary {
    return @{@"name": self.name, @"date_awarded": self.year, @"url": self.url};
}

@end
