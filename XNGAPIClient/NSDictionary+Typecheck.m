//
// Copyright (c) 2015 XING AG (http://xing.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSDictionary+Typecheck.h"

@implementation NSDictionary (Typecheck)

static NSString *stringFromValue(id value) {
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else {
        return nil;
    }
}

- (NSString *)xng_stringForKey:(id)key {
    return stringFromValue([self objectForKey:key]);
}

- (NSString *)xng_stringForKeyPath:(NSString *)keyPath {
    return stringFromValue([self valueForKeyPath:keyPath]);
}

static NSArray *arrayFromValue(id value) {
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return nil;
    }
}

- (NSArray *)xng_arrayForKey:(id)key {
    return arrayFromValue(self[key]);
}

- (NSArray *)xng_arrayForKeyPath:(NSString *)keyPath {
    return arrayFromValue([self valueForKeyPath:keyPath]);
}

- (CGFloat)xng_floatForKey:(id)key {
    id value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    } else {
        return 0.0;
    }
}

- (NSInteger)xng_intForKey:(id)key {
    id value = self[key];
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    } else {
        return 0;
    }
}

- (BOOL)xng_BOOLForKey:(id)key {
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [value isEqualToString:@"true"];
    } else {
        return NO;
    }
}

- (NSNumber *)xng_numberForKey:(id)key {
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}

- (NSMutableArray *)xng_mutableArrayForKey:(id)key {
    id value = self[key];
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return value;
    } else if ([value isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:value];
    } else {
        return nil;
    }
}

static NSDictionary *dictFromValue(id value) {
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return nil;
    }
}

- (NSDictionary *)xng_dictForKey:(id)key {
    return dictFromValue(self[key]);
}

- (NSDictionary *)xng_dictForKeyPath:(NSString *)keyPath {
    return dictFromValue([self valueForKeyPath:keyPath]);
}

@end
