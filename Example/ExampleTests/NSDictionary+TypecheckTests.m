#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <NSDictionary+Typecheck.h>

static NSString * const XNGTypecheckTestKey = @"key";

@interface NSDictionary_TypecheckTests : XCTestCase

@end

@implementation NSDictionary_TypecheckTests

- (void)testStringForKey {
    NSString *testString = @"value";
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testString};
    expect([classUnderTest xng_stringForKey:XNGTypecheckTestKey]).to.equal(testString);
    classUnderTest = @{XNGTypecheckTestKey: @0};
    expect([classUnderTest xng_stringForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testArrayForKey {
    NSArray *testArray = @[];
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testArray};
    expect([classUnderTest xng_arrayForKey:@"key"]).to.equal(testArray);
    classUnderTest = @{@"key": @0};
    expect([classUnderTest xng_arrayForKey:@"key"]).to.beFalsy();
}

- (void)testArrayForKeyPath {
    NSArray *testArray = @[];
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey:@{@"otherKey": testArray}};
    expect([classUnderTest xng_arrayForKeyPath:@"key.otherKey"]).to.equal(testArray);
    classUnderTest = @{XNGTypecheckTestKey:@{@"otherKey": @0}};
    expect([classUnderTest xng_arrayForKeyPath:@"key.otherKey"]).to.beFalsy();
}

- (void)testFloatForKey {
    NSString *testString = @"1.5";
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testString};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.equal(1.5);
    classUnderTest = @{XNGTypecheckTestKey: @1.5};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.equal(1.5);
    classUnderTest = @{XNGTypecheckTestKey: @[]};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testIntForKey {
    NSString *testString = @"1";
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testString};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.equal(1);
    classUnderTest = @{XNGTypecheckTestKey: @1};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.equal(1);
    classUnderTest = @{XNGTypecheckTestKey: @[]};
    expect([classUnderTest xng_floatForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testBoolForKey {
    NSString *testString = @"true";
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testString};
    expect([classUnderTest xng_BOOLForKey:XNGTypecheckTestKey]).to.beTruthy();
    classUnderTest = @{XNGTypecheckTestKey: @YES};
    expect([classUnderTest xng_BOOLForKey:XNGTypecheckTestKey]).to.beTruthy();
    classUnderTest = @{XNGTypecheckTestKey: @NO};
    expect([classUnderTest xng_BOOLForKey:XNGTypecheckTestKey]).to.beFalsy();
    classUnderTest = @{XNGTypecheckTestKey: @[]};
    expect([classUnderTest xng_BOOLForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testNumberForKey {
    NSNumber *testNumber = @10;
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testNumber};
    expect([classUnderTest xng_numberForKey:XNGTypecheckTestKey]).to.equal(testNumber);
    classUnderTest = @{XNGTypecheckTestKey: @[]};
    expect([classUnderTest xng_numberForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testMutableArrayForKey {
    NSArray *testArray = @[];
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testArray};
    expect([classUnderTest xng_mutableArrayForKey:XNGTypecheckTestKey]).to.equal([testArray mutableCopy]);
    NSMutableArray *mutableTestArray = [[NSMutableArray alloc]init];
    classUnderTest = @{XNGTypecheckTestKey: mutableTestArray};
    expect([classUnderTest xng_mutableArrayForKey:XNGTypecheckTestKey]).to.equal(mutableTestArray);
    classUnderTest = @{XNGTypecheckTestKey: @0};
    expect([classUnderTest xng_mutableArrayForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testDictForKey {
    NSDictionary *testDictionary = @{};
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey: testDictionary};
    expect([classUnderTest xng_dictForKey:XNGTypecheckTestKey]).to.equal(testDictionary);
    classUnderTest = @{XNGTypecheckTestKey: @0};
    expect([classUnderTest xng_dictForKey:XNGTypecheckTestKey]).to.beFalsy();
}

- (void)testDictForKeyPath {
    NSDictionary *testDictionary = @{};
    NSDictionary *classUnderTest = @{XNGTypecheckTestKey:@{@"otherKey": testDictionary}};
    expect([classUnderTest xng_dictForKeyPath:@"key.otherKey"]).to.equal(testDictionary);
    classUnderTest = @{XNGTypecheckTestKey:@{@"otherKey": @0}};
    expect([classUnderTest xng_dictForKeyPath:@"key.otherKey"]).to.beFalsy();
}

@end
