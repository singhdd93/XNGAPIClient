#import "XNGAPIObjectAward.h"

@implementation XNGAPIObjectAward

-(instancetype)initWithName:(NSString*)awardName dateAwarded:(NSDate*)awardDate url:(NSURL*)awardURL {
    self = [super init];
    if (self) {
        self.name = awardName;
        self.date = awardDate;
        self.url = awardURL;
    }
    return self;
}

@end
