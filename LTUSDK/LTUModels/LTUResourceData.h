//
//  LTUResourceData.h
//
//  Created by Adam Bednarek on 5/10/12.
//  Copyright (c) 2012 LTU Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

// The base API Resource path
#define kLTURootAPIPath @"/api/v1/"

/**
 The `LTUAttachment` class is a simple structure to contain an attachment such as field name and data
 */
@interface LTUAttachment : NSObject

/**
 The field name of an attachment in a POST request
 */
@property (nonatomic, strong) NSString *fieldName;
/**
 The data of the attachment
 */
@property (nonatomic, strong) NSData   *fieldData;

/**
 Initializes the `LTUAttachment` with a field name and data

 @discussion This is the designated initializer ot be used witht he `LTUAttachment` object

 @param fieldName The name of the field on a form for the POST request
 @param fieldData The data of a file to be sent
 */
- (id)initWithFieldName:(NSString *)fieldName andData:(NSData *)fieldData;

@end


/**
 This is a dummy class so all the `LTUResourceData` objects share the same parent object
 */
@interface LTUResourceData : NSObject

/**
 The links that all resource have, including it's own link, and links to other resources that it's linked with
 */
@property (nonatomic, strong) NSDictionary *links;

/**
 Get the resource path that will get a listing of that resource
 @return string of the resource path
 */
+ (NSString *)resourceListPath;

/**
 Initialize the `LTUResourceData` object with a dictionary of attributes.

 @discussion This initializor is mostly used by the `LTUClient` to create the specific `LTUResourceData` object.  This is more of an interface to be implemented by a specific resource object subclassing the `LTUResourceData`

 @param attributes These attributes is an `NSDictionary` from the convertion of the JSON result
 @return Thew newly created `LTUResourceData` object
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

/**
 Get the attachments of a resource.  Used for when sending an image.

 @return LTUAttachment object with the data and field name
 */
- (LTUAttachment *)getAttachment;

/**
 Gets the resource parameters.

 @discussion To create/post the resource, we need to convert the object into something we can upload.  This more or less "serializes" the object into a dictionary.

 @return An `NSDictionary` containing the parameters to be sent via POST method.
 */

- (NSDictionary *)getResourceParams;
/**
 Helper method to gets the specific resource path that would be used to do a "POST" on it.

 @return string of a resource path
 */
- (NSString *)resourceCreatePath;


/**
 Helper method to get a specific resource path.  This basically gets the resource from links[@"self"]
 @return string of the specific resource path
 */
- (NSString *)resourcePath;


- (UIImage *)fetchImageWithURL:(NSURL *)url;

@end
