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

- (void)testURLFromURLStringWithParameters {
    NSURL *urlUnderTest = [NSString xng_URLFromURLString:@"https://api.xing.com/v1/conversation"
                                              parameters:@{@"message": @"Hallo wie gehts?",
                                                           @"unread": @(YES)}];
    expect(urlUnderTest).to.equal([NSURL URLWithString:@"https://api.xing.com/v1/conversation?message=Hallo%20wie%20gehts%3F&unread=1"]);
}

- (void)testURLDecodedDictionaryFromString {
    NSDictionary *dictUnderTest = [NSString xng_URLDecodedDictionaryFromString:@"message=Hallo%20wie%20gehts%3F&unread=1"];
    expect(dictUnderTest).to.equal(@{@"message": @"Hallo wie gehts?", @"unread": @"1"});
}

@end
