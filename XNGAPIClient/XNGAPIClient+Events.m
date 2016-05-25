#import "XNGAPIClient+Events.h"

@implementation XNGAPIClient (Events)

- (void)getEventForID:(NSString *)eventID
           userFields:(NSString *)userFields
    participantsLimit:(NSInteger)participantsLimit
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure {
    if (!eventID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (participantsLimit) {
        parameters[@"with_participants"] = @(participantsLimit);
    }

    NSString *path = [NSString stringWithFormat:@"v1/events/%@", eventID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEventParticipantsForID:(NSString *)eventID
                            limit:(NSInteger)limit
                           offset:(NSInteger)offset
                    participation:(NSString *)participation
                       userFields:(NSString *)userFields
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure {
    if (!eventID) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (participation) {
        parameters[@"participations"] = participation;
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/events/%@/guests", eventID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEventSearchResultsForString:(NSString *)searchString
                                 limit:(NSInteger)limit
                              location:(NSString *)location
                                offset:(NSInteger)offset
                            userFields:(NSString *)userFields
                     participantsLimit:(NSInteger)participantsLimit
                               success:(void (^)(id))success
                               failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (searchString) {
        parameters[@"keywords"] = searchString;
    }
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (location) {
        parameters[@"location"] = location;
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (participantsLimit) {
        parameters[@"with_participants"] = @(participantsLimit);
    }

    NSString *path = @"v1/events/find";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEventsWithLimit:(NSInteger)limit
                    offset:(NSInteger)offset
             participation:(NSString *)participation
                timePeriod:(NSString *)timePeriod
                userFields:(NSString *)userFields
         participantsLimit:(NSInteger)participantsLimit
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (participation) {
        parameters[@"participation"] = participation;
    }
    if (timePeriod) {
        parameters[@"time_period"] = timePeriod;
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (participantsLimit) {
        parameters[@"with_participants"] = @(participantsLimit);
    }

    NSString *path = @"v1/users/me/events";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEventRecommendationsWithLimit:(NSInteger)limit
                                  offset:(NSInteger)offset
                              userFields:(NSString *)userFields
                       participantsLimit:(NSInteger)participantsLimit
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (participantsLimit) {
        parameters[@"with_participants"] = @(participantsLimit);
    }

    NSString *path = @"v1/events/recommendations";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getEventsOfContactsWithLimit:(NSInteger)limit
                              offset:(NSInteger)offset
                          userFields:(NSString *)userFields
                   participantsLimit:(NSInteger)participantsLimit
                             success:(void (^)(id))success
                             failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (participantsLimit) {
        parameters[@"with_participants"] = @(participantsLimit);
    }

    NSString *path = @"v1/events/contacts";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)putEventParticipationForID:(NSString *)eventID
                     participation:(NSString *)participation
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure {
    if (!eventID || !participation) {
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"selected"] = participation;

    NSString *path = [NSString stringWithFormat:@"v1/events/%@/rsvp", eventID];
    [self putJSONPath:path parameters:parameters success:success failure:failure];
}

@end
