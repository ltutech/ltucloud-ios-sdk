//
//  LTUMetaData.m
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUMetaData.h"

@implementation LTUMetaData

- (id)initWithValue:(NSString *)value forKey:(NSString *)key andOrdering:(NSInteger)ordering
{
  if ((self = [self init]))
  {
    // Set Defaults for optional params
    self.ordering = ordering;
    self.value    = value;
    self.key      = key;
  }
  return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    self.key          = attributes[@"key"];
    self.metadata_id  = [attributes[@"id"] intValue];
    self.ordering     = [attributes[@"ordering"] intValue];
    self.user         = attributes[@"user"];
    self.value        = attributes[@"value"];
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Metadata: %@ => %@",self.key, self.value];
}

@end
