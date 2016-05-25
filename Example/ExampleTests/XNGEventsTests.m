#import <XCTest/XCTest.h>
#import <XNGAPIClient/XNGAPI.h>
#import "XNGTestHelper.h"

@interface XNGEventsTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGEventsTests

- (void)setUp {
    [super setUp];
    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testGetEvent {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventForID:@"42_abcd"
                                        userFields:@"id,page_name"
                                 participantsLimit:10
                                           success:nil
                                           failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/42_abcd");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_participants"]).to.equal(@"10");
        [query removeObjectForKey:@"with_participants"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEventParticipants {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventParticipantsForID:@"42_abcd"
                                                         limit:10
                                                        offset:20
                                                 participation:@"maybe"
                                                    userFields:@"id,page_name"
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/42_abcd/guests");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"20");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"participations"]).to.equal(@"maybe");
        [query removeObjectForKey:@"participations"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEventSearchResults {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventSearchResultsForString:@"waldo"
                                                              limit:10
                                                           location:@"51.1084,13.6737,100"
                                                             offset:20
                                                         userFields:@"id,page_name"
                                                  participantsLimit:10
                                                            success:nil
                                                            failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/find");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"keywords"]).to.equal(@"waldo");
        [query removeObjectForKey:@"keywords"];
        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"location"]).to.equal(@"51.1084%2C13.6737%2C100");
        [query removeObjectForKey:@"location"];
        expect([query valueForKey:@"offset"]).to.equal(@"20");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_participants"]).to.equal(@"10");
        [query removeObjectForKey:@"with_participants"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEvents {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventsWithLimit:10
                                                 offset:20
                                          participation:@"maybe"
                                             timePeriod:@"past"
                                             userFields:@"id,page_name"
                                      participantsLimit:10
                                                success:nil
                                                failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/events");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"20");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"participation"]).to.equal(@"maybe");
        [query removeObjectForKey:@"participation"];
        expect([query valueForKey:@"time_period"]).to.equal(@"past");
        [query removeObjectForKey:@"time_period"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_participants"]).to.equal(@"10");
        [query removeObjectForKey:@"with_participants"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEventRecommendations {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventRecommendationsWithLimit:10
                                                               offset:20
                                                           userFields:@"id,page_name"
                                                    participantsLimit:10
                                                              success:nil
                                                              failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/recommendations");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"20");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_participants"]).to.equal(@"10");
        [query removeObjectForKey:@"with_participants"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetEventsOfContacts {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] getEventsOfContactsWithLimit:10
                                                           offset:20
                                                       userFields:@"id,page_name"
                                                participantsLimit:10
                                                          success:nil
                                                          failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/contacts");
        expect(request.HTTPMethod).to.equal(@"GET");

        expect([query valueForKey:@"limit"]).to.equal(@"10");
        [query removeObjectForKey:@"limit"];
        expect([query valueForKey:@"offset"]).to.equal(@"20");
        [query removeObjectForKey:@"offset"];
        expect([query valueForKey:@"user_fields"]).to.equal(@"id%2Cpage_name");
        [query removeObjectForKey:@"user_fields"];
        expect([query valueForKey:@"with_participants"]).to.equal(@"10");
        [query removeObjectForKey:@"with_participants"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testPutEventParticipation {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putEventParticipationForID:@"42_abcd"
                                                  participation:@"maybe"
                                                        success:nil
                                                        failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/events/42_abcd/rsvp");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([body valueForKey:@"selected"]).to.equal(@"maybe");
        [body removeObjectForKey:@"selected"];

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
