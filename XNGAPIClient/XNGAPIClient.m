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

#import <XNGOAuth1Client/XNGOAuth1Client.h>
#import "XNGAPIClient.h"
#import "NSString+URLEncoding.h"
#import "NSDictionary+Typecheck.h"
#import "XNGOAuthHandler.h"
#import "XNGOAuthToken.h"
#import "NSError+XWS.h"

typedef void(^XNGAPILoginOpenURLBlock)(NSURL*openURL);
static NSDictionary * XNGParametersFromQueryString(NSString *queryString);

@interface XNGAPIClient()
@property(nonatomic, strong, readwrite) XNGOAuthHandler *oAuthHandler;
@property(nonatomic, strong, readwrite) NSString *callbackScheme;
@property(nonatomic, copy, readwrite) XNGAPILoginOpenURLBlock loginOpenURLBlock;
@end

@implementation XNGAPIClient

NSString * const XNGAPIClientInvalidTokenErrorNotification = @"com.xing.apiClient.error.invalidToken";
NSString * const XNGAPIClientDeprecationErrorNotification = @"com.xing.apiClient.error.deprecatedAPI";
NSString * const XNGAPIClientDeprecationWarningNotification = @"com.xing.apiClient.warning.deprecatedAPI";

static XNGAPIClient *_sharedClient = nil;

+ (XNGAPIClient *)clientWithBaseURL:(NSURL *)url {
    return [[XNGAPIClient alloc] initWithBaseURL:url];
}

+ (XNGAPIClient *)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil) {
            NSURL *baseURL = [NSURL URLWithString:@"https://api.xing.com"];
            _sharedClient = [[XNGAPIClient alloc] initWithBaseURL:baseURL];
        }
    });
    return _sharedClient;
}

+ (void)setSharedClient:(XNGAPIClient *)sharedClient {
    _sharedClient = sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        _oAuthHandler = [[XNGOAuthHandler alloc] init];
#ifndef TARGET_OS_MAC
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
#endif
        self.accessToken = [self accessTokenFromKeychain];
    }
    return self;
}

- (void)addAcceptableContentTypes:(NSSet *)set {
    NSMutableSet *oldSet = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
    for (NSString *contentType in set) {
        [oldSet addObject:contentType];
    }
    [self.responseSerializer setAcceptableContentTypes:oldSet];
}

#pragma mark - Getters / Setters

- (NSString *)callbackScheme {
    if (!_callbackScheme) {
        _callbackScheme =[NSString stringWithFormat:@"xingapp%@",self.key];
    }
    return _callbackScheme;
}

- (NSURL *)baseURL {
    return self.url;
}

- (void)setUserAgent:(NSString *)userAgent {
    [self.defaultHeaders setValue:userAgent forKey:@"User-Agent"];
}

#pragma mark - handling login / logout

- (BOOL)isLoggedin {
    return [self.oAuthHandler hasAccessToken] &&
        [self.oAuthHandler hasTokenSecret] &&
        [self.oAuthHandler hasUserID];
}

- (void)logout {
    [self.oAuthHandler deleteKeychainEntries];
    self.accessToken = nil;
}

static inline void XNGAPIClientCanLoginTests(XNGAPIClient *client) {
    if (client.isLoggedin) {
        [[client exceptionForUserAlreadyLoggedIn] raise];
        return;
    }
    
    if ([client.key length] == 0) {
        [[client exceptionForNoConsumerKey] raise];
        return;
    }
    
    if ([client.secret length] == 0) {
        [[client exceptionForNoConsumerSecret] raise];
        return;
    }
}

static NSString * const XNGAPIClientOAuthRequestTokenPath = @"v1/request_token";
static NSString * const XNGAPIClientOAuthAuthorizationPath = @"v1/authorize";
static NSString * const XNGAPIClientOAuthAccessTokenPath = @"v1/access_token";


- (void)loginOAuthWithSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure {
    
    XNGAPIClientCanLoginTests(self);
    
    NSURL *callbackURL = [self oauthCallbackURL];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self authorizeUsingOAuthWithRequestTokenPath:XNGAPIClientOAuthRequestTokenPath
                            userAuthorizationPath:XNGAPIClientOAuthAuthorizationPath
                                      callbackURL:callbackURL
                                  accessTokenPath:XNGAPIClientOAuthAccessTokenPath
                                     accessMethod:@"POST"
                                            scope:nil
                                          success:
     ^(XNGOAuthToken *accessToken, id responseObject) {
         NSString *userID = [accessToken.userInfo xng_stringForKey:@"user_id"];
         [weakSelf.oAuthHandler saveUserID:userID
                               accessToken:accessToken.key
                                    secret:accessToken.secret
                                   success:success
                                   failure:failure];
     } failure:^(NSError *error) {
         failure(error);
     }];
}


- (void)loginOAuthAuthorize:(void (^)(NSURL *))authorizeBlock
                   loggedIn:(void (^)())loggedInBlock
                   failuire:(void (^)(NSError *))failureBlock {

    XNGAPIClientCanLoginTests(self);
    
    NSURL *callbackURL = [self oauthCallbackURL];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];

    __weak __typeof(&*self)weakSelf = self;
    
    [self acquireOAuthRequestTokenWithPath:XNGAPIClientOAuthRequestTokenPath
                               callbackURL:callbackURL
                              accessMethod:@"POST"
                                     scope:nil
                                   success:
     ^(XNGOAuthToken *requestToken, id responseObject) {
         
         weakSelf.loginOpenURLBlock = [weakSelf loginOpenURLBlockWithRequestToken:requestToken loggedIn:loggedInBlock failuire:failureBlock];

         NSDictionary *parameters = @{@"oauth_token": requestToken.key};
         NSURL *authURL = [weakSelf oAuthAuthorizationURLWithParameters:parameters];
         authorizeBlock(authURL);
     }
                                   failure:
     ^(NSError *error) {
         failureBlock(error);
     }];
    
}

- (XNGAPILoginOpenURLBlock) loginOpenURLBlockWithRequestToken:(XNGOAuthToken*)requestToken
                                                     loggedIn:(void (^)())loggedInBlock
                                                     failuire:(void (^)(NSError *))failureBlock  {
    __weak __typeof(&*self)weakSelf = self;
    
    return ^(NSURL*openURL){
        
        NSDictionary *queryDictionary = XNGParametersFromQueryString(openURL.query);
        requestToken.verifier = queryDictionary[@"oauth_verifier"];
        
        [weakSelf acquireOAuthAccessTokenWithPath:XNGAPIClientOAuthAccessTokenPath
                                 requestToken:requestToken
                                 accessMethod:@"POST"
                                      success:^(XNGOAuthToken *accessToken, id responseObject) {
                                          [weakSelf saveAuthDataFromToken:accessToken success:loggedInBlock failure:failureBlock];
                                          loggedInBlock();
                                      } failure:failureBlock];
    };
}
- (void) saveAuthDataFromToken:(XNGOAuthToken*)accessToken
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure  {
    self.accessToken = accessToken;
    NSString *userID = [accessToken.userInfo xng_stringForKey:@"user_id"];
    [self.oAuthHandler saveUserID:userID
                      accessToken:accessToken.key
                           secret:accessToken.secret
                          success:success
                          failure:failure];
}


- (BOOL)handleOpenURL:(NSURL *)URL {
    if([[URL scheme] isEqualToString:self.callbackScheme] == NO) {
        return NO;
    }
    
    if (self.loginOpenURLBlock) {
        self.loginOpenURLBlock(URL);
        self.loginOpenURLBlock = nil;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:URL forKey:kAFApplicationLaunchOptionsURLKey];
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification
                                                                 object:nil
                                                               userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    return YES;
}

- (void)loginXAuthWithUsername:(NSString*)username
                      password:(NSString*)password
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure {
    
    XNGAPIClientCanLoginTests(self);
    
    [self postRequestXAuthAccessTokenWithUsername:username
                                         password:password
                                          success:
     ^(AFHTTPRequestOperation *operation, id responseJSON) {
         NSString *body = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
         NSDictionary *xAuthResponseFields = [NSString xng_URLDecodedDictionaryFromString:body];
         
         [self.oAuthHandler saveXAuthResponseParametersToKeychain:xAuthResponseFields
                                                          success:^{
                                                              self.accessToken = [self accessTokenFromKeychain];
                                                              if (success) success();
                                                          }
                                                          failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}

- (void)postRequestXAuthAccessTokenWithUsername:(NSString*)username
                                       password:(NSString*)password
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSParameterAssert(username);
    NSParameterAssert(password);
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"x_auth_username"] = username;
    parameters[@"x_auth_password"] = password;
    parameters[@"x_auth_mode"] = @"client_auth";
    parameters[@"oauth_consumer_key"] = self.key;
    
    NSString* path = [NSString stringWithFormat:@"%@/v1/xauth", self.baseURL];

    [self POST:path parameters:parameters success:success failure:failure];
}

- (XNGOAuthToken*)accessTokenFromKeychain {
    if (self.oAuthHandler.accessToken && self.oAuthHandler.tokenSecret) {
        return [[XNGOAuthToken alloc] initWithKey:self.oAuthHandler.accessToken secret:self.oAuthHandler.tokenSecret session:nil expiration:nil renewable:YES];
    }
    return nil;
}

#pragma mark - block-based GET / PUT / POST / DELETE

- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    [self getJSONPath:path
           parameters:parameters
         acceptHeader:nil
              success:success
              failure:failure];
}

- (void)putJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    [self putJSONPath:path
           parameters:parameters
         acceptHeader:nil
              success:success
              failure:failure];
}

- (void)postJSONPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(id JSON))success
             failure:(void (^)(NSError *error))failure {
    [self postJSONPath:path
            parameters:parameters
          acceptHeader:nil
               success:success
               failure:failure];
}

- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(id JSON))success
               failure:(void (^)(NSError *error))failure {
    [self deleteJSONPath:path
              parameters:parameters
            acceptHeader:nil
                 success:success
                 failure:failure];
}

#pragma mark - block-based GET / DELETE with additional headers

- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
  additionalHeaders:(NSDictionary *)headers
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    [self getJSONPath:path
           parameters:parameters
         acceptHeader:nil
    additionalHeaders:headers
              success:success
              failure:failure];
}

- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
  additionalHeaders:(NSDictionary *)headers
               success:(void (^)(id JSON))success
               failure:(void (^)(NSError *error))failure {
    [self deleteJSONPath:path
              parameters:parameters
            acceptHeader:nil
       additionalHeaders:headers
                 success:success
                 failure:failure];
}

#pragma mark - block-based PUT and POST with JSON parameters

- (void)putJSONPath:(NSString *)path
     JSONParameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    [self putJSONPath:path JSONParameters:parameters uploadProgress:nil success:success failure:failure];
}

- (void)putJSONPath:(NSString *)path
     JSONParameters:(NSDictionary *)parameters
     uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT"
                                                      path:path
                                                parameters:parameters];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [self xng_HTTPRequestOperationWithRequest:request
                                                                          success:success
                                                                          failure:failure];
    [operation setUploadProgressBlock:uploadProgress];
    [self.operationQueue addOperation:operation];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
}

- (void)postJSONPath:(NSString *)path
      JSONParameters:(NSDictionary *)parameters
             success:(void (^)(id JSON))success
             failure:(void (^)(NSError *error))failure {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST"
                                                      path:path
                                                parameters:parameters];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [self xng_HTTPRequestOperationWithRequest:request
                                                                          success:success
                                                                          failure:failure];
    [self.operationQueue addOperation:operation];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
}

#pragma mark - block-based PUT and POST with JSON parameters and additional headers

- (void)putJSONPath:(NSString *)path
     JSONParameters:(NSDictionary *)parameters
  additionalHeaders:(NSDictionary *)headers
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    [self putJSONPath:path JSONParameters:parameters additionalHeaders:headers uploadProgress:nil success:success failure:failure];
}

- (void)putJSONPath:(NSString *)path
     JSONParameters:(NSDictionary *)parameters
  additionalHeaders:(NSDictionary *)headers
     uploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT"
                                                      path:path
                                                parameters:parameters];
    for (NSString *key in [headers allKeys]) {
        [request setValue:[headers xng_stringForKey:key] forHTTPHeaderField:key];
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [self xng_HTTPRequestOperationWithRequest:request
                                                                          success:success
                                                                          failure:failure];
    [operation setUploadProgressBlock:uploadProgress];
    [self.operationQueue addOperation:operation];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
}

- (void)postJSONPath:(NSString *)path
      JSONParameters:(NSDictionary *)parameters
   additionalHeaders:(NSDictionary *)headers
             success:(void (^)(id JSON))success
             failure:(void (^)(NSError *error))failure {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST"
                                                      path:path
                                                parameters:parameters];
    for (NSString *key in [headers allKeys]) {
        [request setValue:[headers xng_stringForKey:key] forHTTPHeaderField:key];
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [self xng_HTTPRequestOperationWithRequest:request
                                                                          success:success
                                                                          failure:failure];
    [self.operationQueue addOperation:operation];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
}

#pragma mark - block-based GET / PUT / POST / DELETE with optional accept headers

- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       acceptHeader:(NSString *)acceptHeader
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)putJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       acceptHeader:(NSString *)acceptHeader
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)postJSONPath:(NSString *)path
          parameters:(NSDictionary *)parameters
        acceptHeader:(NSString *)acceptHeader
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
          acceptHeader:(NSString *)acceptHeader
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

#pragma mark - block-based GET / PUT / POST / DELETE with optional accept headers and additional headers

- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       acceptHeader:(NSString *)acceptHeader
  additionalHeaders:(NSDictionary *)headers
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    for (NSString *key in [headers allKeys]) {
        [request setValue:[headers xng_stringForKey:key] forHTTPHeaderField:key];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
          acceptHeader:(NSString *)acceptHeader
     additionalHeaders:(NSDictionary *)headers
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    if (acceptHeader) {
        [self addAcceptableContentTypes:[NSSet setWithObject:acceptHeader]];
        [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    }
    for (NSString *key in [headers allKeys]) {
        [request setValue:[headers xng_stringForKey:key] forHTTPHeaderField:key];
    }
    NSOperation *operation = [self xng_HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

#pragma mark - OAuth related methods

- (NSString *)currentUserID {
    return self.oAuthHandler.userID;
}

- (void)setConsumerKey:(NSString *)consumerKey {
    self.key = consumerKey;
}

- (void)setConsumerSecret:(NSString *)consumerSecret {
    self.secret = consumerSecret;
}

#pragma mark - OAuth related methods (private)


- (NSURL*)oauthCallbackURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://success",self.callbackScheme]];
}

- (NSURL*)oAuthAuthorizationURLWithParameters:(NSDictionary*)parameters {
    NSString *oauthToken = parameters[@"oauth_token"];
    NSString *pathAndQuery = [XNGAPIClientOAuthAuthorizationPath stringByAppendingFormat:@"?oauth_token=%@", oauthToken];
    return [[NSURL URLWithString:pathAndQuery relativeToURL:self.url] absoluteURL];
}

#pragma mark - checking methods

- (void)checkForGlobalErrors:(NSHTTPURLResponse *)response
                    withJSON:(id)JSON {
    if (response.statusCode == 410) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientDeprecationErrorNotification object:nil];
        return;
    }
    if ([JSON isKindOfClass:[NSDictionary class]] &&
        [[JSON xng_stringForKey:@"error_name"] isEqualToString:@"INVALID_OAUTH_TOKEN"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientInvalidTokenErrorNotification object:nil];
        return;
    }
}

- (void)checkForDeprecation:(NSHTTPURLResponse *)response {
    if ([[response.allHeaderFields xng_stringForKey:@"X-Xing-Deprecation-Status"] isEqualToString:@"deprecated"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientDeprecationWarningNotification object:nil];
    }
}

#pragma mark - cancel requests methods

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method path:(NSString *)path {
    [self cancelAllHTTPOperationsWithMethod:method paths:@[path]];
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method paths:(NSArray *)paths {
    for (NSString* path in paths) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        NSString *pathToBeMatched = [[[self requestWithMethod:(method ?: @"GET") path:path parameters:nil] URL] path];
#pragma clang diagnostic pop

        for (NSOperation *operation in [self.operationQueue operations]) {
            if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
                continue;
            }

            BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
            BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];

            if (hasMatchingMethod && hasMatchingPath) {
                [operation cancel];
            }
        }
    }
}

- (void)cancelAllHTTPOperations {
    for (NSOperation *operation in self.operationQueue.operations) {
        operation.completionBlock = nil;
        [operation cancel];
    }
}

#pragma mark - HTTP Operation methods

- (AFHTTPRequestOperation *)xng_HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                        success:(void (^)(id responseObject))success
                                                        failure:(void (^)(NSError *error))failure {
    return [super HTTPRequestOperationWithRequest:request
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self checkForDeprecation:operation.response];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: check if JSON is returned for errors too
        [self checkForDeprecation:operation.response];
        [self checkForGlobalErrors:operation.response withJSON:operation.responseObject];
        if ([operation.responseObject isKindOfClass:[NSDictionary class]]) {
            error = [NSError xwsErrorWithStatusCode:operation.response.statusCode
                                           userInfo:operation.responseObject];
        }
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Helper methods

- (NSException *)exceptionForUserAlreadyLoggedIn {
    return [NSException exceptionWithName:@"XNGUserLoginException" reason:@"A User is already loggedIn. Use the isLoggedin method to verify that no user is logged in before you use this method." userInfo:@{@"XNGLoggedInUserID":self.currentUserID}];
}

- (NSException *)exceptionForNoConsumerKey {
    return [NSException exceptionWithName:@"XNGNoConsumerKeyException"
                                   reason:@"There is no Consumer Key set yet. Please set it first before invoking login."
                                 userInfo:nil];
}

- (NSException *)exceptionForNoConsumerSecret {
    return [NSException exceptionWithName:@"XNGNoConsumerSecretException"
                                   reason:@"There is no Consumer Secret set yet. Please set it first before invoking login."
                                 userInfo:nil];
}

static NSDictionary * XNGParametersFromQueryString(NSString *queryString) {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (queryString) {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:queryString];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value) {
                parameters[[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
    }
    
    return parameters;
}

@end
