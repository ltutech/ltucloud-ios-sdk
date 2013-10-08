//
//  LTUResourceData.m
//
//  Created by Adam Bednarek on 5/10/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUResourceData.h"

@implementation LTUAttachment

- (id)initWithFieldName:(NSString *)fieldName andData:(NSData *)fieldData
{
  if ((self = [super init]))
  {
    self.fieldName = fieldName;
    self.fieldData = fieldData;
  }
  return self;
}

@end

@implementation LTUResourceData

+ (NSString *)resourceListPath
{
  @throw @"Not Implemented";
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super init]))
  {
    self.links = attributes[@"_links"];
  }
  return self;
}

- (NSDictionary *)getAttachment
{
  return nil;
}

- (NSDictionary *)getResourceParams
{
  @throw @"Not Implemented";
}

- (NSString *)resourceCreatePath
{
  @throw @"Not Implemented";
}

- (NSString *)resourcePath
{
  if (!self.links[@"self"])
  {
    return nil;
  }
  // Parse the path out from the links URL
  // Must append the slash because it's stripped using the NSURL path method
  return [NSString stringWithFormat:@"%@/", [[NSURL URLWithString:self.links[@"self"]] path]];
}

- (UIImage *)fetchImageWithURL:(NSURL *)url
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}

@end
