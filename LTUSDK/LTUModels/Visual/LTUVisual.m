//
//  LTUVisual.m
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUVisual.h"

#import "LTUImage.h"
#import "LTUProject.h"
#import "LTUMetaData.h"

@implementation LTUVisual

+ (NSString *)resourceListPath
{
  return [NSString stringWithFormat:@"%@projects/visuals/", kLTURootAPIPath];
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    self.visual_id    = [attributes[@"id"] intValue];

    NSMutableArray *metadataList = [[NSMutableArray alloc] init];
    for (NSDictionary *metadataAttribs in attributes[@"metadata"] )
    {
      LTUMetaData *metadata = [[LTUMetaData alloc] initWithAttributes:metadataAttribs];
      metadata.visual_id = self.visual_id;
      [metadataList addObject:metadata];
    }
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (NSDictionary *imageAttribs in attributes[@"images"] )
    {
      LTUImage *image = [[LTUImage alloc] initWithAttributes:imageAttribs];
      image.visual_id = self.visual_id;
      [imageList addObject:image];
    }

    self.images       = [[NSArray alloc] initWithArray:imageList];
    self.media        = attributes[@"_media"];
    self.metadataList = [[NSArray alloc] initWithArray:metadataList];
    self.name         = attributes[@"name"];
    self.project_id   = [attributes[@"project_id"] intValue];
    self.title        = attributes[@"title"];
    self.user         = attributes[@"user"];
  }
  return self;
}

- (id)initWithProject:(NSInteger)projectID
            withTitle:(NSString *)title
                image:(UIImage *)image
          imageSource:(NSString *)imageSource
          andMetaData:(NSArray *)metadataList
{
  if ((self = [super init]))
  {
    LTUImage *ltuImage = [[LTUImage alloc] init];
    ltuImage.source = imageSource;
    ltuImage.image = image;

    self.project_id = projectID;
    self.title = title;
    self.metadataList = metadataList;
    self.images = [NSArray arrayWithObject:ltuImage];
  }
  return self;
}

- (LTUAttachment *)getAttachment
{
  if (!self.images)
  {
    return nil;
  }
  return [[LTUAttachment alloc] initWithFieldName:@"images-image" andData:[self.images[0] getImageData]];
}

- (NSDictionary *)getResourceParams
{
  NSMutableDictionary *resourceParams = [[NSMutableDictionary alloc] init];
  int metaIndex = 0;
  for (LTUMetaData *metadata in self.metadataList)
  {
    [resourceParams setObject:metadata.key forKey:[NSString stringWithFormat:@"metadata-%d-key", metaIndex]];
    [resourceParams setObject:metadata.value forKey:[NSString stringWithFormat:@"metadata-%d-value", metaIndex]];
    metaIndex ++;
  }
  // Get the image source, by default we always use the first image for queries
  if (self.images) {
    [resourceParams setObject:[self.images[0] source] forKey:@"images-source"];
  }

  [resourceParams setObject:self.title forKey:@"title"];
  if (self.name)
  {
    [resourceParams setObject:self.name forKey:@"name"];
  }

  return [NSDictionary dictionaryWithDictionary:resourceParams];
}

- (NSString *)resourceCreatePath
{
  return [NSString stringWithFormat:@"%@projects/%d/visuals/", kLTURootAPIPath, self.project_id];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Visual: %@ ProjectID: %d | Metadata: %@", self.title, self.project_id, self.metadataList];
}

@end
