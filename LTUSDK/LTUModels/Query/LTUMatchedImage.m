//
//  LTUMatchedImages.m
//
//  Created by Adam Bednarek on 5/9/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import "LTUMatchedImage.h"


@implementation LTUMatchedImage

- (id)initWithAttributes:(NSDictionary *)attributes
{
  if ((self = [super initWithAttributes:attributes]))
  {
    // We don't download the image here
    self.image        = nil;
    self.media        = attributes[@"_media"];
    self.result_info  = attributes[@"result_info"];
    self.score        = attributes[@"score"];
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

- (UIImage *)thumbnail
{
    if (_thumbnail == nil) {
        _thumbnail = [self fetchImageWithURL:[NSURL URLWithString:[self.media objectForKey:@"thumbnail"]]];
    }
    
    return _thumbnail;
}

@end
