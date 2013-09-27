//
//  LTUProject.m
//
//  Created by Adam Bednarek on 5/29/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUProject.h"

@implementation LTUProject

+ (NSString *)resourceListPath
{
  return [NSString stringWithFormat:@"%@projects/", kLTURootAPIPath];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    self.nbVisuals        = [attributes[@"nb_visuals"] intValue];
    self.projDescription  = attributes[@"description"];
    self.project_id       = [attributes[@"id"] intValue];
    self.title            = attributes[@"title"];
    self.user             = attributes[@"user"];
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Project ID: %d, Description: %@, Title: %@, User: %@",self.project_id, self.projDescription, self.title, self.user];
}

@end
