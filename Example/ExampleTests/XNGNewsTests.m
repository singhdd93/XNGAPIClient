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

@end
