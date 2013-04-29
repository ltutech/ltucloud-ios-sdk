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
    LTUClient *client = [[LTUClient alloc] initWithBaseURL:@"https://api.lookthatup.com/"
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
 @param success A block that gets executed when retrieving the resource list succesfully
 @param failure A block that gets executed when retriveing the list fails
 */
- (void)getResourceListOfType:(Class)rType
                        success:(void (^)(NSArray *resourceList))success
                        failure:(void (^)(NSError *error))failure;

/**
 Create a particular lookthatup resource, such as `LTUVisual`, `LTUQuery`, etc

 @param rData The resource data which is a subclass of `LTUResourceData`, such as `LTUQuery` or `LTUVisual`
 @param success A block that gets executed when creating the resource succeeds, returning the newly created resource.
 @param failure A block that gets executed when resource creation fails
 */
- (void)createResourceWithData:(LTUResourceData *)rData
                       success:(void (^)(LTUResourceData *responseData))success
                       failure:(void (^)(NSError *error))failure;

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
