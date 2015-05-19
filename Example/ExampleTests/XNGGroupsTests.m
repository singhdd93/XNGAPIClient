#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <XNGAPIClient/XNGAPI.h>

@interface XNGGroupsTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGGroupsTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetUsersGroups {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getUsersGroupsWithUserID:@"1234_567"
                                                        limit:30
                                                       offset:31
                                                      orderBy:@"latest_post"
                                                   userFields:@"display_name"
                                              withLatestPosts:10
                                                      success:nil
                                                      failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/1234_567/groups");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"30");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"31");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"order_by"]).to.equal(@"latest_post");
        [query removeObjectForKey:@"order_by"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_latest_posts"]).to.equal(@"10");
        [query removeObjectForKey:@"with_latest_posts"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
