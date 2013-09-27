//
//  LTUMatchedVisual.m
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUMatchedVisual.h"
#import "LTUMatchedImage.h"

@implementation LTUMatchedVisual

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super init]))
  {
    NSMutableArray *matchedImages = [[NSMutableArray alloc] init];
    for (NSDictionary *matchedImageAttribs in attributes[@"matched_visual"][@"matched_images"])
    {
      [matchedImages addObject:[[LTUMatchedImage alloc] initWithAttributes:matchedImageAttribs]];
    }
    self.matched_images = [[NSArray alloc] initWithArray:matchedImages];
    self.matched_visual = [[LTUVisual alloc] initWithAttributes:attributes[@"matched_visual"]];
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"NB Images: %d Visual: %@",[self.matched_images count], self.matched_visual];
}

@end
