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
#import "XNGAPIAward.h"

@interface XNGAPIClient (ProfileEditing)

/**
 Updates the users wants, haves and/or interests

 https://dev.xing.com/docs/put/users/me
*/
- (void)putUpdateUsersGeneralInformationWithAcademicTitle:(NSString *)academicTitle
                                        employmentStatus:(NSString *)employmentStatus
                                                   haves:(NSString *)haves
                                                topHaves:(NSString *)topHaves
                                               interests:(NSString *)interests
                                           organisations:(NSString *)organisations
                                                   wants:(NSString *)wants
                                       additionalHeaders:(NSDictionary *)headers
                                                 success:(void (^)(id JSON))success
                                                 failure:(void (^)(NSError *error))failure;

/**
 Update users profile picture

 https://dev.xing.com/docs/put/users/me/photo
*/
- (void)putUpdateUsersProfilePictureWithImage:(UIImage *)image
                               uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
                            additionalHeaders:(NSDictionary *)headers
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *error))failure;

- (void)cancelPutUpdateUsersProfilePicture;

/**
 Get profile picture upload progress
 https://dev.xing.com/docs/get/users/me/photo/progress
 */
- (void)getUsersProfilePictureProgressWithAdditionalHeaders:(NSDictionary *)headers
                                                    success:(void (^)(id JSON))success
                                                    failure:(void (^)(NSError *error))failure;

/**
 Delete users profile picture

 https://dev.xing.com/docs/delete/users/me/photo
*/
- (void)deleteUsersProfilePictureWithAdditionalHeaders:(NSDictionary *)headers
                                               success:(void (^)(id JSON))success
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
                           additionalHeaders:(NSDictionary *)headers
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

/**
Update users business address

https://dev.xing.com/docs/put/users/me/private_address
*/
- (void)putUpdateUsersBusinessAddressWithCity:(NSString *)city
                                      country:(NSString *)country
                                        email:(NSString *)email
                                          fax:(NSString *)fax
                                  mobilePhone:(NSString *)mobilePhone
                                        phone:(NSString *)phone
                                     province:(NSString *)province
                                       street:(NSString *)street
                                      zipCode:(NSString *)zipCode
                            additionalHeaders:(NSDictionary *)headers
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *error))failure;

/**
 Add a new school to the list of schools in the users profile.

 https://dev.xing.com/docs/post/users/me/educational_background/schools
*/
- (void)postCreateSchoolWithName:(NSString *)name
                       beginDate:(NSString *)beginDate
                          degree:(NSString *)degree
                         endDate:(NSString *)endDate
                           notes:(NSString *)notes
                         subject:(NSString *)subject
               additionalHeaders:(NSDictionary *)headers
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure;

/**
 Update a school

 https://dev.xing.com/docs/put/users/me/educational_background/schools/:id
*/
- (void)putUpdateSchoolWithID:(NSString *)id
                         name:(NSString *)name
                    beginDate:(NSString *)beginDate
                       degree:(NSString *)degree
                      endDate:(NSString *)endDate
                        notes:(NSString *)notes
                      subject:(NSString *)subject
            additionalHeaders:(NSDictionary *)headers
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure;

/**
 Delete school

 https://dev.xing.com/docs/delete/users/me/educational_background/schools/:id
*/
- (void)deleteSchoolWithID:(NSString *)id
         additionalHeaders:(NSDictionary *)headers
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure;

/**
 Update the users primary school

 https://dev.xing.com/docs/put/users/me/educational_background/primary_school
*/
- (void)putUpdatePrimarySchoolWithID:(NSString *)schoolID
                   additionalHeaders:(NSDictionary *)headers
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure;

/**
 Add a qualification to the users educational background

 https://dev.xing.com/docs/post/users/me/educational_background/qualifications
*/
- (void)postAddQualificationWithDescription:(NSString *)description
                          additionalHeaders:(NSDictionary *)headers
                                    success:(void (^)(id JSON))success
                                    failure:(void (^)(NSError *error))failure;

/**
 Add a new company to the list of companies in the users profile.

 https://dev.xing.com/docs/post/users/me/professional_experience/companies
*/
- (void)postAddCompanyWithName:(NSString *)name
                         title:(NSString *)title
                    industries:(NSString *)industries
              formOfEmployment:(NSString *)formOfEmployment
                     beginDate:(NSString *)beginDate
                   careerLevel:(NSString *)careerLevel
                   companySize:(NSString *)companySize
                   description:(NSString *)description
                    discipline:(NSString *)discipline
                       endDate:(NSString *)endDate
                      untilNow:(NSNumber *)untilNow
                           url:(NSString *)URL
             additionalHeaders:(NSDictionary *)headers
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure;

/**
 Update a company

 https://dev.xing.com/docs/put/users/me/professional_experience/companies/:id

 Note: Use a boolean NSNumber on `untilNow` parameter.
*/
- (void)putUpdateCompanyWithID:(NSString *)id
                          name:(NSString *)name
                         title:(NSString *)title
                    industries:(NSString *)industries
              formOfEmployment:(NSString *)formOfEmployment
                     beginDate:(NSString *)beginDate
                   careerLevel:(NSString *)careerLevel
                   companySize:(NSString *)companySize
                   description:(NSString *)description
                    discipline:(NSString *)discipline
                       endDate:(NSString *)endDate
                      untilNow:(NSNumber *)untilNow
                           url:(NSString *)URL
             additionalHeaders:(NSDictionary *)headers
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure;

/**
 Delete a company from the users profile

 https://dev.xing.com/docs/delete/users/me/professional_experience/companies/:id
*/
- (void)deleteCompanyWithID:(NSString *)id
          additionalHeaders:(NSDictionary *)headers
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error))failure;

/**
 Update a company to be the primary company

 https://dev.xing.com/docs/put/users/me/professional_experience/primary_company
 */
- (void)putUpdatePrimaryCompanyWithID:(NSString *)companyID
                    additionalHeaders:(NSDictionary *)headers
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure;

/**
 Update the users award list
 
 https://dev.xing.com/docs/put/users/me/professional_experience/awards
 */
- (void)putUpdateAwards:(NSArray<XNGAPIAward *> *)awards
      additionalHeaders:(NSDictionary *)headers
                success:(void (^)(id JSON))success
                failure:(void (^)(NSError *error))failure;

/**
 Updates the given language skill from the profile

 https://dev.xing.com/docs/put/users/me/languages/:language
*/
- (void)putUpdateLanguageWithIdentifier:(NSString *)language
                                  skill:(NSString *)skill
                      additionalHeaders:(NSDictionary *)headers
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *error))failure;

/**
 Deletes the given language skill from the profile

 https://dev.xing.com/docs/delete/users/me/languages/:language
*/
- (void)deleteLanguageWithIdentifier:(NSString *)language
                   additionalHeaders:(NSDictionary *)headers
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure;

/**
 Updates the users birth date

 https://dev.xing.com/docs/put/users/me/birth_date
*/
- (void)putUpdateBirthDateWithDay:(NSInteger)day
                            month:(NSInteger)month
                             year:(NSInteger)year
                additionalHeaders:(NSDictionary *)headers
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure;

/**
 Updates URLs for the given web profile

 https://dev.xing.com/docs/put/users/me/web_profiles/:profile
*/
- (void)putUpdateWebProfileWithIdentifier:(NSString *)identifier
                                      url:(NSString *)URL
                        additionalHeaders:(NSDictionary *)headers
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure;

/**
 Delete a web profile from the users profile

 https://dev.xing.com/docs/delete/users/me/web_profiles/:profile
*/
- (void)deleteWebProfileWithIdentifier:(NSString *)identifier
                     additionalHeaders:(NSDictionary *)headers
                               success:(void (^)(id JSON))success
                               failure:(void (^)(NSError *error))failure;

/**
 Update the users profile message

 https://dev.xing.com/docs/put/users/:user_id/profile_message
*/
- (void)putUpdateProfileMessageWithUserID:(NSString *)userID
                                  message:(NSString *)profileMessage
                                 isPublic:(BOOL)isPublic
                        additionalHeaders:(NSDictionary *)headers
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure;

/**
 Update the users legal information
 
 https://developer.xing.com/docs/put/users/me/legal_information
 */
- (void)putUpdateLegalInformation:(NSString *)content
                additionalHeaders:(NSDictionary *)headers
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure;

/**
 Update the users instant messenger account
 
 https://dev.xing.com/docs/put/users/me/instant_messaging_accounts/:account
 */
- (void)putUpdateInstantMessengerAccountWithAccount:(NSString *)account
                                               name:(NSString *)name
                                  additionalHeaders:(NSDictionary *)headers
                                            success:(void (^)(id JSON))success
                                            failure:(void (^)(NSError *error))failure;

/**
 Delete the users instant messenger account
 
 https://dev.xing.com/docs/delete/users/me/instant_messaging_accounts/:account
 */
- (void)deleteInstantMessengerAccount:(NSString *)account
                    additionalHeaders:(NSDictionary *)headers
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure;

@end
