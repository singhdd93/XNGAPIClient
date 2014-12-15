#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "NSError+XWS.h"

@interface NSError_XWSTests : XCTestCase

@end

@implementation NSError_XWSTests

- (void)testIsXWSError {
    NSError *error = [NSError errorWithDomain:@"XWSError"
                                         code:403 userInfo:@{@"error_name": @"OhOh!"}];
    expect([error isXWSError]).to.beTruthy();
}

- (void)testIsHTTPError {
    NSError *error = [NSError errorWithDomain:@"HTTPError"
                                         code:403 userInfo:@{@"error_name": @"OhOh!"}];
    expect([error isHTTPError]).to.beTruthy();
}

- (void)testErrorName {
    NSError *error = [NSError errorWithDomain:@"HTTPError"
                                         code:403 userInfo:@{@"error_name": @"OhOh!"}];
    expect([error xwsErrorName]).to.equal(@"OhOh!");
}

- (void)testAccessDeniedWithAccessDeniedMessage {
    NSError *error = [NSError errorWithDomain:@"XWSError"
                                         code:403 userInfo:@{@"error_name": @"ACCESS_DENIED"}];
    expect([error xws_accessDenied]).to.beTruthy();
}

- (void)testAccessDeniedWithForbiddenMessage {
    NSError *error = [NSError errorWithDomain:@"XWSError"
                                         code:403 userInfo:@{@"error_name": @"FORBIDDEN"}];
    expect([error xws_accessDenied]).to.beTruthy();
}

- (void)testAccessDeniedWithInvalidMessage {
    NSError *error = [NSError errorWithDomain:@"HTTPError"
                                         code:406 userInfo:@{@"error_name": @"OhOh!"}];
    expect([error xws_accessDenied]).to.beFalsy();
}

- (void)testXWSErrorWithStatusCode {
    NSError *error = [NSError xwsErrorWithStatusCode:406 userInfo:@{@"some_key": @"some_value"}];
    expect(error.domain).to.equal(@"XWSError");
    expect(error.code).to.equal(406);
    expect(error.userInfo).to.equal(@{@"some_key": @"some_value"});
}

- (void)testHTTPErrorWithStatusCode {
    NSError *error = [NSError httpErrorWithStatusCode:406 userInfo:@{@"some_key": @"some_value"}];
    expect(error.domain).to.equal(@"HTTPError");
    expect(error.code).to.equal(406);
    expect(error.userInfo).to.equal(@{@"some_key": @"some_value"});
}

@end
