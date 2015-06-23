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

#import "XNGAPIClient+Groups.h"
#import "UIImage+Base64Encoding.h"

@implementation XNGAPIClient (Groups)

- (void)getUsersGroupsWithUserID:(NSString *)userID
                           limit:(NSInteger)limit
                          offset:(NSInteger)offset
                         orderBy:(NSString *)orderBy
                      userFields:(NSString *)userFields
                 withLatestPosts:(NSInteger)numberOfLatestPosts
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure {
    if (!userID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (orderBy) {
        parameters[@"order_by"] = orderBy;
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (numberOfLatestPosts) {
        parameters[@"with_latest_posts"] = @(numberOfLatestPosts);
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/%@/groups", userID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getFindGroupsWithKeywords:(NSString *)keywords
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *))failure {
    if (!keywords) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"keywords"] = keywords;
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    NSString *path = @"v1/groups/find";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getForumsForGroupWithGroupID:(NSString *)groupID
                               limit:(NSInteger)limit
                              offset:(NSInteger)offset
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *))failure {
    if (!groupID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/%@/forums", groupID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getPostsForForumWithForumID:(NSString *)forumID
                     excludeContent:(BOOL)excludeContent
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure {
    if (!forumID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (excludeContent) {
        parameters[@"exclude_content"] = @(excludeContent);
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/%@/posts", forumID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getGroupPostWithPostID:(NSString *)postID
                    userFields:(NSString *)userFields
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@", postID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getPostsForGroupWithGroupID:(NSString *)groupID
                     excludeContent:(BOOL)excludeContent
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure {
    if (!groupID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (excludeContent) {
        parameters[@"exclude_content"] = @(excludeContent);
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/%@/posts", groupID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getLikesForPostWithPostID:(NSString *)postID
                       userFields:(NSString *)userFields
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@/likes", postID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putLikeAPostWithPostID:(NSString *)postID
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@/like", postID];
    [self putJSONPath:path JSONParameters:nil success:success failure:failure];
}

- (void)deleteUnlikeAPostWithPostID:(NSString *)postID
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@/like", postID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getCommentsOfPostWithPostID:(NSString *)postID
                      sortDirection:(NSString *)sortDirection
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (sortDirection) {
        parameters[@"sort_direction"] = sortDirection;
    }
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@/comments", postID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postCommentOnGroupPostWithPostID:(NSString *)postID
                                 content:(NSString *)content
                                   image:(UIImage *)image
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *))failure {
    if (!postID | !content) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"content"] = content;
    if (image) {
        parameters[@"image"] = @{
                                 @"file_name": [image xng_uuidImageName],
                                 @"mime_type": @"image/jpeg",
                                 @"content": [image xng_base64]
                                 };
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@/comments", postID];
    [self postJSONPath:path
       JSONParameters:parameters
              success:success
              failure:failure];
}

- (void)deleteCommentOnGroupPostWithCommentID:(NSString *)commentID
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *))failure {
    if (!commentID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/comments/%@", commentID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getLikesForCommentWithCommentID:(NSString *)commentID
                             userFields:(NSString *)userFields
                                  limit:(NSInteger)limit
                                 offset:(NSInteger)offset
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *))failure {
    if (!commentID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/comments/%@/likes", commentID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putLikeACommentWithCommentID:(NSString *)commentID
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *))failure {
    if (!commentID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/comments/%@/like", commentID];
    [self putJSONPath:path JSONParameters:nil success:success failure:failure];
}

- (void)deleteUnlikeACommentWithCommentID:(NSString *)commentID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *))failure {
    if (!commentID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/comments/%@/like", commentID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putMarkGroupAsReadWithGroupID:(NSString *)groupID
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *))failure {
    if (!groupID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/%@/read", groupID];
    [self putJSONPath:path JSONParameters:nil success:success failure:failure];
}

- (void)postJoinGroupWithGroupID:(NSString *)groupID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure {
    if (!groupID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/%@/memberships", groupID];
    [self postJSONPath:path JSONParameters:nil success:success failure:failure];
}

#ifdef TARGET_OS_IPHONE
- (void)postCreatePostInForumWithForumID:(NSString *)forumID
                                   title:(NSString *)title
                                 content:(NSString *)content
                                   image:(UIImage *)image
                              userFields:(NSString *)userFields
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *))failure {
    if (!forumID || !title || !content) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"title"] = title;
    parameters[@"content"] = content;
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (image) {
        parameters[@"image"] = @{
                                 @"file_name": [image xng_uuidImageName],
                                 @"mime_type": @"image/jpeg",
                                 @"content": [image xng_base64]
                                 };
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/%@/posts", forumID];
    [self postJSONPath:path JSONParameters:parameters success:success failure:failure];
}
#endif

- (void)deletePostWithPostID:(NSString *)postID
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *))failure {
    if (!postID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/forums/posts/%@", postID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)deleteLeaveGroupWithGroupID:(NSString *)groupID
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure {
    if (!groupID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/groups/%@/memberships", groupID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

@end
