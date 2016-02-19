#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "NSString+URLEncoding.h"

@interface NSString_URLEncodingTests : XCTestCase

@end

@implementation NSString_URLEncodingTests

- (void)testURLEncodedString {
    NSString *urlToTest = @"Hallo wie gehts?";
    expect([urlToTest xng_URLEncodedString]).to.equal(@"Hallo%20wie%20gehts%3F");
}

- (void)testURLDecodedString {
    NSString *urlToTest = @"Hallo%20wie%20gehts%3F";
    expect([urlToTest xng_URLDecodedString]).to.equal(@"Hallo wie gehts?");
}

- (void)testURLFromURLStringWithoutParameters {
    NSURL *referenceURL = [NSURL URLWithString:@"https://jira.xing.hh/jira/secure/RapidBoard.jspa"];
    NSURL *testURL = [NSString xng_URLFromURLString:@"https://jira.xing.hh/jira/secure/RapidBoard.jspa"
                                         parameters:nil];
    expect(testURL).to.equal(referenceURL);
}

- (void)testURLFromURLStringWithParameters {
    NSURL *urlUnderTest = [NSString xng_URLFromURLString:@"https://api.xing.com/v1/conversation"
                                              parameters:@{@"message": @"Hallo wie gehts?",
                                                           @"unread": @(YES)}];
    expect(urlUnderTest).to.equal([NSURL URLWithString:@"https://api.xing.com/v1/conversation?message=Hallo%20wie%20gehts%3F&unread=1"]);
}

- (void)testURLFromURLString {
    NSURL *referenceURL = [NSURL URLWithString:@"https://jira.xing.hh/jira/secure/RapidBoard.jspa?selectedIssue=XAN-3689&view=planning&rapidView=222"];
    NSURL *testURL = [NSString xng_URLFromURLString:@"https://jira.xing.hh/jira/secure/RapidBoard.jspa"
                                         parameters:@{@"selectedIssue": @"XAN-3689",
                                                      @"view": @"planning",
                                                      @"rapidView": @222}];
    expect(testURL).to.equal(referenceURL);
}

- (void)testURLEncodedStringFromDictionary {
    NSDictionary *dict = @{@"this is a test /": @"test",
                           @"another string": @"another value"};
    NSString *referenceString = @"another%20string=another%20value&this%20is%20a%20test%20%2F=test";
    NSString *testString = [NSString xng_URLEncodedStringFromDictionary:dict];
    expect(testString).to.equal(referenceString);
}

- (void)testURLDecodedDictionaryFromString {
    NSDictionary *referenceDict = @{@"this is a test /": @"test",
                                    @"another string": @"another value"};
    NSString *string = @"this%20is%20a%20test%20%2F=test&another%20string=another%20value";
    NSDictionary *testDict = [NSString xng_URLDecodedDictionaryFromString:string];
    expect(testDict).to.equal(referenceDict);
}

- (void)testURLDecodedDictionaryFromStringWithoutValue {
    NSDictionary *referenceDict = @{@"test": @"", @"test2": @"value2"};
    NSString *string = @"test=&test2=value2";
    NSDictionary *testDict = [NSString xng_URLDecodedDictionaryFromString:string];
    expect(testDict).to.equal(referenceDict);
}


@end
