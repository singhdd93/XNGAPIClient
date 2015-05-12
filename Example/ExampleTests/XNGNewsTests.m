#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPIClient+News.h"
#import <XNGAPIClient/XNGAPI.h>

@interface XNGNewsTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGNewsTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetPage {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getNewsPageForNewsPageID:@"1234"
                                                      success:nil
                                                      failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/pages/1234");
        expect(request.HTTPMethod).to.equal(@"GET");

        [self.testHelper removeOAuthParametersInQueryDict:query];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetArticles {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getArticlesForNewPageID:@"12"
                                                       limit:12
                                                      offset:24
                                                     success:nil
                                                     failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/pages/12/articles");
        expect(request.HTTPMethod).to.equal(@"GET");

        [self.testHelper removeOAuthParametersInQueryDict:query];

        expect([query valueForKey:@"limit"]).to.equal(@"12");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"24");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getArticleForArticleID:@"456"
                                                    success:nil
                                                    failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/456");
        expect(request.HTTPMethod).to.equal(@"GET");

        [self.testHelper removeOAuthParametersInQueryDict:query];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateArticleForArticleID:@"654"
                                                          version:@"v2"
                                                      description:@"This is my description"
                                                         imageURL:@"http://www.contentamp.com/wp-content/uploads/2013/04/meme7.jpg"
                                                 introductoryText:@"Nice article about Servers"
                                                      publishedAt:@"2015-05-11T13:40:26+02:00"
                                                        sourceURL:@"https://xing.com"
                                                            title:@"Awesome title too"
                                                          success:nil
                                                          failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/654");
        expect(request.HTTPMethod).to.equal(@"PUT");

        [self.testHelper removeOAuthParametersInQueryDict:query];

        expect([query allKeys]).to.haveCountOf(0);

        expect([body valueForKey:@"version"]).to.equal(@"v2");
        [body removeObjectForKey:@"version"];
        expect([body valueForKey:@"description"]).to.equal(@"This%20is%20my%20description");
        [body removeObjectForKey:@"description"];
        expect([body valueForKey:@"image_url"]).to.equal(@"http%3A%2F%2Fwww.contentamp.com%2Fwp-content%2Fuploads%2F2013%2F04%2Fmeme7.jpg");
        [body removeObjectForKey:@"image_url"];
        expect([body valueForKey:@"introductory_text"]).to.equal(@"Nice%20article%20about%20Servers");
        [body removeObjectForKey:@"introductory_text"];
        expect([body valueForKey:@"published_at"]).to.equal(@"2015-05-11T13%3A40%3A26%2B02%3A00");
        [body removeObjectForKey:@"published_at"];
        expect([body valueForKey:@"source_url"]).to.equal(@"https%3A%2F%2Fxing.com");
        [body removeObjectForKey:@"source_url"];
        expect([body valueForKey:@"title"]).to.equal(@"Awesome%20title%20too");
        [body removeObjectForKey:@"title"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteArticleForArticleID:@"234"
                                                       version:@"43"
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/234");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        [self.testHelper removeOAuthParametersInQueryDict:query];

        expect([query valueForKey:@"version"]).to.equal(@"43");
        [query removeObjectForKey:@"version"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEditableArticles {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEditablePagesWithLimit:123
                                                        offset:456
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/news/pages/editable");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"123");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"456");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetFollowedPages {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getFollowedPagesWithLimit:456
                                                        offset:789
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/news/pages/following");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"456");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"789");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testLikeAnArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putLikeArticleWithArticleID:@"456uq"
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/456uq/like");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUnlikeAnArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteUnlikeArticleWithArticleID:@"789uq"
                                                              success:nil
                                                              failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/789uq/like");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetLikesForArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getLikesForArticleWithArticleID:@"1234"
                                                          userFields:@"id,display_name"
                                                               limit:45
                                                              offset:55
                                                             success:nil
                                                             failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/articles/1234/likes");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cdisplay_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"limit"]).to.equal(@"45");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"55");
        [query removeObjectForKey:@"offset"];
        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testCreateArticle {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] postCreateArticleWithPageID:@"567"
                                                       sourceURL:@"http://www.piedpiper.com/blog/2015/5/11/pied-piper-pic-decisions-decisions"
                                                           title:@"Pied Piper Pic: Decisions, Decisions..."
                                                     description:@"New offices or servers? It takes big men (and women!) to make big choices like this."
                                                        imageURL:@"http://static1.squarespace.com/static/551d64a8e4b0eeef9d4c5e6e/t/554ce788e4b0c0cf87dc69b4/1431103368623/?format=1500w"
                                                introductoryText:@"New offices or servers?"
                                                     publishedAt:@"2015-05-11T13:40:26+02:00"
                                                          source:@"Pied Piper"
                                                         success:nil
                                                         failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/news/pages/567/articles");
        expect(request.HTTPMethod).to.equal(@"POST");

        expect([query allKeys]).to.haveCountOf(0);

        expect([body valueForKey:@"source_url"]).to.equal(@"http%3A%2F%2Fwww.piedpiper.com%2Fblog%2F2015%2F5%2F11%2Fpied-piper-pic-decisions-decisions");
        [body removeObjectForKey:@"source_url"];
        expect([body valueForKey:@"title"]).to.equal(@"Pied%20Piper%20Pic%3A%20Decisions%2C%20Decisions...");
        [body removeObjectForKey:@"title"];
        expect([body valueForKey:@"description"]).to.equal(@"New%20offices%20or%20servers%3F%20It%20takes%20big%20men%20%28and%20women%21%29%20to%20make%20big%20choices%20like%20this.");
        [body removeObjectForKey:@"description"];
        expect([body valueForKey:@"image_url"]).to.equal(@"http%3A%2F%2Fstatic1.squarespace.com%2Fstatic%2F551d64a8e4b0eeef9d4c5e6e%2Ft%2F554ce788e4b0c0cf87dc69b4%2F1431103368623%2F%3Fformat%3D1500w");
        [body removeObjectForKey:@"image_url"];
        expect([body valueForKey:@"introductory_text"]).to.equal(@"New%20offices%20or%20servers%3F");
        [body removeObjectForKey:@"introductory_text"];
        expect([body valueForKey:@"published_at"]).to.equal(@"2015-05-11T13%3A40%3A26%2B02%3A00");
        [body removeObjectForKey:@"published_at"];
        expect([body valueForKey:@"source"]).to.equal(@"Pied%20Piper");
        [body removeObjectForKey:@"source"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
