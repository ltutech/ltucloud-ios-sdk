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
                                   andPassword:(NSString *)password;
{
    [self initializeSharedLTUManagerWithUsername:username andPassword:password initWithBaseURL:kLTUBaseURL];
}

+ (void)initializeSharedLTUManagerWithUsername:(NSString *)username
                                   andPassword:(NSString *)password
                               initWithBaseURL:(NSString *)url
{
  // Note:  It's possible to call the init several times to change the sharedManager.
  @synchronized(self)
  {
    LTUClient *client = [[LTUClient alloc] initWithBaseURL:[NSURL URLWithString:url]
                                                  withUser:username
                                               andPassword:password];
    _sharedManager = [[LTUManager alloc] initWithLTUClient:client];
  }
}

- (id)initWithLTUClient:(LTUClient *)client
{
  if ((self = [super init])) {
    self.client = client;
  }
  return self;
}

- (void)getProjectsWithSuccess:(void (^)(NSArray *projectList))success
                       failure:(void (^)(NSError *error))failure
                      finished:(void (^)())finished
{
  [self.client getResourceListOfType:[LTUProject class] withParameters:nil
   success:^(NSArray *projectList)
   {
     if (success) {
       success(projectList);
       finished();
     }
   }
   failure:^(NSError *error)
   {
     if (failure) {
       failure(error);
       finished();
     }
   }];
}

- (void)searchInProjects:(NSArray *)projectIDs
               withImage:(UIImage *)image
              withSource:(NSString *)source
          withSourceDesc:(NSString *)sourceDesc
             withTimeout:(int)timeout
                 success:(void (^)(LTUQuery *queryResult))success
                 failure:(void (^)(NSError *error))failure
                finished:(void (^)())finished
     uploadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))uploadProgressBlock
{
  LTUQuery *queryData = [[LTUQuery alloc] initWithImage:image
                                               projects:projectIDs
                                                 source:source
                                             sourceDesc:sourceDesc];

  [self.client createResourceWithData:queryData
                          withTimeout:(int)timeout
    success:^(LTUResourceData *responseData) {
      if (success) {
        success((LTUQuery*)responseData);
        finished();
      }
    }
    failure:^(NSError *error) {
      if (failure) {
        failure(error);
        finished();
      }
    }
    uploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
      if (uploadProgressBlock) {
         uploadProgressBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
      }
    }
  ];
}

- (void)cancelAllSearchRequests
{
  [self.client cancelPostRequestAtPath:[LTUQuery resourceListPath]];
}

- (void)getVisualById:(NSInteger)visualID
              success:(void (^)(LTUVisual *createdVisual))success
              failure:(void (^)(NSError *error))failure
             finished:(void (^)())finished

{
    [self.client getResourceOfType:[LTUVisual class]
                            withId:visualID
                           success:^(LTUResourceData *responseData)
     {
         if (success) {
             success((LTUVisual *)responseData);
             finished();
         }
     }
                           failure:^(NSError *error)
     {
         if (failure) {
             failure(error);
             finished();
         }
     }];
}

- (void)getVisualByName:(NSString *)visualName
              inProject:(NSInteger)projectId
                success:(void (^)(LTUVisual *foundVisual))success
                failure:(void (^)(NSError *error))failure
               finished:(void (^)())finished
{
    NSString *url = [NSString stringWithFormat:@"%@projects/%i/visuals/", kLTURootAPIPath, projectId];
    [self.client getResourceListOfType:[LTUVisual class]
                                 atUrl: url
                        withParameters:@{@"name" : visualName}
                               success:^(NSArray *visualList)
     {
         if (success) {
             if (visualList == nil || [visualList count] == 0) {
                 success(nil);
             } else {
                 success((LTUVisual *)[visualList firstObject]);
             }
             finished();
         }
     }
                               failure:^(NSError *error)
     {
         if (failure) {
             failure(error);
             finished();
         }
     }];
}

- (void)getImageInVisual:(NSInteger)visualID
              withSource:(NSString *)source
                 success:(void (^)(LTUImage *foundImage))success
                 failure:(void (^)(NSError *error))failure
                finished:(void (^)())finished
{
    NSString *url = [NSString stringWithFormat:@"%@projects/visuals/%ld/images/", kLTURootAPIPath, (long)visualID];
    [self.client getResourceListOfType:[LTUImage class]
                                 atUrl: url
                        withParameters:@{@"source" : source}
                               success:^(NSArray *imageList)
     {
         if (success) {
             if (imageList == nil || [imageList count] == 0) {
                 success(nil);
             } else {
                 success((LTUImage *)[imageList firstObject]);
             }
             finished();
         }
     }
                               failure:^(NSError *error)
     {
         if (failure) {
             failure(error);
             finished();
         }
     }];

}

- (void)createVisualInProject:(NSInteger)projectID
                    withTitle:(NSString *)title
                    withImage:(UIImage *)image
                  andMetadata:(NSArray*)metadataArray
                      success:(void (^)(LTUVisual *createdVisual))success
                      failure:(void (^)(NSError *error))failure
                     finished:(void (^)())finished
          uploadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))uploadProgressBlock
{
  LTUVisual *visualData = [[LTUVisual alloc] initWithProject:projectID
                                                   withTitle:title image:image
                                                 imageSource:kLTUSource
                                                 andMetaData:metadataArray];
  [self.client createResourceWithData:visualData
    success:^(LTUResourceData *responseData) {
      if (success) {
        success((LTUVisual *)responseData);
        finished();
      }
    }
    failure:^(NSError *error) {
      if (failure) {
        failure(error);
        finished();
      }
    }
uploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
   {
       if (uploadProgressBlock) {
           uploadProgressBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
       }
   }];
}

- (void)addImage:(UIImage *)image
        inVisual:(NSInteger)visualId
      withSource:(NSString *)source
        withName:(NSString *)name
         success:(void (^)(LTUImage *createdImage))success
         failure:(void (^)(NSError *error))failure
        finished:(void (^)())finished
uploadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))uploadProgressBlock
{
    LTUImage *imageData = [[LTUImage alloc] init];
    imageData.image = image;
    imageData.visual_id = visualId;
    imageData.source = source;
    imageData.name = name;

    [self.client createResourceWithData:imageData
                                success:^(LTUResourceData *responseData)
     {
         if (success) {
             success((LTUImage *)responseData);
             finished();
         }
     }
                                failure:^(NSError *error)
     {
         if (failure) {
             failure(error);
             finished();
         }
     }
                    uploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         if (uploadProgressBlock) {
             uploadProgressBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
         }
     }
     ];
}


- (void)cancelAllRequests
{
  [self.client cancelAllRequests];
}

@end
