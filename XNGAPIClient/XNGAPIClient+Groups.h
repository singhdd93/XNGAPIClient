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

@interface XNGAPIClient (Groups)

/**
 Get the list of groups the given user belongs to.

 https://dev.xing.com/docs/get/users/:user_id/groups
*/
- (void)getUsersGroupsWithUserID:(NSString *)userID
                           limit:(NSInteger)limit
                          offset:(NSInteger)offset
                         orderBy:(NSString *)orderBy
                      userFields:(NSString *)userFields
                 withLatestPosts:(NSInteger)numberOfLatestPosts
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure;

/**
 Find groups by keywords

 https://dev.xing.com/docs/get/groups/find
*/
- (void)getFindGroupsWithKeywords:(NSString *)keywords
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *))failure;

/**
 Get the forums of a group

 https://dev.xing.com/docs/get/groups/:group_id/forums
 */
- (void)getForumsForGroupWithGroupID:(NSString *)groupID
                               limit:(NSInteger)limit
                              offset:(NSInteger)offset
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *))failure;

/**
 Get the posts of a forum

 https://dev.xing.com/docs/get/groups/forums/:forum_id/posts
 */
- (void)getPostsForForumWithForumID:(NSString *)forumID
                     excludeContent:(BOOL)excludeContent
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure;
/**
 Show a post in a group

 https://dev.xing.com/docs/get/groups/forums/posts/:post_id
*/

- (void)getGroupPostWithPostID:(NSString *)postID
                    userFields:(NSString *)userFields
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *))failure;

/**
 Get all the posts of a group

 https://dev.xing.com/docs/get/groups/:group_id/posts
*/
- (void)getPostsForGroupWithGroupID:(NSString *)groupID
                     excludeContent:(BOOL)excludeContent
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure;

/**
 Get the likes of a post

 https://dev.xing.com/docs/get/groups/forums/posts/:post_id/likes
*/
- (void)getLikesForPostWithPostID:(NSString *)postID
                       userFields:(NSString *)userFields
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *))failure;

/**
 Like a post

 https://dev.xing.com/docs/put/groups/forums/posts/:post_id/like
*/
- (void)putLikeAPostWithPostID:(NSString *)postID
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *))failure;

/**
 Unlike a post

 https://dev.xing.com/docs/put/groups/forums/posts/:post_id/like
 */
- (void)deleteUnlikeAPostWithPostID:(NSString *)postID
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure;

/**
 Get the comments of a post

 https://dev.xing.com/docs/get/groups/forums/posts/:post_id/comments
*/
- (void)getCommentsOfPostWithPostID:(NSString *)postID
                      sortDirection:(NSString *)sortDirection
                         userFields:(NSString *)userFields
                              limit:(NSInteger)limit
                             offset:(NSInteger)offset
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure;

/**
 Add a comment to a post

 https://dev.xing.com/docs/post/groups/forums/posts/:post_id/comments
 */
- (void)postCommentOnGroupPostWithPostID:(NSString *)postID
                                 content:(NSString *)content
                                   image:(UIImage *)image
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *))failure;

/**
 Delete a comment of a post

 https://dev.xing.com/docs/delete/groups/forums/posts/comments/:comment_id
 */
- (void)deleteCommentOnGroupPostWithCommentID:(NSString *)commentID
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *))failure;

/**
 Get the likes of a comment

 https://dev.xing.com/docs/get/groups/forums/posts/comments/:comment_id/likes
*/
- (void)getLikesForCommentWithCommentID:(NSString *)commentID
                             userFields:(NSString *)userFields
                                  limit:(NSInteger)limit
                                 offset:(NSInteger)offset
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *))failure;

/**
 Like a comment

 https://dev.xing.com/docs/put/groups/forums/posts/comments/:comment_id/like
 */
- (void)putLikeACommentWithCommentID:(NSString *)commentID
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *))failure;

/**
 Unlike a comment

 https://dev.xing.com/docs/delete/groups/forums/posts/comments/:comment_id/like
*/
- (void)deleteUnlikeACommentWithCommentID:(NSString *)commentID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *))failure;

/**
 Mark a group as read

 https://dev.xing.com/docs/put/groups/:group_id/read
*/
- (void)putMarkGroupAsReadWithGroupID:(NSString *)groupID
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *))failure;

/**
 Join a group

 https://dev.xing.com/docs/post/groups/:group_id/memberships
*/
- (void)postJoinGroupWithGroupID:(NSString *)groupID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *))failure;

/**
 Create a post in a group

 https://dev.xing.com/docs/post/groups/forums/:forum_id/posts
 */
- (void)postCreatePostInForumWithForumID:(NSString *)forumID
                                   title:(NSString *)title
                                 content:(NSString *)content
                                   image:(UIImage *)image
                              userFields:(NSString *)userFields
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *))failure;

/**
 Delete a post from a group

 https://dev.xing.com/docs/delete/groups/forums/posts/:post_id
 */
- (void)deletePostWithPostID:(NSString *)postID
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *))failure;

/**
 Leave a group

 https://dev.xing.com/docs/delete/groups/:group_id/memberships
*/
- (void)deleteLeaveGroupWithGroupID:(NSString *)groupID
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *))failure;

@end
