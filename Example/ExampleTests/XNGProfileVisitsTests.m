#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <XNGAPIClient/XNGAPI.h>

@interface XNGProfileVisitsTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGProfileVisitsTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetVisits {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getVisitsWithLimit:0
                                                  offset:0
                                                   since:nil
                                               stripHTML:NO
                                                 success:nil
                                                 failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/visits");
         expect(request.HTTPMethod).to.equal(@"GET");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetVisitsWithParameters {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getVisitsWithLimit:20
                                                  offset:40
                                                   since:@"some_date"
                                               stripHTML:YES
                                                 success:nil
                                                 failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/visits");
         expect(request.HTTPMethod).to.equal(@"GET");

         [self.testHelper removeOAuthParametersInQueryDict:query];
         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"strip_html"]).to.equal(@"true");
         [query removeObjectForKey:@"strip_html"];
         expect([query valueForKey:@"since"]).to.equal(@"some_date");
         [query removeObjectForKey:@"since"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testReportProfileVisit {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postReportProfileVisitForUserID:@"1"
                                                              success:nil
                                                              failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/visits");
         expect(request.HTTPMethod).to.equal(@"POST");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testReportProfileVisitResponse {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://api.xing.com/v1/users/1/visits"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSData *responseData = [@"The profile visit was created successfully." dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:nil];
    }];

    __block BOOL blockReached;
    [[XNGAPIClient sharedClient] postReportProfileVisitForUserID:@"1" success:^(id JSON) {
        expect(JSON).to.beNil();
        blockReached = YES;
    } failure:^(NSError *error) {
        expect(YES).to.beFalsy();
        blockReached = YES;
    }];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeInterval:0.2 sinceDate:[NSDate date]]];
    expect(blockReached).to.beTruthy();
}

@end
