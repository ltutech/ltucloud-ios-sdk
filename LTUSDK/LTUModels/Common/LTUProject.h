//
//  LTUProject.h
//
//  Created by Adam Bednarek on 5/29/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTUResourceData.h"

/**
 The `LTUProject` that represents a project resource in lookthatup
 */
@interface LTUProject : LTUResourceData

/**
 The number of Visuals in a project
 */
@property                     NSInteger     nbVisuals;
/**
 The Project Description
 */
@property (nonatomic, strong) NSString      *projDescription;
/**
 The ID of the project
 */
@property                     NSInteger     project_id;
/**
 Title of the project
 */
@property (nonatomic, strong) NSString      *title;
/**
 The user the project belongs to
 */
@property (nonatomic, strong) NSString      *user;

@end
