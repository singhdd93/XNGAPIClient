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

- (void)testFindGroups {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getFindGroupsWithKeywords:@"developers,ios"
                                                         limit:10
                                                        offset:21
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/find");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"21");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"keywords"]).to.equal(@"developers%2Cios");
        [query removeObjectForKey:@"keywords"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetForumsWithGroupID {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getForumsForGroupWithGroupID:@"567_890"
                                                            limit:3
                                                           offset:5
                                                          success:nil
                                                          failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/567_890/forums");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"3");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"5");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetForumsPosts {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getPostsForForumWithForumID:@"345"
                                                  excludeContent:YES
                                                      userFields:@"display_name"
                                                           limit:10
                                                          offset:11
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/345/posts");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"11");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"exclude_content"]).to.equal(@"1");
        [query removeObjectForKey:@"exclude_content"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetPostInForum {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getGroupPostWithPostID:@"345"
                                                 userFields:@"display_name"
                                                    success:nil
                                                    failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/posts/345");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetGroupsPosts {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getPostsForGroupWithGroupID:@"987"
                                                  excludeContent:YES
                                                      userFields:@"display_name"
                                                           limit:4
                                                          offset:5
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/987/posts");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"4");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"5");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"exclude_content"]).to.equal(@"1");
        [query removeObjectForKey:@"exclude_content"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetLikesForPost {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getLikesForPostWithPostID:@"123"
                                                    userFields:@"display_name"
                                                         limit:9
                                                        offset:8
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/posts/123/likes");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"9");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"8");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testLikeAPost {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putLikeAPostWithPostID:@"789"
                                                    success:nil
                                                    failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/posts/789/like");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUnlikeAPost {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteUnlikeAPostWithPostID:@"789"
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/posts/789/like");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetCommentsForPost {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getCommentsOfPostWithPostID:@"654"
                                                   sortDirection:@"asc"
                                                      userFields:@"display_name"
                                                           limit:4
                                                          offset:8
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/groups/forums/posts/654/comments");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"sort_direction"]).to.equal(@"asc");
        [query removeObjectForKey:@"sort_direction"];
        expect([query valueForKey:@"limit"]).to.equal(@"4");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"8");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
