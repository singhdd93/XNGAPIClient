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

#import "XNGOAuthHandler.h"
#import "XNGAPIClient.h"
#import "NSString+URLEncoding.h"
#import "NSError+XWS.h"
#import <SAMKeychain/SAMKeychain.h>
#import "XNGAPIDataHandler.h"

static NSString *kIdentifier = @"com.xing.iphone-app-2010";
static NSString *kTokenSecretName = @"TokenSecret";//Keychain username
static NSString *kUserIDName = @"UserID";//Keychain username
static NSString *kAccessTokenName = @"AccessToken";//Keychain username

// OAuth 2 constants
static NSString *kOAuth2Identifier = @"M3F8W7J23K.com.xing.XING.OAuth2";
static NSString *kOAuth2RefreshTokenName = @"RefreshToken";
static NSString *kOAuth2UserIDName = @"UserID";
static NSString *kOAuth2AccessTokenName = @"AccessToken";
static NSString *kOAuth2ExpiresIn = @"ExpiresIn";

@interface XNGOAuthHandler ()
@property (nonatomic, strong, readwrite) NSString *accessToken;
@property (nonatomic, strong, readwrite) NSString *refreshToken;
@property (nonatomic, strong, readwrite) NSDate *expirationDate;
@property (nonatomic, strong, readwrite) NSString *userID;
@end

@interface SAMKeychain(seamlessLogin)
+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error;
+ (NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError **)error;
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error;
+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error;

@end

@implementation SAMKeychain(seamlessLogin)

+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.accessGroup = accessGroup;
    [query fetch:error];
    return query.password;
}

+ (NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError **)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.accessGroup = accessGroup;
    [query fetch:error];

    return query.passwordData;
}

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.password = password;
    query.accessGroup = accessGroup;

    return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError **)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.passwordData = password;
    query.accessGroup = accessGroup;

    return [query save:error];
}
+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *)accessGroup error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    return [query deleteItem:error];
}

@end

@implementation XNGOAuthHandler

- (instancetype)init {
    self = [super init];

    if (self) {
        [SAMKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlock];
    }

    return self;
}

#pragma mark - handling oauth consumer/secret

- (NSString *)userID {
    if (_userID == nil) {
        NSError *error;
        _userID = [SAMKeychain passwordForService:kOAuth2Identifier
                                          account:kOAuth2UserIDName
                                      accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                            error:&error];
        NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainUserIDReadError: %@", error);
    }
    return _userID;
}

- (BOOL)hasAccessToken {
    return self.accessToken.length > 0;
}

- (BOOL)hasRefreshToken {
    return self.refreshToken.length > 0;
}

- (BOOL)hasUserID {
    return self.userID.length > 0;
}

- (BOOL)hasExpirationDate {
    return self.expirationDate != nil;
}

- (NSString *)accessToken {
    if (_accessToken == nil) {
        NSError *error;
        _accessToken = [SAMKeychain passwordForService:kOAuth2Identifier
                                               account:kOAuth2AccessTokenName
                                           accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                                                 error:&error];
        NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainUserAccesstokenError: %@", error);
    }
    return _accessToken;
}

- (NSString *)refreshToken {
    if (_refreshToken  == nil) {
        NSError *error;
        _refreshToken = [SAMKeychain passwordForService:kOAuth2Identifier
                                                account:kOAuth2RefreshTokenName
                                            accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                                                  error:&error];
        NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainRefreshTokenReadError: %@", error);
    }
    return _refreshToken;
}

- (NSDate *)expirationDate {
    if (_expirationDate == nil) {
        NSError *error;
        NSData *expirationDateData = [SAMKeychain passwordDataForService:kOAuth2Identifier
                                                                 account:kOAuth2ExpiresIn
                                                             accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                                                   error:&error];
        NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainExpirationDateReadError: %@", error);

        double timeInterval;
        memcpy(&timeInterval, expirationDateData.bytes, sizeof(timeInterval));
        _expirationDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    return _expirationDate;
}

- (NSError*)xwsErrorWithAFHTTPRequestOperation:(AFHTTPRequestOperation*)operation {
    NSUInteger statusCode = operation.response.statusCode;

    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    userInfo[@"responseStatusCode"] = @(statusCode);

    NSError *xwsError = [NSError xwsErrorWithStatusCode:statusCode
                                               userInfo:userInfo];
    return xwsError;
}

- (void)saveXAuthResponseParametersToKeychain:(NSDictionary*)responseParameters
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure {
    NSString *userID = responseParameters[@"user_id"];
    NSString *accessToken = responseParameters[@"access_token"];
    NSString *refreshToken = responseParameters[@"refresh_token"];
    NSNumber *expiresIn = responseParameters[@"expires_in"];
    NSString *authTokenKey = responseParameters[@"auth_token_key"];
    NSString *apiKey = [[XNGAPIDataHandler sharedDataHandler]  consumerKey];
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:[expiresIn doubleValue]];

    [self saveUserID:userID
         accessToken:accessToken
        refreshToken:refreshToken
      expirationDate:expirationDate
             success:success
             failure:failure];

    NSError *error = nil;

    [SAMKeychain setPassword:apiKey
                  forService:kOAuth2Identifier
                     account: @"consumerKey"
                 accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                       error:&error];
    NSAssert(!error, @"KeychainUserIDWriteError: %@", error);

    [SAMKeychain setPassword:authTokenKey
                  forService:kOAuth2Identifier
                     account: @"authTokenKey"
                 accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                       error:&error];
    NSAssert(!error, @"KeychainUserIDWriteError: %@", error);

}

- (void)saveUserID:(NSString *)userID
       accessToken:(NSString *)accessToken
      refreshToken:(NSString *)refreshToken
    expirationDate:(NSDate *)expirationDate
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure {

    NSError *error = nil;

    [SAMKeychain setPassword:userID
                  forService:kOAuth2Identifier
                     account:kOAuth2UserIDName
                 accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                       error:&error];
    NSAssert(!error, @"KeychainUserIDWriteError: %@", error);
    _userID = userID;

    [SAMKeychain setPassword:accessToken
                  forService:kOAuth2Identifier
                     account:kOAuth2AccessTokenName
                 accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                       error:&error];
    NSAssert(!error, @"KeychainAccessTokenWriteError: %@", error);
    _accessToken = accessToken;

    [SAMKeychain setPassword:refreshToken
                  forService:kOAuth2Identifier
                     account:kOAuth2RefreshTokenName
                 accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                       error:&error];
    NSAssert(!error, @"KeychainRefreshTokenWriteError: %@", error);
    _refreshToken = refreshToken;

    double data = [expirationDate timeIntervalSince1970];
    [SAMKeychain setPasswordData:[NSData dataWithBytes:&data length:sizeof(data)]
                      forService:kOAuth2Identifier
                         account:kOAuth2ExpiresIn
                     accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"

                           error:&error];
    NSAssert(!error, @"KeychainExpiresInWriteError: %@", error);
    _expirationDate = expirationDate;

    if (error) {
        NSAssert(NO,@"Could not save into keychain");

        if (failure) {
            failure(error);
        }
        return;
    }

    // all finished, call success block
    if (success) {
        success();
    }
}

- (void)deleteKeychainEntries {

    NSError *error = nil;
    _userID = nil;
    [SAMKeychain deletePasswordForService:kOAuth2Identifier account:kOAuth2UserIDName
                              accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                    error:&error];
    NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainUserIDDeleteError: %@", error);

    _accessToken = nil;
    [SAMKeychain deletePasswordForService:kOAuth2Identifier account:kOAuth2AccessTokenName
                              accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                    error:&error];
    NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainAccessTokenDeleteError: %@", error);

    _refreshToken = nil;
    [SAMKeychain deletePasswordForService:kOAuth2Identifier account:kOAuth2RefreshTokenName
                              accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                    error:&error];
    NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainRefreshTokenDeleteError: %@", error);

    _expirationDate = nil;
    [SAMKeychain deletePasswordForService:kOAuth2Identifier account:kOAuth2ExpiresIn
                              accessGroup: @"M3F8W7J23K.com.xing.XING.OAuth2"
                                    error:&error];
    NSAssert(!error || [error code] == errSecItemNotFound, @"KeychainExpiresInDeleteError: %@", error);
}




@end
