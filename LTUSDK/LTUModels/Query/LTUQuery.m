//
//  LTUQuery.m
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUQuery.h"
#import "LTUMatchedVisual.h"

#define kQueryImageCompression  0.8

@implementation LTUQueryStatus

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super init]))
  {
    self.code     = [attributes[@"code"] intValue];
    self.isError  = [attributes[@"is_error"] boolValue];
    self.name     = attributes[@"name"];
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Status Code: %d , Is Error? %d, Name: %@",
          self.code,
          self.isError,
          self.name];
}

@end

@implementation LTUQuery

+ (NSString *)resourceListPath
{
  return [NSString stringWithFormat:@"%@queries/", kLTURootAPIPath];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    NSMutableArray *matchedVisuals = [[NSMutableArray alloc] init];
    for (NSDictionary *matchedVisualAttribs in attributes[@"matches"] )
    {
      [matchedVisuals addObject:[[LTUMatchedVisual alloc] initWithAttributes:matchedVisualAttribs]];
    }
    self.matchesList  = [[NSArray alloc] initWithArray:matchedVisuals];
    self.media        = attributes[@"_media"];
    self.query_id     = [attributes[@"id"] intValue];
    self.status       = [[LTUQueryStatus alloc] initWithAttributes:attributes[@"status"]];
    self.source_description = attributes[@"source_description"];
    self.source       = attributes[@"source"];
    self.user         = attributes[@"user"];

  }
  return self;
}

- (id)initWithImage:(UIImage *)image
           projects:(NSArray *)projects
             source:(NSString *)source
         sourceDesc:(NSString *)sourceDesc
{
  if ((self = [super init]))
  {
    self.image = UIImageJPEGRepresentation(image, kQueryImageCompression);
    // If the project is nil or empty, it will search all default projects
    if (projects)
    {
      self.projects = projects;
    }
    if (source)
    {
      self.source = source;
    }
    if (sourceDesc)
    {
        NSLog(@"%@", sourceDesc);
       self.source_description = sourceDesc;
    }
  }
  return self;
}

- (LTUAttachment *)getAttachment
{
  if (!self.image)
  {
    return nil;
  }
  return [[LTUAttachment alloc] initWithFieldName:@"image" andData:self.image];
}

- (NSDictionary *)getResourceParams
{
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

  // If projects is not set, it will search all default projects
  if (self.projects)
  {
    params[@"projects"] = self.projects;
  }
  if (self.source)
  {
    params[@"source"] = self.source;
  }
  if (self.source_description)
  {
    params[@"source_description"] = self.source_description;
  }
  return [NSDictionary dictionaryWithDictionary:params];
}

- (NSString *)resourceCreatePath
{
  return [[self class] resourceListPath];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Nb Results: %d, MatchedList: %@",[self.matchesList count], self.matchesList];
}

@end
