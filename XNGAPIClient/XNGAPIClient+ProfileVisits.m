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

#import "XNGAPIClient+ProfileVisits.h"
#import "XNGAPIClient_Private.h"

@implementation XNGAPIClient (ProfileVisits)

#pragma mark - public methods

// DEPRECATED
- (void)getVisitsWithLimit:(NSInteger)limit
                    offset:(NSInteger)offset
                     since:(NSString *)since
                 stripHTML:(BOOL)stripHTML
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure {
    [self getVisitsWithLimit:limit
                      offset:offset
                       since:since
      numberOfSharedContacts:0
                   stripHTML:stripHTML
                     success:success
                     failure:failure];
}

- (void)getVisitsWithLimit:(NSInteger)limit
                    offset:(NSInteger)offset
                     since:(NSString *)since
    numberOfSharedContacts:(NSUInteger)numberOfSharedContacts
                 stripHTML:(BOOL)stripHTML
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if ([since length]) {
        parameters[@"since"] = since;
    }
    if (stripHTML) {
        parameters[@"strip_html"] = @"true";
    }
    
    if (numberOfSharedContacts > 0) {
        numberOfSharedContacts = MIN(numberOfSharedContacts, 10);
        parameters[@"shared_contacts"] = @(numberOfSharedContacts);
    }

    NSString *path = [self visitsPath];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)cancelAllGetVisitsOperations {
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:[self visitsPath]];
}

- (void)postReportProfileVisitForUserID:(NSString *)userID
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *error))failure {
    NSParameterAssert(userID);
    NSString *path = [NSString stringWithFormat:@"v1/users/%@/visits", userID];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:nil];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:^(NSData *responseObject) {
        if (success) {
            success(nil);
        }
    } failure:failure];
    [self.operationQueue addOperation:operation];
}

#pragma mark - private methods

- (NSString *)visitsPath {
     return @"v1/users/me/visits";
}
@end
