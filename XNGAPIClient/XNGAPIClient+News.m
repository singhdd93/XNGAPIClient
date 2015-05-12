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

#import "XNGAPIClient+News.h"

@implementation XNGAPIClient (News)

- (void)getNewsPageForNewsPageID:(NSString *)pageID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure {
    if (!pageID) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"v1/news/pages/%@", pageID];
    [self getJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getArticlesForNewPageID:(NSString *)pageID
                          limit:(NSInteger)limit
                         offset:(NSInteger)offset
                        success:(void (^)(id JSON))success
                        failure:(void (^)(NSError *error))failure {
    if (!pageID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    NSString *path = [NSString stringWithFormat:@"v1/news/pages/%@/articles", pageID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getArticleForArticleID:(NSString *)articleID
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure {
    if (!articleID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@", articleID];
    [self getJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putUpdateArticleForArticleID:(NSString *)articleID
                             version:(NSString *)version
                         description:(NSString *)description
                            imageURL:(NSString *)imageURL
                    introductoryText:(NSString *)introductoryText
                         publishedAt:(NSString *)publishedAt
                           sourceURL:(NSString *)sourceURL
                               title:(NSString *)title
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure {
    if (!articleID || !version) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"version"] = version;

    if (description) {
        parameters[@"description"] = description;
    }
    if (imageURL) {
        parameters[@"image_url"] = imageURL;
    }
    if (introductoryText) {
        parameters[@"introductory_text"] = introductoryText;
    }
    if (publishedAt) {
        parameters[@"published_at"] = publishedAt;
    }
    if (sourceURL) {
        parameters[@"source_url"] = sourceURL;
    }
    if (title) {
        parameters[@"title"] = title;
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@", articleID];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteArticleForArticleID:(NSString *)articleID
                          version:(NSString *)version
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {
    if (!articleID || !version) {
        return;
    }

    NSDictionary *parameters = @{@"version": version};
    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@", articleID];
    [self deleteJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEditablePagesWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/news/pages/editable"];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getFollowedPagesWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    NSString *path = [NSString stringWithFormat:@"v1/users/me/news/pages/following"];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putLikeArticleWithArticleID:(NSString *)articleID
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *error))failure {
    if (!articleID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@/like", articleID];
    [self putJSONPath:path parameters:nil success:success failure:failure];
}

- (void)deleteUnlikeArticleWithArticleID:(NSString *)articleID
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *error))failure {
    if (!articleID) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@/like", articleID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getLikesForArticleWithArticleID:(NSString *)articleID
                             userFields:(NSString *)userFields
                                  limit:(NSInteger)limit
                                 offset:(NSInteger)offset
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *error))failure {
    if (!articleID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/articles/%@/likes", articleID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postCreateArticleWithPageID:(NSString *)pageID
                          sourceURL:(NSString *)sourceURL
                              title:(NSString *)title
                        description:(NSString *)description
                           imageURL:(NSString *)imageURL
                   introductoryText:(NSString *)introductoryText
                        publishedAt:(NSString *)publishedAt
                             source:(NSString *)source
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *error))failure {
    if (!pageID || !sourceURL || !title) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"source_url"] = sourceURL;
    parameters[@"title"] = title;
    if (description) {
        parameters[@"description"] = description;
    }
    if (imageURL) {
        parameters[@"image_url"] = imageURL;
    }
    if (introductoryText) {
        parameters[@"introductory_text"] = introductoryText;
    }
    if (publishedAt) {
        parameters[@"published_at"] = publishedAt;
    }
    if (source) {
        parameters[@"source"] = source;
    }

    NSString *path = [NSString stringWithFormat:@"v1/news/pages/%@/articles", pageID];
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

@end
