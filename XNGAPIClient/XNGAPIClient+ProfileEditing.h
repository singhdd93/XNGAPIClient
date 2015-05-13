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

@interface XNGAPIClient (ProfileEditing)

/**
 Updates the users wants, haves and/or interests

 https://dev.xing.com/docs/put/users/me
*/
- (void)putUpdateUsersGeneralInformationWithHaves:(NSString *)haves
                                        interests:(NSString *)interests
                                            wants:(NSString *)wants
                                          success:(void (^)(id JSON))success
                                          failure:(void (^)(NSError *error))failure;

/**
 Update users profile picture

 https://dev.xing.com/docs/put/users/me/photo
*/
- (void)putUpdateUsersProfilePictureWithImage:(UIImage *)image
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *error))failure;

/**
 Delete users profile picture

 https://dev.xing.com/docs/delete/users/me/photo
*/
- (void)deleteUsersProfilePictureWithSuccess:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

/**
 Update users private address

 https://dev.xing.com/docs/put/users/me/private_address
*/
- (void)putUpdateUsersPrivateAddressWithCity:(NSString *)city
                                     country:(NSString *)country
                                       email:(NSString *)email
                                         fax:(NSString *)fax
                                 mobilePhone:(NSString *)mobilePhone
                                       phone:(NSString *)phone
                                    province:(NSString *)province
                                      street:(NSString *)street
                                     zipCode:(NSString *)zipCode
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

@end
