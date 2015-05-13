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
            @"file_name": [self uuidImageName],
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


#pragma mark - Helper

- (NSString *)uuidImageName {
    return [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
}

@end
