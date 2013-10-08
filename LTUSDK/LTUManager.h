//
//  LTUManager.h
//  LTUSDK
//
//  Created by Adam Bednarek on 3/26/13.
//  Copyright (c) 2013 Adam Bednarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUCameraView.h"
#import "LTUClient.h"
#import "LTUProject.h"
#import "LTUMatchedImage.h"
#import "LTUMatchedVisual.h"
#import "LTUQuery.h"
#import "LTUVisual.h"
#import "LTUMetaData.h"
#import "LTUImage.h"

/**
 The `LTUManager` helps with accessing the LTU API.
*/
@interface LTUManager : NSObject

/**
 A shared instance of the LTU Manager

 @discussion A shared manager helps with using the same instance throughout the application.
 */
+ (LTUManager *)sharedManager;

/**
 Create a shared instance of the LTUManager

 @param username - LTU API Username
 @param password - LTU API Password
 */
+ (void)initializeSharedLTUManagerWithUsername:(NSString *)username
                                   andPassword:(NSString *)password;

/**
 Initialize a `LTUManager` with a `LTUClient`
 */
- (id)initWithLTUClient:(LTUClient *)client;

/**
 Retreive a list of `LTUProject` objects from the LTU API

 @param success - Block to be executed when successfully downloading a list of projects
 @param failure - Block to be executed when retrieving the projects failed.
 @param finished - Block that's always executed AFTER the success/failure blocks
 */
- (void)getProjectsWithSuccess:(void (^)(NSArray *projectList))success
                       failure:(void (^)(NSError *error))failure
                      finished:(void (^)())finished;


/**
 Retreive a `LTUVisual` objects from the LTU API
 
 @param visualID - Id of the visual to get
 @param success - Block to be executed when successfully getting the visual
 @param failure - Block to be executed when getting the visual failed.
 @param finished - Block that's always executed AFTER the success/failure blocks
 */
- (void)getVisualById:(NSInteger)visualID
              success:(void (^)(LTUVisual *createdVisual))success
              failure:(void (^)(NSError *error))failure
             finished:(void (^)())finished;

/**
 Search the LTU API in selected projects with image

 @param projectIDs - Array of NSNumbers representing the project IDs to search in.
 @param image - An image to search with
 @param success - Block to be executed with the `LTUQuery` on successfully searching the image
 @param failure - Block to be executed when the search image fails.
 @param finished - Block that's always executed AFTER the success/failure blocks
 */
- (void)searchInProjects:(NSArray *)projectIDs
               withImage:(UIImage *)image
                 success:(void (^)(LTUQuery *queryResult))success
                 failure:(void (^)(NSError *error))failure
                finished:(void (^)())finished;

/**
 Cancel all Search Requests
 */
- (void)cancelAllSearchRequests;

/**
 Create a Visual within a project

 @param projectID - The project to create the visual in
 @param title - Title associated with the Visual
 @param image - Image used for the visual
 @param metadataList - Array of `LTUMetaData` objects to be added when creating a visual
 @param success - Block to be executed when a visual was successfully created
 @param failure - Block to be executed when creating a visual fails
 @param finished - Block that's always executed AFTER the success/failure blocks
 */
- (void)createVisualInProject:(NSInteger)projectID
                    withTitle:(NSString *)title
                    withImage:(UIImage *)image
                  andMetadata:(NSArray*)metadataArray
                      success:(void (^)(LTUVisual *createdVisual))success
                      failure:(void (^)(NSError *error))failure
                     finished:(void (^)())finished;

/**
 Cancel all requests

 @discussion This method will cancel all current requests which include: Searching images, creating visuals, and getting a list of projects.
 */
- (void)cancelAllRequests;

@end
