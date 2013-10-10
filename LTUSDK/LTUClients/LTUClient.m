//
//  LTUClient.m
//
//  Created by Adam Bednarek on 5/10/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "LTUClient.h"

static LTUClient *_sharedClient = nil;

@interface LTUClient ()

// The AFHTTPClient
@property (nonatomic, strong) AFHTTPClient  *afClient;
// Authentication Header
@property (nonatomic, strong) NSString      *authHeader;

@end

@implementation LTUClient

- (BOOL)isRequestInProgress
{
  if (self.afClient.operationQueue.operationCount > 0)
  {
    return YES;
  }
  return NO;
}

+ (void)setSharedClient:(LTUClient *)sharedClient
{
  _sharedClient = nil;
  _sharedClient = sharedClient;
}

+ (LTUClient *)sharedClient
{
  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url withUser:(NSString *)user andPassword:(NSString *)password
{
  if ((self = [super init]))
  {
    self.afClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [self.afClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self.afClient setDefaultHeader:@"Accept" value:@"application/json"];
    [self updateUser:user andPassword:password];
  }
  return self;
}

- (void)updateUser:(NSString *)user andPassword:(NSString *)password
{
  [self.afClient setAuthorizationHeaderWithUsername:user password:password];
}

- (void)getResourceOfType:(Class)rType
                   withId:(NSInteger)resourceId
                  success:(void (^)(LTUResourceData *resource))success
                  failure:(void (^)(NSError *error))failure
{
    if (![rType isSubclassOfClass:[LTUResourceData class]]) {
        @throw @"Expected LTUResourceData as Type";
    }
    // Use multipartFormRequestWithMethod..
    NSString *urlPath = [rType resourceListPath];
    urlPath = [urlPath stringByAppendingString:[NSString stringWithFormat:@"%d", resourceId]];
    NSMutableURLRequest *request = [self.afClient requestWithMethod:@"GET"
                                                               path:urlPath
                                                         parameters:nil];
    // Shorten the timeout interval, default is 60 seconds.
    request.timeoutInterval = 30;
    AFHTTPRequestOperation *operation = [self.afClient HTTPRequestOperationWithRequest:request
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (success) {
             success([[[rType class] alloc] initWithAttributes:responseObject]);
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         // Failure block is optional
         if (failure)
         {
             failure(error);
         }
     }];
    
    // Ignoring bad SSL certificates should be removed once we have valid certificates
    // TODO: Remove once in production
    [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace)
     {
         return YES;
     }];
    [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge)
     {
         [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
     }];
    
    [self.afClient enqueueHTTPRequestOperation:operation];
}


- (void)getResourceListOfType:(Class)rType
                      success:(void (^)(NSArray *resourceList))success
                      failure:(void (^)(NSError *error))failure
{
  if (![rType isSubclassOfClass:[LTUResourceData class]])
  {
    @throw @"Expected LTUResourceData as Type";
  }
  // Use multipartFormRequestWithMethod..
  NSMutableURLRequest *request = [self.afClient requestWithMethod:@"GET"
                                                             path:[rType resourceListPath]
                                                       parameters:nil];
  // Shorten the timeout interval, default is 60 seconds.
  request.timeoutInterval = 30;

  AFHTTPRequestOperation *operation = [self.afClient HTTPRequestOperationWithRequest:request
  success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
    NSMutableArray *resourceList = [[NSMutableArray alloc] init];
    for (NSDictionary *attributes in responseObject[@"results"])
    {
      [resourceList addObject:[[[rType class] alloc] initWithAttributes:attributes]];
    }
    // Success block is optional
    if (success)
    {
      success(resourceList);
    }
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
    // Failure block is optional
    if (failure)
    {
      failure(error);
    }
  }];

  // Ignoring bad SSL certificates should be removed once we have valid certificates
  // TODO: Remove once in production
  [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace)
   {
     return YES;
   }];
  [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge)
  {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
  }];

  [self.afClient enqueueHTTPRequestOperation:operation];
}

- (void)createResourceWithData:(LTUResourceData *)rData
                       success:(void (^)(LTUResourceData *responseData))success
                       failure:(void (^)(NSError *error))failure
{
  // Use multipartFormRequestWithMethod..
  NSMutableURLRequest *request = [self.afClient multipartFormRequestWithMethod:@"POST"
                                                                 path:[rData resourceCreatePath]
                                                           parameters:[rData getResourceParams]
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                            {
                                              LTUAttachment *attachment = [rData getAttachment];
                                              if (attachment)
                                              {
                                                [formData appendPartWithFileData:attachment.fieldData
                                                                            name:attachment.fieldName
                                                                        fileName:@"image.jpg"
                                                                        mimeType:@"image/jpeg"];
                                              }
                                            }];
  AFHTTPRequestOperation *operation = [self.afClient HTTPRequestOperationWithRequest:request
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
      // The passed rData class , ex: visual, or query is the response type we expect
      LTUResourceData *responseData = [[[rData class] alloc] initWithAttributes:(NSDictionary *)responseObject];
      success(responseData);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
      failure(error);
    }];
  [self.afClient enqueueHTTPRequestOperation:operation];
}

- (void)cancelPostRequestAtPath:(NSString*)path
{
  [self.afClient cancelAllHTTPOperationsWithMethod:@"POST" path:path];
}

- (void)cancelAllRequests
{
  [self.afClient.operationQueue cancelAllOperations];
}

@end
