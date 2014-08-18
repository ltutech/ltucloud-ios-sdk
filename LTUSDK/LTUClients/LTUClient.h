//
//  LTUClient.h
//
//  Created by Adam Bednarek on 5/10/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUResourceData.h"

/**
 The `LTUClient` sets up a way to interact with the lookthatup API

 How to use the `LTUClient`:
    LTUClient *client = [[LTUClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://cloud.ltutech.com"]
                                                  withUser:@"user"
                                               andPassword:@"password"];
    [LTUClient setSharedClient: client];
 */
@interface LTUClient : NSObject

///-----------------------------------------------------
/// @name Setting the shared client
///-----------------------------------------------------

/**
 Once an `LTUClient` is initialized, you can add this to the shared client
 @param sharedClient The new client to be used
 */
+ (void)setSharedClient:(LTUClient *)sharedClient;

/**
 Retrieve the shared client
 @return The shared client containing the API URL and authentication information
 */
+ (LTUClient *)sharedClient;

/**
 Method to cancel all requests being performed by the client
 */
- (void)cancelAllRequests;

/**
 Method to cancel a specific POST request

 @param path The resource path that is performing the post request to be canceled
 */
- (void)cancelPostRequestAtPath:(NSString*)path;

/**
 Get the list of a particular lookthatup resource, such as projects

 @param rType The resource type, a subclass of `LTUResourceData`
 @param params A dictionay with filter parameter for the resource to list
 @param success A block that gets executed when retrieving the resource list successfully
 @param failure A block that gets executed when retrieving the list fails
 */
- (void)getResourceListOfType:(Class)rType
               withParameters:(NSDictionary *)params
                      success:(void (^)(NSArray *resourceList))success
                      failure:(void (^)(NSError *error))failure;


/**
 Get a lookthatup resource, such as a visual with resource id
 
 @param rType The resource type, a subclass of `LTUResourceData`
 @param resourceId Id of the resource to get
 @param success A block that gets executed when retrieving the resource successfully
 @param failure A block that gets executed when retrieving a failure
 */
- (void)getResourceOfType:(Class)rType
                   withId:(NSInteger)resourceId
                  success:(void (^)(LTUResourceData *resource))success
                  failure:(void (^)(NSError *error))failure;


/**
 Get a lookthatup resource, at a specific location, since ressource can be at various location
 This function allows a more flexible use of the client.
 
 @param rType The resource type, a subclass of `LTUResourceData`
 @param url The path of the resource to get
 @param params A dictionay with filter parameter for the resource to list
 @param success A block that gets executed when retrieving the resource successfully
 @param failure A block that gets executed when retrieving a failure
 */
- (void)getResourceListOfType:(Class)rType
                        atUrl:(NSString *)url
               withParameters:(NSDictionary *)params
                      success:(void (^)(NSArray *resourceList))success
                      failure:(void (^)(NSError *error))failure;


/**
 Create a particular lookthatup resource, such as `LTUVisual`, `LTUQuery`, etc

 @param rData The resource data which is a subclass of `LTUResourceData`, such as `LTUQuery` or `LTUVisual`
 @param success A block that gets executed when creating the resource succeeds, returning the newly created resource.
 @param failure A block that gets executed when resource creation fails
 @param uploadProgressBlock A block that gets executed on upload progession
 */
- (void)createResourceWithData:(LTUResourceData *)rData
                       success:(void (^)(LTUResourceData *responseData))success
                       failure:(void (^)(NSError *error))failure
           uploadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))uploadProgressBlock;

- (void)createResourceWithData:(LTUResourceData *)rData
                   withTimeout:(int)timeout
                       success:(void (^)(LTUResourceData *responseData))success
                       failure:(void (^)(NSError *error))failure
           uploadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))uploadProgressBlock;
/**
 Create a particular lookthatup resource, such as `LTUVisual`, `LTUQuery`, etc

 @param rData The resource data which is a subclass of `LTUResourceData`, such as `LTUQuery` or `LTUVisual`
 @param withTimeout The timeout of the request
 @param success A block that gets executed when creating the resource succeeds, returning the newly created resource.
 @param failure A block that gets executed when resource creation fails
 @param uploadProgressBlock A block that gets executed on upload progession
 */


/**
 Initializes the `LTUClient` with the API URL and authentication info

 @discussion This is the designated initializer for the `LTUClient`

 @param url The base API URL for lookthatup
 @param user The username of the lookthatup account
 @param password The password of the lookthatup account
 */
- (id)initWithBaseURL:(NSURL *)url withUser:(NSString *)user andPassword:(NSString *)password;

/**
 Checks the state if at least 1 request is in progress.  Multiple requests can be in progress.

 @return boolean value returning whether a request is in progress or not
 */
- (BOOL)isRequestInProgress;

/**
 Update the authentication information of a new user

 @discussion This is handy when you want someone to log in with different lookthatup accounts in your app

 @param user The username of the user
 @param password The password of the user
 */
- (void)updateUser:(NSString *)user andPassword:(NSString *)password;

@end
