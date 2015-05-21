#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <XNGAPIClient/XNGAPI.h>

@interface XNGBookmarkTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGBookmarkTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetBookmarks {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getBookmarksForUserWithID:@"1235_erty"
                                                    userFields:@"display_name"
                                                         limit:3
                                                        offset:5
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/1235_erty/bookmarks");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"limit"]).to.equal(@"3");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"5");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testCreateABookmark {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putCreateBookmarkForUserID:@"123_uyt"
                                                        success:nil
                                                        failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/bookmarks/123_uyt");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteABookmark {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteBookmarkForUserID:@"123_uyt"
                                                     success:nil
                                                     failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/bookmarks/123_uyt");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
