//
//  LTUVisual.h
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"

/**
 The `LTUVisual` is the object that contains all the information linked to an image or set of images
 */
@interface LTUVisual : LTUResourceData

/**
 Array of `LTUImage`
 */
@property (nonatomic, strong) NSArray       *images;
/**
 The links to the first image/thumbnail
 */
@property (nonatomic, strong) NSDictionary  *media;
/**
 Array of `LTUMetaData`
 */
@property (nonatomic, strong) NSArray       *metadataList;
/**
 The ID of an `LTUProject` the `LTUVisual` is associated with
 */
@property NSInteger                         project_id;
/**
 The name is an optional identifier that must be unique with each `LTUProject`
 */
@property (nonatomic, strong) NSString      *name;
/**
 Title that describes what the `LTUVisual` is.
 */
@property (nonatomic, strong) NSString      *title;
/**
 User that owns the `LTUVisual`
 */
@property (nonatomic, strong) NSString      *user;
/**
 ID of the `LTUVisual`
 */
@property NSInteger                         visual_id;


/**
 Initialize an `LTUVisual` object that can be used to create a visual

 @param project The Project ID that the visual will be added to
 @param title The title of an `LTUVisual`
 @param image The image linked to the `LTUVisual`
 @param imageSource The source where the image came from for the visual
 @param metadataList List of `LTUMetadata` / `LTUVisual` details to associate with an `LTUVisual`
 */
- (id)initWithProject:(NSInteger)projectID
            withTitle:(NSString *)title
                image:(UIImage *)image
          imageSource:(NSString *)imageSource
          andMetaData:(NSArray *)metadataList;

@end
