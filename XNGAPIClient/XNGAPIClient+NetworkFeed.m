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

#import "XNGAPIClient+NetworkFeed.h"
#import "XNGAPIClient_Private.h"

@implementation XNGAPIClient (NetworkFeed)

#pragma mark - public methods

- (void)getNetworkFeedUntil:(NSString *)until
                 userFields:(NSString *)userFields
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (until) {
        parameters[@"until"] = until;
    }

    NSString *path = [self pathForNetworkFeed];

    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelAllNetworkFeedHTTPOperations {
    NSString *path = [self pathForNetworkFeed];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)getUserFeedForUserID:(NSString *)userID
                       until:(NSString *)until
                  userFields:(NSString *)userFields
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (until) {
        parameters[@"until"] = until;
    }

    NSString *path = [self pathForUserFeedWithUserID:userID];

    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelAllUserFeedHTTPOperationsForUserID:(NSString *)userID {
    NSString *path = [self pathForUserFeedWithUserID:userID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)postStatusMessage:(NSString *)statusMessage
                  success:(void (^)(id JSON))success
                  failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"message"] = statusMessage;

    NSString *path = @"v1/users/me/status_message";
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:^(NSData *responseObject) {
        if (success) {
            success(nil);
        }
    } failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)postLink:(NSString *)uri
         success:(void (^)(id JSON))success
         failure:(void (^)(NSError *error))failure {
    [self postLink:uri text:nil success:success failure:failure];
}

- (void)postLink:(NSString *)uri
            text:(NSString *)text
         success:(void (^)(id JSON))success
         failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uri"] = uri;
    if ([text length] > 0) {
        parameters[@"text"] = text;
    }
    NSString *path = @"v1/users/me/share/link";
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getSingleActivityWithID:(NSString *)activityID
                     userFields:(NSString *)userFields
                        success:(void (^)(id JSON))success
                        failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [self pathForSingleActivityWithActivityID:activityID];

    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelAllSingleActivityHTTPOperationsForActivityID:(NSString *)activityID {
    NSString *path = [self pathForSingleActivityWithActivityID:activityID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)postRecommendActivityWithID:(NSString *)activityID
                               text:(NSString *)text
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (text) {
        parameters[@"text"] = text;
    }

    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/share", activityID];

    [self postJSONPath:path
            parameters:parameters
               success:success
               failure:failure];
}

- (void)deleteActivityWithID:(NSString*)activityID
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/activities/%@", activityID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getCommentsWithActivityID:(NSString*)activityID
                       userFields:(NSString *)userFields
                           offset:(NSInteger)offset
                            limit:(NSInteger)limit
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (limit > 0) {
        parameters[@"limit"] = @(limit);
    }
    if ( offset > 0 ) {
        parameters[@"offset"] = @(offset);
    }

    NSString* path = [NSString stringWithFormat:@"v1/activities/%@/comments", activityID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postNewComment:(NSString*)comment
            activityID:(NSString*)activityID
               success:(void (^)(id JSON))success
               failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"text"] = comment;

    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/comments", activityID];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:^(NSData *responseObject) {
        if (success) {
            success(nil);
        }
    } failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)deleteCommentWithID:(NSString*)commentID
                 activityID:(NSString*)activityID
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/comments/%@", activityID, commentID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getLikesForActivityID:(NSString*)activityID
                   userFields:(NSString *)userFields
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if ( offset > 0 ) {
        parameters[@"offset"] = @(offset);
    }
    if ( limit > 0 ) {
        parameters[@"limit"] = @(limit);
    }

    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/likes", activityID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putLikeActivityWithID:(NSString*)activityID
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/like", activityID];
    [self putJSONPath:path parameters:nil success:success failure:failure];
}

- (void)deleteUnlikeActivityWithID:(NSString*)activityID
                           success:(void (^)(id JSON))success
                           failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/activities/%@/like", activityID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

#pragma mark - private methods

- (NSString *)pathForNetworkFeed {
    return [NSString stringWithFormat:@"v1/users/me/network_feed"];
}

- (NSString *)pathForUserFeedWithUserID:(NSString *)userID {
    return [NSString stringWithFormat:@"v1/users/%@/feed", userID];
}

- (NSString *)pathForSingleActivityWithActivityID:(NSString *)activityID {
    return [NSString stringWithFormat:@"v1/activities/%@", activityID];
}

@end
