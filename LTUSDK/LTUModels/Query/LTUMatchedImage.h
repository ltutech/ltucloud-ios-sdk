//
//  LTUMatchedImage.h
//
//  Created by Adam Bednarek on 5/9/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"

/**
 The LTUMatchedImage is an image that was matched by a query image
 */
@interface LTUMatchedImage : LTUResourceData

/**
 The Image that was matched.  This is downloaded when called for the first time.
 */
@property (nonatomic, strong) UIImage       *image;
@property (nonatomic, strong) UIImage       *thumbnail;
/**
 Stores the links to the actual image and thumbnail
 */
@property (nonatomic, strong) NSDictionary  *media;
/**
 The result info contains information about the matched image, such as bounding boxes of where the image matched
 */
@property (nonatomic, strong) NSDictionary  *result_info;
/**
 The matching score of the image
 */
@property (nonatomic, strong) NSNumber      *score;

@end
