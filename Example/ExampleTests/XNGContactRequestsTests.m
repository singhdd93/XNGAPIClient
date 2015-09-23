#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <XNGAPIClient/XNGAPI.h>

@interface XNGContactRequestsTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGContactRequestsTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetContactRequests {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactRequestsWithLimit:0
                                                           offset:0
                                                       userFields:nil
                                                          success:nil
                                                          failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
         expect(request.HTTPMethod).to.equal(@"GET");

         [self.testHelper removeOAuthParametersInQueryDict:query];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetContactRequestsWithLimitAndOffset {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactRequestsWithLimit:20
                                                           offset:40
                                                       userFields:nil
                                                          success:nil
                                                          failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
         expect(request.HTTPMethod).to.equal(@"GET");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetSentContactRequestsWithLimitAndOffset {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getSentContactRequestsWithLimit:20
                                                               offset:40
                                                              success:nil
                                                              failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests/sent");
         expect(request.HTTPMethod).to.equal(@"GET");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostCreateContactRequest {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postCreateContactRequestToUserWithID:@"2"
                                                                   message:@"blalup"
                                                                   success:nil
                                                                   failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/2/contact_requests");
         expect(request.HTTPMethod).to.equal(@"POST");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"message"]).to.equal(@"blalup");
         [body removeObjectForKey:@"message"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostCreateContactRequestResponse {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://api.xing.com/v1/users/2/contact_requests"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSData *responseData = [@"Contact request was successfully sent" dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:nil];
    }];

    __block BOOL blockReached;
    [[XNGAPIClient sharedClient] postCreateContactRequestToUserWithID:@"2"
                                                              message:@"blalup"
                                                              success:^(id JSON) {
                                                                  expect(JSON).to.beNil();
                                                                  blockReached = YES;
                                                              } failure:^(NSError *error) {
                                                                  expect(YES).to.beFalsy();
                                                                  blockReached = YES;
                                                              }];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeInterval:0.2 sinceDate:[NSDate date]]];
    expect(blockReached).to.beTruthy();
}

- (void)testPutConfirmContactRequest {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] putConfirmContactRequestForUserID:@"1"
                                                               senderID:@"2"
                                                                success:nil
                                                                failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2/accept");
         expect(request.HTTPMethod).to.equal(@"PUT");

         [self.testHelper removeOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testDeleteDeclineContactRequest {
    [self.testHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteDeclineContactRequestForUserID:@"1"
                                                                  senderID:@"2"
                                                                   success:nil
                                                                   failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"api.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
