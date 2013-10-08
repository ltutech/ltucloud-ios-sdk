//
//  LTUImage.m
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUImage.h"

#define kImageCompression 0.8

@implementation LTUImage

- (NSData *)getImageData
{
  if ([self imageData] == nil)
  {
    self.imageData = UIImageJPEGRepresentation(self.image, kImageCompression);
  }
  return self.imageData;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    // We don't load the image data here
    self.image      = nil;
    self.imageData  = nil;
    self.image_id   = [attributes[@"id"] intValue];
    self.media      = attributes[@"_media"];
    self.source     = attributes[@"source"];
  }
  return self;
}

- (UIImage *)image
{
    if (_image == nil) {
        _image = [self fetchImageWithURL:[NSURL URLWithString:[self.media objectForKey:@"image"]]];
    }
    
    return _image;
}

@end
