//
//  LTUMetaData.h
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"

/**
 The `LTUMetaData` is the metadata / info linked to an `LTUVisual`.  The `LTUMetadata` in lookthatup are stored in a Key-Value fashion.
 */
@interface LTUMetaData : LTUResourceData

/**
 The Key of a particular metadata, for example a "URL" can be a key describing what the value will be.
 */
@property (nonatomic, strong) NSString      *key;
/**
 The ID associated with this metadata
 */
@property NSInteger                         metadata_id;
/**
 The ordering used when wanting to have the info listed in a special order.
 */
@property NSInteger                         ordering;
/**
 The user who owns the metadata
 */
@property (nonatomic, strong) NSString      *user;
/**
 The Value that is associated with the metadata, such as a message or url to a website
 */
@property (nonatomic, strong) NSString      *value;
/**
 The `LTUVisual` ID that the metadata is linked to.
 */
@property NSInteger                         visual_id;

/**
 Initialize a metadata object with a particular Key and Value and ordering

 @param value The value of the metadata
 @param key The key that describes the value
 @param ordering The order you want to place this metadata in when it's returned in a result
 @return The newly created `LTUMetaData` that can be used to add to an `LTUVisual` that will be created
 */
- (id)initWithValue:(NSString *)value forKey:(NSString *)key andOrdering:(NSInteger)ordering;

@end
