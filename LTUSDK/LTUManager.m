//
//  LTUManager.m
//  LTUSDK
//
//  Created by Adam Bednarek on 3/26/13.
//  Copyright (c) 2013 Adam Bednarek. All rights reserved.
//

#import "LTUManager.h"

// Default LTU API Base URL:
static NSString *const kLTUBaseURL = @"https://cloud.ltutech.com";
static NSString *const kLTUSource  = @"LTUiOSMobileSDK";

// Shared Manager
static LTUManager *_sharedManager = nil;

@interface LTUManager()

@property (nonatomic, strong) LTUClient *client;

@end

@implementation LTUManager

+ (LTUManager *)sharedManager
{
  return _sharedManager;
}

+ (void)initializeSharedLTUManagerWithUsername:(NSString *)username
                                   andPassword:(NSString *)password
{
  // Note:  It's possible to call the init several times to change the sharedManager.
  @synchronized(self)
  {
    LTUClient *client = [[LTUClient alloc] initWithBaseURL:[NSURL URLWithString:kLTUBaseURL]
                                                  withUser:username
                                               andPassword:password];
    _sharedManager = [[LTUManager alloc] initWithLTUClient:client];
  }
}

- (id)initWithLTUClient:(LTUClient *)client
{
  if ((self = [super init]))
  {
    self.client = client;
  }
  return self;
}

- (void)getProjectsWithSuccess:(void (^)(NSArray *projectList))success
                       failure:(void (^)(NSError *error))failure
                      finished:(void (^)())finished
{
  [self.client getResourceListOfType:[LTUProject class]
   success:^(NSArray *projectList)
   {
     if (success)
     {
       success(projectList);
       finished();
     }
   }
   failure:^(NSError *error)
   {
     if (failure)
     {
       failure(error);
       finished();
     }
   }];
}

- (void)searchInProjects:(NSArray *)projectIDs
               withImage:(UIImage *)image
                 success:(void (^)(LTUQuery *queryResult))success
                 failure:(void (^)(NSError *error))failure
                finished:(void (^)())finished
{
  LTUQuery *queryData = [[LTUQuery alloc] initWithImage:image
                                               projects:projectIDs
                                                 source:kLTUSource];

  [self.client createResourceWithData:queryData
    success:^(LTUResourceData *responseData)
    {
      if (success)
      {
        success((LTUQuery*)responseData);
        finished();
      }
    }
    failure:^(NSError *error) {
      if (failure)
      {
        failure(error);
        finished();
      }
    }];
}

- (void)cancelAllSearchRequests
{
  [self.client cancelPostRequestAtPath:[LTUQuery resourceListPath]];
}

- (void)createVisualInProject:(NSInteger)projectID
                    withTitle:(NSString *)title
                    withImage:(UIImage *)image
                  andMetadata:(NSArray*)metadataArray
                      success:(void (^)(LTUVisual *createdVisual))success
                      failure:(void (^)(NSError *error))failure
                     finished:(void (^)())finished

{
  LTUVisual *visualData = [[LTUVisual alloc] initWithProject:projectID
                                                   withTitle:title image:image
                                                 imageSource:kLTUSource
                                                 andMetaData:metadataArray];
  [self.client createResourceWithData:visualData
    success:^(LTUResourceData *responseData)
    {
      if (success)
      {
        success((LTUVisual *)responseData);
        finished();
      }
    }
    failure:^(NSError *error)
    {
      if (failure)
      {
        failure(error);
        finished();
      }
    }];
}

- (void)cancelAllRequests
{
  [self.client cancelAllRequests];
}

@end
