//
//  LTUQuery.h
//
//  Created by Adam Bednarek on 5/7/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTUResourceData.h"

/**
 The `LTUQueryStatus` represents "status" for the query being made.
 */
@interface LTUQueryStatus : NSObject

/**
 Status code
 */
@property (nonatomic, assign) NSInteger code;
/**
 Was the status an error or not?
 */
@property (nonatomic, assign) BOOL      isError;
/**
 Human readable name describing the status
 */
@property (nonatomic, strong) NSString  *name;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end

/**
 The `LTUQuery` represents the object that we use to send a query to lookthatup, and the result of a query that was sent.
 */
@interface LTUQuery : LTUResourceData

/**
 The Query Image Data used to send to lookthatup.  This is meant to be an already compressed and processed `UIImage`
 */
@property (nonatomic, strong) NSData        *image;
/**
 An array of `LTUMatchedVisual`s, if it's empty, there was no match
 */
@property (nonatomic, strong) NSArray       *matchesList;
/**
 The links to the query image, and thumbnail of the image that was already sent.
 */
@property (nonatomic, strong) NSDictionary  *media;
/**
 An array of `NSNumber` representing the project ID's to perform a query in.
 */
@property (nonatomic, strong) NSArray       *projects;
/**
 After performing a query, or getting the query resource, there is an ID associated with that Query in lookthatup
 */
@property NSInteger                         query_id;
/**
 The source where the query came from
 */
@property (nonatomic, strong) NSString      *source;
/**
 The returned status of the Query to lookthatup
 */
@property (nonatomic, strong) LTUQueryStatus *status;
/**
 The user who performed the query
 */
@property (nonatomic, strong) NSString      *user;

/**
 Initialize an `LTUQuery` object to be ready for performing a query on lookthautp

 @param image The UIImage that was captured, and will be transformed into a proper NSData optimized for sending to lookthatup
 @param projects List of Project IDs, if set to nil, it will query all default projects (optional)
 @param source The source where the query came from (optional)
 */
- (id)initWithImage:(UIImage *)image
                 projects:(NSArray *)projects
                  source:(NSString *)source;

@end
