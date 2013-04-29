//
//  LTUImage.h
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"

/**
 The `LTUImage` is a reference image in an `LTUVisual`
 */
@interface LTUImage : LTUResourceData

/**
 The `UIImage` representing the image.  If getting the LTUImage from lookthatup, the image has to be downloaded separately.
 */
@property (nonatomic, strong) UIImage       *image;
/**
 The Visual Image Data used to send to lookthatup.  This is meant to be an already compressed and processed `UIImage`
 */
@property (nonatomic, strong) NSData        *imageData;
/**
 The Image ID in lookthatup
 */
@property NSInteger                         image_id;
/**
  The links to the visual image, and thumbnail of the image.
 */
@property (nonatomic, strong) NSDictionary  *media;
/**
 Source on where the image came from.  This is an optional field and can sometimes be nil.
 */
@property (nonatomic, strong) NSString      *source;
/**
 The `LTUVisual` ID that the `LTUImage` is linked to
 */
@property NSInteger                         visual_id;

/**
 Helper method to get/convert the Image Data from the `UIImage` image property
 */
- (NSData *)getImageData;

@end
