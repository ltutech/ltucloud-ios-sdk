//
//  LTUMatchedVisual.h
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"
#import "LTUVisual.h"

/**
 The `LTUMatchedVisual` contains the information of a visual and set of images that a query matched on.
 */
@interface LTUMatchedVisual : LTUResourceData

/**
 The array of `LTUMatchedImage`s
 */
@property (nonatomic, strong) NSArray *matched_images;
/**
 The `LTUVisual` object that was matched
 */
@property (nonatomic, strong) LTUVisual *matched_visual;

@end
