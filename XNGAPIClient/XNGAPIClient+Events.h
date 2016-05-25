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

@interface XNGAPIClient (Events)

/**
 Get the details for a given event

 https://dev.xing.com/docs/get/events/:id
 */
- (void)getEventForID:(NSString *)eventID
           userFields:(NSString *)userFields
    participantsLimit:(NSInteger)participantsLimit
              success:(void (^)(id JSON))success
              failure:(void (^)(NSError *))failure;

/**
 Get the participants for a given event

 https://dev.xing.com/docs/get/events/:id/guests
 */
- (void)getEventParticipantsForID:(NSString *)eventID
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                    participation:(NSString *)participation
                       userFields:(NSString *)userFields
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *))failure;

/**
 Get a list of events for a given search term

 https://dev.xing.com/docs/get/events/find
 */
- (void)getEventSearchResultsForString:(NSString *)searchString
                                 limit:(NSInteger)limit
                              location:(NSString *)location
                                offset:(NSInteger)offset
                            userFields:(NSString *)userFields
                     participantsLimit:(NSInteger)participantsLimit
                               success:(void (^)(id JSON))success
                               failure:(void (^)(NSError *))failure;

/**
 Get a list of events the user is/was attending and/or organizing

 https://dev.xing.com/docs/get/users/me/events
 */
- (void)getEventsWithLimit:(NSInteger)limit
                    offset:(NSInteger)offset
             participation:(NSString *)participation
                timePeriod:(NSString *)timePeriod
                userFields:(NSString *)userFields
         participantsLimit:(NSInteger)participantsLimit
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *))failure;

/**
 Get a list of recommended events

 https://dev.xing.com/docs/get/events/recommendations
 */
- (void)getEventRecommendationsWithLimit:(NSInteger)limit
                                  offset:(NSInteger)offset
                              userFields:(NSString *)userFields
                       participantsLimit:(NSInteger)participantsLimit
                                 success:(void (^)(id JSON))success
                                 failure:(void (^)(NSError *))failure;

/**
 Get a list of events that your contacts will be attending

 https://dev.xing.com/docs/get/events/contacts
 */
- (void)getEventsOfContactsWithLimit:(NSInteger)limit
                              offset:(NSInteger)offset
                          userFields:(NSString *)userFields
                   participantsLimit:(NSInteger)participantsLimit
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *))failure;

/**
 Set the participation for a given event

 https://dev.xing.com/docs/put/events/:id/rsvp
 */
- (void)putEventParticipationForID:(NSString *)eventID
                     participation:(NSString *)participation
                           success:(void (^)(id JSON))success
                           failure:(void (^)(NSError *))failure;

@end
