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

#import "XNGAPIClient.h"

@interface XNGAPIClient (News)

/**
 Returns a news page

 https://dev.xing.com/docs/get/news/pages/:id
* */
- (void)getNewsPageForNewsPageID:(NSString *)pageID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure;

/**
 Returns the list of articles on a news page

 https://dev.xing.com/docs/get/news/pages/:page_id/articles
*/
- (void)getArticlesForNewPageID:(NSString *)pageID
                          limit:(NSInteger)limit
                         offset:(NSInteger)offset
                        success:(void (^)(id JSON))success
                        failure:(void (^)(NSError *error))failure;

/**
 Returns a single article

 https://dev.xing.com/docs/get/news/articles/:id
*/
- (void)getArticleForArticleID:(NSString *)articleID
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure;

/**
 Update a news article

 https://dev.xing.com/docs/put/news/articles/:id
*/
- (void)putUpdateArticleForArticleID:(NSString *)articleID
                             version:(NSString *)version
                         description:(NSString *)description
                            imageURL:(NSString *)imageURL
                    introductoryText:(NSString *)introductoryText
                         publishedAt:(NSString *)publishedAt
                           sourceURL:(NSString *)sourceURL
                               title:(NSString *)title
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure;

@end
