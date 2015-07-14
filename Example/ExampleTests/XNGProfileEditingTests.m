#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import <XNGAPIClient/UIImage+Base64Encoding.h>
#import <XNGAPIClient/XNGAPI.h>

@interface XNGProfileEditingTests : XCTestCase

@property (nonatomic) XNGTestHelper *testHelper;

@end

@implementation XNGProfileEditingTests

- (void)setUp {
    [super setUp];

    self.testHelper = [[XNGTestHelper alloc] init];
    [self.testHelper setup];
}

- (void)tearDown {
    [super tearDown];
    [self.testHelper tearDown];
}

- (void)testUpdateWantsHavesInterests {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateUsersGeneralInformationWithHaves:@"more kittens,tests"
                                                                     interests:@"unit testing"
                                                                         wants:@"100% test coverage, world peace"
                                                                       success:nil
                                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);

        expect([body valueForKey:@"haves"]).to.equal(@"more kittens,tests");
        [body removeObjectForKey:@"haves"];
        expect([body valueForKey:@"interests"]).to.equal(@"unit testing");
        [body removeObjectForKey:@"interests"];
        expect([body valueForKey:@"wants"]).to.equal(@"100% test coverage, world peace");
        [body removeObjectForKey:@"wants"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateUserProfilePicture {
    __block UIImage *image = [UIImage imageNamed:@"testimage.jpg"];
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateUsersProfilePictureWithImage:image
                                                                   success:nil
                                                                   failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/photo");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);

        NSDictionary *photo = [body valueForKey:@"photo"];
        expect([photo valueForKey:@"file_name"]).toNot.beNil();
        expect([photo valueForKey:@"content"]).to.equal([image xng_base64]);
        expect([photo valueForKey:@"mime_type"]).to.equal(@"image/jpeg");
        expect(body).toNot.beNil();
    }];
}

- (void)testDeleteUsersProfilePicture {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteUsersProfilePictureWithSuccess:nil
                                                                  failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/photo");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateUsersPrivateAddress {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateUsersPrivateAddressWithCity:@"Hamburg"
                                                                  country:@"DE"
                                                                    email:@"iphone@xing.com"
                                                                      fax:@"49|40|41913111"
                                                              mobilePhone:@"49|173|4191310"
                                                                    phone:@"49|40|4191310"
                                                                 province:@"Hamburg"
                                                                   street:@"Dammtorstr. 30"
                                                                  zipCode:@"20354"
                                                                  success:nil
                                                                  failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/private_address");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"city"]).to.equal(@"Hamburg");
        [body removeObjectForKey:@"city"];
        expect([body valueForKey:@"country"]).to.equal(@"DE");
        [body removeObjectForKey:@"country"];
        expect([body valueForKey:@"email"]).to.equal(@"iphone@xing.com");
        [body removeObjectForKey:@"email"];
        expect([body valueForKey:@"fax"]).to.equal(@"49|40|41913111");
        [body removeObjectForKey:@"fax"];
        expect([body valueForKey:@"mobile_phone"]).to.equal(@"49|173|4191310");
        [body removeObjectForKey:@"mobile_phone"];
        expect([body valueForKey:@"phone"]).to.equal(@"49|40|4191310");
        [body removeObjectForKey:@"phone"];
        expect([body valueForKey:@"province"]).to.equal(@"Hamburg");
        [body removeObjectForKey:@"province"];
        expect([body valueForKey:@"street"]).to.equal(@"Dammtorstr. 30");
        [body removeObjectForKey:@"street"];
        expect([body valueForKey:@"zip_code"]).to.equal(@"20354");
        [body removeObjectForKey:@"zip_code"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateUsersBusinessAddress {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateUsersBusinessAddressWithCity:@"Hamburg"
                                                                   country:@"DE"
                                                                     email:@"iphone@xing.com"
                                                                       fax:@"49|40|41913111"
                                                               mobilePhone:@"49|173|4191310"
                                                                     phone:@"49|40|4191310"
                                                                  province:@"Hamburg"
                                                                    street:@"Dammtorstr. 30"
                                                                   zipCode:@"20354"
                                                                   success:nil
                                                                   failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/business_address");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"city"]).to.equal(@"Hamburg");
        [body removeObjectForKey:@"city"];
        expect([body valueForKey:@"country"]).to.equal(@"DE");
        [body removeObjectForKey:@"country"];
        expect([body valueForKey:@"email"]).to.equal(@"iphone@xing.com");
        [body removeObjectForKey:@"email"];
        expect([body valueForKey:@"fax"]).to.equal(@"49|40|41913111");
        [body removeObjectForKey:@"fax"];
        expect([body valueForKey:@"mobile_phone"]).to.equal(@"49|173|4191310");
        [body removeObjectForKey:@"mobile_phone"];
        expect([body valueForKey:@"phone"]).to.equal(@"49|40|4191310");
        [body removeObjectForKey:@"phone"];
        expect([body valueForKey:@"province"]).to.equal(@"Hamburg");
        [body removeObjectForKey:@"province"];
        expect([body valueForKey:@"street"]).to.equal(@"Dammtorstr. 30");
        [body removeObjectForKey:@"street"];
        expect([body valueForKey:@"zip_code"]).to.equal(@"20354");
        [body removeObjectForKey:@"zip_code"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testCreateSchool {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] postCreateSchoolWithName:@"Hogwarts"
                                                    beginDate:@"1991"
                                                       degree:@"Senior Magician"
                                                      endDate:@"1998"
                                                        notes:@"#1 hero"
                                                      subject:@"Dark Arts"
                                                      success:nil
                                                      failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/educational_background/schools");
        expect(request.HTTPMethod).to.equal(@"POST");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"name"]).to.equal(@"Hogwarts");
        [body removeObjectForKey:@"name"];
        expect([body valueForKey:@"begin_date"]).to.equal(@"1991");
        [body removeObjectForKey:@"begin_date"];
        expect([body valueForKey:@"degree"]).to.equal(@"Senior Magician");
        [body removeObjectForKey:@"degree"];
        expect([body valueForKey:@"end_date"]).to.equal(@"1998");
        [body removeObjectForKey:@"end_date"];
        expect([body valueForKey:@"notes"]).to.equal(@"#1 hero");
        [body removeObjectForKey:@"notes"];
        expect([body valueForKey:@"subject"]).to.equal(@"Dark Arts");
        [body removeObjectForKey:@"subject"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateSchool {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateSchoolWithID:@"345"
                                                      name:@"Hogwarts"
                                                 beginDate:@"1991"
                                                    degree:@"Senior Magician"
                                                   endDate:@"1998"
                                                     notes:@"#1 hero"
                                                   subject:@"Dark Arts"
                                                   success:nil
                                                   failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/educational_background/schools/345");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"name"]).to.equal(@"Hogwarts");
        [body removeObjectForKey:@"name"];
        expect([body valueForKey:@"begin_date"]).to.equal(@"1991");
        [body removeObjectForKey:@"begin_date"];
        expect([body valueForKey:@"degree"]).to.equal(@"Senior Magician");
        [body removeObjectForKey:@"degree"];
        expect([body valueForKey:@"end_date"]).to.equal(@"1998");
        [body removeObjectForKey:@"end_date"];
        expect([body valueForKey:@"notes"]).to.equal(@"#1 hero");
        [body removeObjectForKey:@"notes"];
        expect([body valueForKey:@"subject"]).to.equal(@"Dark Arts");
        [body removeObjectForKey:@"subject"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteSchool {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteSchoolWithID:@"789"
                                                success:nil
                                                failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/educational_background/schools/789");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdatePrimarySchool {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdatePrimarySchoolWithID:@"123"
                                                          success:nil
                                                          failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/educational_background/primary_school");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"school_id"]).to.equal(@"123");
        [body removeObjectForKey:@"school_id"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testAddQualification {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] postAddQualificationWithDescription:@"Magician"
                                                                 success:nil
                                                                 failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/educational_background/qualifications");
        expect(request.HTTPMethod).to.equal(@"POST");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"description"]).to.equal(@"Magician");
        [body removeObjectForKey:@"description"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testAddCompany {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] postAddCompanyWithName:@"XING AG"
                                                      title:@"XNGAPIClient Developer"
                                                 industries:@"210100"
                                           formOfEmployment:@"VOLUNTEER"
                                                  beginDate:@"2013"
                                                careerLevel:@"SENIOR_EXECUTIVE"
                                                companySize:@"501-1000"
                                                description:@"XING AG"
                                                 discipline:@"IT_AND_SOFTWARE_DEVELOPMENT"
                                                    endDate:nil
                                                   untilNow:YES
                                                        url:@"https://xing.com"
                                                    success:nil
                                                    failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/professional_experience/companies");
        expect(request.HTTPMethod).to.equal(@"POST");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"name"]).to.equal(@"XING AG");
        [body removeObjectForKey:@"name"];
        expect([body valueForKey:@"title"]).to.equal(@"XNGAPIClient Developer");
        [body removeObjectForKey:@"title"];
        expect([body valueForKey:@"industries"]).to.equal(@"210100");
        [body removeObjectForKey:@"industries"];
        expect([body valueForKey:@"form_of_employment"]).to.equal(@"VOLUNTEER");
        [body removeObjectForKey:@"form_of_employment"];
        expect([body valueForKey:@"begin_date"]).to.equal(@"2013");
        [body removeObjectForKey:@"begin_date"];
        expect([body valueForKey:@"career_level"]).to.equal(@"SENIOR_EXECUTIVE");
        [body removeObjectForKey:@"career_level"];
        expect([body valueForKey:@"company_size"]).to.equal(@"501-1000");
        [body removeObjectForKey:@"company_size"];
        expect([body valueForKey:@"description"]).to.equal(@"XING AG");
        [body removeObjectForKey:@"description"];
        expect([body valueForKey:@"discipline"]).to.equal(@"IT_AND_SOFTWARE_DEVELOPMENT");
        [body removeObjectForKey:@"discipline"];
        expect([body valueForKey:@"end_date"]).to.beNil();
        expect([body valueForKey:@"until_now"]).to.equal(@"true");
        [body removeObjectForKey:@"until_now"];
        expect([body valueForKey:@"url"]).to.equal(@"https://xing.com");
        [body removeObjectForKey:@"url"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateCompany {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateCompanyWithID:@"456"
                                                       name:@"XING AG"
                                                      title:@"XNGAPIClient Developer"
                                                 industries:@"210100"
                                           formOfEmployment:@"VOLUNTEER"
                                                  beginDate:@"2013"
                                                careerLevel:@"SENIOR_EXECUTIVE"
                                                companySize:@"501-1000"
                                                description:@"XING AG"
                                                 discipline:@"IT_AND_SOFTWARE_DEVELOPMENT"
                                                    endDate:nil
                                                   untilNow:@(YES)
                                                        url:@"https://xing.com"
                                                    success:nil
                                                    failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/professional_experience/companies/456");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"name"]).to.equal(@"XING AG");
        [body removeObjectForKey:@"name"];
        expect([body valueForKey:@"title"]).to.equal(@"XNGAPIClient Developer");
        [body removeObjectForKey:@"title"];
        expect([body valueForKey:@"industries"]).to.equal(@"210100");
        [body removeObjectForKey:@"industries"];
        expect([body valueForKey:@"form_of_employment"]).to.equal(@"VOLUNTEER");
        [body removeObjectForKey:@"form_of_employment"];
        expect([body valueForKey:@"begin_date"]).to.equal(@"2013");
        [body removeObjectForKey:@"begin_date"];
        expect([body valueForKey:@"career_level"]).to.equal(@"SENIOR_EXECUTIVE");
        [body removeObjectForKey:@"career_level"];
        expect([body valueForKey:@"company_size"]).to.equal(@"501-1000");
        [body removeObjectForKey:@"company_size"];
        expect([body valueForKey:@"description"]).to.equal(@"XING AG");
        [body removeObjectForKey:@"description"];
        expect([body valueForKey:@"discipline"]).to.equal(@"IT_AND_SOFTWARE_DEVELOPMENT");
        [body removeObjectForKey:@"discipline"];
        expect([body valueForKey:@"end_date"]).to.equal([NSNull null]);
        [body removeObjectForKey:@"end_date"];
        expect([body valueForKey:@"until_now"]).to.equal(@(YES));
        [body removeObjectForKey:@"until_now"];
        expect([body valueForKey:@"url"]).to.equal(@"https://xing.com");
        [body removeObjectForKey:@"url"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteCompany {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteCompanyWithID:@"567"
                                                 success:nil
                                                 failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/professional_experience/companies/567");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdatePrimaryCompany {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdatePrimaryCompanyWithID:@"123"
                                                           success:nil
                                                           failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/professional_experience/primary_company");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"company_id"]).to.equal(@"123");
        [body removeObjectForKey:@"company_id"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateLanguage {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateLanguageWithIdentifier:@"de"
                                                               skill:@"NATIVE"
                                                             success:nil
                                                             failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/languages/de");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"skill"]).to.equal(@"NATIVE");
        [body removeObjectForKey:@"skill"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteLanguage {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteLanguageWithIdentifier:@"de"
                                                          success:nil
                                                          failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/languages/de");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateBirthday {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateBirthDateWithDay:15
                                                         month:6
                                                          year:1991
                                                       success:nil
                                                       failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/birth_date");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"day"]).to.equal(@15);
        [body removeObjectForKey:@"day"];
        expect([body valueForKey:@"month"]).to.equal(@6);
        [body removeObjectForKey:@"month"];
        expect([body valueForKey:@"year"]).to.equal(@1991);
        [body removeObjectForKey:@"year"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateWebProfile {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateWebProfileWithIdentifier:@"twitter"
                                                                   url:@"https://twitter.com/xingdevs"
                                                               success:nil
                                                               failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/web_profiles/twitter");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"url"]).to.equal(@"https://twitter.com/xingdevs");
        [body removeObjectForKey:@"url"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testDeleteWebProfile {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] deleteWebProfileWithIdentifier:@"second life"
                                                            success:nil
                                                            failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/web_profiles/second life"); // weird test helper bevaviour
        expect(request.HTTPMethod).to.equal(@"DELETE");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testUpdateProfileMessage {
    [self.testHelper executeCall:^{
        [[XNGAPIClient sharedClient] putUpdateProfileMessageWithUserID:@"456_789"
                                                               message:@"Everything is awesome"
                                                              isPublic:YES
                                                               success:nil
                                                               failure:nil];
    } withExpectations:^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
        expect(request.URL.host).to.equal(@"api.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/456_789/profile_message");
        expect(request.HTTPMethod).to.equal(@"PUT");

        expect([query allKeys]).to.haveCountOf(0);
        expect([body valueForKey:@"message"]).to.equal(@"Everything is awesome");
        [body removeObjectForKey:@"message"];
        expect([body valueForKey:@"public"]).to.equal(@"true");
        [body removeObjectForKey:@"public"];
        expect([body allKeys]).to.haveCountOf(0);
    }];
}

@end
