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

#import "XNGAPIClient+ProfileEditing.h"
#import "UIImage+Base64Encoding.h"

@implementation XNGAPIClient (ProfileEditing)

- (void)putUpdateUsersGeneralInformationWithHaves:(NSString *)haves
                                        interests:(NSString *)interests
                                            wants:(NSString *)wants
                                          success:(void (^)(id JSON))success
                                          failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (haves) {
        parameters[@"haves"] = haves;
    }
    if (interests) {
        parameters[@"interests"] = interests;
    }
    if (wants) {
        parameters[@"wants"] = wants;
    }

    NSString *path = @"v1/users/me";
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putUpdateUsersProfilePictureWithImage:(UIImage *)image
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *error))failure {
    if (!image) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"photo"] = @{
            @"file_name": [image xng_uuidImageName],
            @"mime_type": @"image/jpeg",
            @"content": [image xng_base64]
    };

    NSString *path = @"/v1/users/me/photo";
    [self putJSONPath:path
       JSONParameters:parameters
              success:success
              failure:failure];
}

- (void)deleteUsersProfilePictureWithSuccess:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure {
    NSString *path = @"v1/users/me/photo";
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

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
                                     failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (city) {
        parameters[@"city"] = city;
    }
    if (country) {
        parameters[@"country"] = country;
    }
    if (email) {
        parameters[@"email"] = email;
    }
    if (fax) {
        parameters[@"fax"] = fax;
    }
    if (mobilePhone) {
        parameters[@"mobile_phone"] = mobilePhone;
    }
    if (phone) {
        parameters[@"phone"] = phone;
    }
    if (province) {
        parameters[@"province"] = province;
    }
    if (street) {
        parameters[@"street"] = street;
    }
    if (zipCode) {
        parameters[@"zip_code"] = zipCode;
    }

    NSString *path = @"v1/users/me/private_address";
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putUpdateUsersBusinessAddressWithCity:(NSString *)city
                                      country:(NSString *)country
                                        email:(NSString *)email
                                          fax:(NSString *)fax
                                  mobilePhone:(NSString *)mobilePhone
                                        phone:(NSString *)phone
                                     province:(NSString *)province
                                       street:(NSString *)street
                                      zipCode:(NSString *)zipCode
                                      success:(void (^)(id JSON))success
                                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (city) {
        parameters[@"city"] = city;
    }
    if (country) {
        parameters[@"country"] = country;
    }
    if (email) {
        parameters[@"email"] = email;
    }
    if (fax) {
        parameters[@"fax"] = fax;
    }
    if (mobilePhone) {
        parameters[@"mobile_phone"] = mobilePhone;
    }
    if (phone) {
        parameters[@"phone"] = phone;
    }
    if (province) {
        parameters[@"province"] = province;
    }
    if (street) {
        parameters[@"street"] = street;
    }
    if (zipCode) {
        parameters[@"zip_code"] = zipCode;
    }

    NSString *path = @"v1/users/me/business_address";
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postCreateSchoolWithName:(NSString *)name
                       beginDate:(NSString *)beginDate
                          degree:(NSString *)degree
                         endDate:(NSString *)endDate
                           notes:(NSString *)notes
                         subject:(NSString *)subject
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure {
    if (!name) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = name;
    if (beginDate) {
        parameters[@"begin_date"] = beginDate;
    }
    if (degree) {
        parameters[@"degree"] = degree;
    }
    if (endDate) {
        parameters[@"end_date"] = endDate;
    }
    if (notes) {
        parameters[@"notes"] = notes;
    }
    if (subject) {
        parameters[@"subject"] = subject;
    }

    NSString *path = @"v1/users/me/educational_background/schools";
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putUpdateSchoolWithID:(NSString *)id
                         name:(NSString *)name
                    beginDate:(NSString *)beginDate
                       degree:(NSString *)degree
                      endDate:(NSString *)endDate
                        notes:(NSString *)notes
                      subject:(NSString *)subject
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure {
    if (!id) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name) {
        parameters[@"name"] = name;
    }
    if (beginDate) {
        parameters[@"begin_date"] = beginDate;
    }
    if (degree) {
        parameters[@"degree"] = degree;
    }
    if (endDate) {
        parameters[@"end_date"] = endDate;
    }
    if (notes) {
        parameters[@"notes"] = notes;
    }
    if (subject) {
        parameters[@"subject"] = subject;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/educational_background/schools/%@", id];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteSchoolWithID:(NSString *)id
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *))failure {
    if (!id) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/educational_background/schools/%@", id];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putUpdatePrimarySchoolID:(NSString *)schoolID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure {
    if (!schoolID) {
        return;
    }

    NSDictionary *parameters = @{@"school_id": schoolID};
    NSString *path = @"v1/users/me/educational_background/primary_school";
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postAddQualificationWithDescription:(NSString *)description
                                    success:(void (^)(id JSON))success
                                    failure:(void (^)(NSError *error))failure {
    if (!description) {
        return;
    }

    NSDictionary *parameters = @{@"description": description};
    NSString *path = @"v1/users/me/educational_background/qualifications";
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postAddCompanyWithName:(NSString *)name
                         title:(NSString *)title
                      industry:(NSString *)industry
              formOfEmployment:(NSString *)formOfEmployment
                     beginDate:(NSString *)beginDate
                   careerLevel:(NSString *)careerLevel
                   companySize:(NSString *)companySize
                   description:(NSString *)description
                    discipline:(NSString *)discipline
                       endDate:(NSString *)endDate
                      untilNow:(BOOL)untilNow
                           url:(NSString *)URL
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure {
    if (!formOfEmployment || !industry || !name || !title) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"form_of_employment"] = formOfEmployment;
    parameters[@"industry"] = industry;
    parameters[@"name"] = name;
    parameters[@"title"] = title;
    if (beginDate) {
        parameters[@"begin_date"] = beginDate;
    }
    if (careerLevel) {
        parameters[@"career_level"] = careerLevel;
    }
    if (companySize) {
        parameters[@"company_size"] = companySize;
    }
    if (description) {
        parameters[@"description"] = description;
    }
    if (discipline) {
        parameters[@"discipline"] = discipline;
    }
    if (endDate) {
        parameters[@"end_date"] = endDate;
    }
    if (untilNow) {
        parameters[@"until_now"] = @"true";
    }
    if (URL) {
        parameters[@"url"] = URL;
    }

    NSString *path = @"v1/users/me/professional_experience/companies";
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putUpdateCompanyWithID:(NSString *)id
                          name:(NSString *)name
                         title:(NSString *)title
                      industry:(NSString *)industry
              formOfEmployment:(NSString *)formOfEmployment
                     beginDate:(NSString *)beginDate
                   careerLevel:(NSString *)careerLevel
                   companySize:(NSString *)companySize
                   description:(NSString *)description
                    discipline:(NSString *)discipline
                       endDate:(NSString *)endDate
                      untilNow:(BOOL)untilNow
                           url:(NSString *)URL
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure {
    if (!id) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (formOfEmployment) {
        parameters[@"form_of_employment"] = formOfEmployment;
    }
    if (industry) {
        parameters[@"industry"] = industry;
    }
    if (name) {
        parameters[@"name"] = name;
    }
    if (title) {
        parameters[@"title"] = title;
    }
    if (beginDate) {
        parameters[@"begin_date"] = beginDate;
    }
    if (careerLevel) {
        parameters[@"career_level"] = careerLevel;
    }
    if (companySize) {
        parameters[@"company_size"] = companySize;
    }
    if (description) {
        parameters[@"description"] = description;
    }
    if (discipline) {
        parameters[@"discipline"] = discipline;
    }
    if (endDate) {
        parameters[@"end_date"] = endDate;
    }
    if (untilNow) {
        parameters[@"until_now"] = @"true";
    }
    if (URL) {
        parameters[@"url"] = URL;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/professional_experience/companies/%@", id];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteCompanyWithID:(NSString *)id
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error))failure {
    if (!id) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/professional_experience/companies/%@", id];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putUpdateLanguageWithIdentifier:(NSString *)language
                                  skill:(NSString *)skill
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *error))failure {
    if (!language) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (skill) {
        parameters[@"skill"] = skill;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/languages/%@", language];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteLanguageWithIdentifier:(NSString *)language
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure {
    if (!language) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/languages/%@", language];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putUpdateBirthDateWithDay:(NSInteger)day
                            month:(NSInteger)month
                             year:(NSInteger)year
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {
    if (!day || !month || !year) {
        return;
    }

    NSDictionary *parameters = @{@"day": @(day), @"month": @(month), @"year": @(year)};
    NSString *path = @"v1/users/me/birth_date";
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putUpdateWebProfileWithIdentifier:(NSString *)identifier
                                      url:(NSString *)URL
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure {
    if (!identifier) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (URL) {
        parameters[@"url"] = URL;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/web_profiles/%@", identifier];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteWebProfileWithIdentifier:(NSString *)identifier
                               success:(void (^)(id JSON))success
                               failure:(void (^)(NSError *error))failure {
    if (!identifier) {
        return;
    }

    identifier = [identifier stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString *path = [NSString stringWithFormat:@"v1/users/me/web_profiles/%@", identifier];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)putUpdateProfileMessageWithUserID:(NSString *)userID
                                  message:(NSString *)profileMessage
                                 isPublic:(BOOL)isPublic
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure {
    if (!profileMessage || !userID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"message"] = profileMessage;
    if (isPublic) {
        parameters[@"public"] = @"true";
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/%@/profile_message", userID];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

@end
