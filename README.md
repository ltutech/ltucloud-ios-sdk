LTU Mobile iOS SDK
==================

This guide will help you get started on using the LTU Cloud API with your iPhone
app via the LTU Mobile iOS SDK.  The provided sample code uses ARC.


Requirements
------------

The LTU Mobile iOS SDK library is built for use with iOS 5 and up.  The sample
projects require XCode 4.5 and up.  It uses AFNetworking (which is provided by
the LTU SDK).

The LTU SDK also uses the following frameworks:

* AVFoundation
* CoreImage
* CoreMedia
* CoreVideo


Setup
-----

Before you get started on coding and using the LTU Mobile iOS SDK, you must set
up your Xcode project. We suggest that you add the LTU SDK as a submodule of
your project.

This setup is done in a few simple steps:


* Drag the LTUSDK.xcodeproj inside your Xcode project.

* Link all the required iOS Frameworks specified above:
  - AVFoundation
  - CoreImage
  - CoreMedia
  - CoreVideo
  - libLTUSDK-lib.a

* Add "$(SRCROOT)" with the recursive option to the Build Settings variable
  "User Header Search Paths". This is used for finding LTUSDK headers during
  compilation and archiving (the LTUSDK directory must be contained inside
  your source directory).



Usage
-----

Import the LTUManager header for accessing all the classes and helper methods:

    #import "LTUManager.h"


#####Initialize Shared LTUManager

This can be done in the app delegate.  The shared manager will let you send
queries, create visuals and get a list of your projects.

```objc
[LTUManager initializeSharedLTUManagerWithUsername:@"myUsername"
                                       andPassword:@"myPassword"];
```

#####Using the LTUCameraView

The LTU Mobile iOS SDK provides you with robust camera functionality.  The
LTUCameraView is a subclass of UIView with extra functionality, such as
previewing the camera, and ability to capture images instantly from the camera.
The LTUCameraView can be added via StoryBoard by using the LTUCameraView instead
of UIView, and assigning an outlet to the ViewController.  It can also be added
programmatically as such in the viewDidLoad:

```objc
// The Camera preview has an aspect ratio of 1.3, the screen aspect ratio
// has an aspect ratio of the height / width.  This changes between iPhone 4, 5 and iPad)
// To fit the preview nicely, we normalize this by making the preview frame wider
CGFloat screenAspectRatio = self.view.frame.size.height / self.view.frame.size.width;
CGFloat normalizeRatio = screenAspectRatio / 1.3;
CGRect cameraFrame = CGRectMake(0,
                                0,
                                self.view.frame.size.width * normalizeRatio,
                                self.view.frame.size.height);
self.camView = [[LTUCameraView alloc] initWithFrame:cameraFrame];
[self.view insertSubview:self.camView atIndex:0];
```

You can pause the camera preview as follows:

```objc
[self.camView pausePreview];
```

By default the preview is already started, but if paused manually, it can be
started again:

```objc
[self.camView startPreview];
```

To capture the image from the LTUCameraView:

```objc
UIImage *image = [self.camView captureImage];
```

#####Get Project Listing

All your projects can be retrieved via the LTU API as follows:

```objc
[[LTUManager sharedManager] getProjectsWithSuccess:^(NSArray *projectList) {
        // Store projects somewhere
    }

    failure:^(NSError *error) {
        // Handle error
    }

    finished:^ {
        // Shared code on project request completion.
    }];
```


#####Searching Images

The following is an example on how to search an image within a project:

```objc
UIImage *image = [self.camView captureImage];
NSArray *projectIDs = @[@8];
[[LTUManager sharedManager] searchInProjects:projectIDs
                                   withImage:image
                                  withSource:(NSString *)source // User-defined field (user id for instance)
                              withSourceDesc:(NSString *)sourceDesc
                                 withTimeout:(int)timeout
    success:^(LTUQuery *queryResult) {
        // Parse Results
    }

    failure:^(NSError *error) {
        // Handle error
    }

    finished:^ {
        // Shared code on Search Image request completion.
    }
    uploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        // Always executed after the success/failure blocks
    }];
```

#####Creating Visuals

To Create a Visual you must collect an array of LTUMetaData objects, and pass it
to the LTUManager's createVisual method:

```objc
UIImage *image = [self.camView captureImage];
LTUMetaData *myData = [[LTUMetaData alloc] initWithValue:@"message"
                                                  forKey:@"Some Message"
                                             andOrdering:0];

NSArray *myMetadata = @[myData];
[[LTUManager sharedManager] createVisualInProject:6
                                        withTitle:@"FooTitle"
                                        withImage:image
                                      andMetadata:myMetadata
    success:^(LTUVisual *createdVisual) {
        // Handle events when visual is created
    }

    failure:^(NSError *error) {
        // Handle error
    }

    finished:^ {
        // Shared code on Creating Visual request completion.
    }
    uploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
      // Always executed after the success/failure blocks
    }];

```

#####Canceling Requests

There are 2 helper methods to help cancel requests.

You can cancel all current searchImage requests:

```objc
[[LTUManager sharedManager] cancelAllSearchRequests];
```

You can also cancel all requests which includes getting a project list, creating
visuals, and searching images:

```objc
[[LTUManager sharedManager] cancelAllRequests];
```

Class Overview
--------------

More detailed documentation about each class can be found under the docs/ folder
provided with the SDK.
